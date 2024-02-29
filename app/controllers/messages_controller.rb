class MessagesController < ApplicationController
  layout 'application_v_2'

  def index
    @folder = params[:folder] || "inbox"

    @conversations = case @folder
                     when "inbox"
                       current_user.mailbox.inbox + current_user.managers.map do |manager| manager.location.mailbox.inbox end.flatten + current_user.business_improvement_areas.map do |bia| bia.mailbox.inbox end.flatten
                     when "sent"
                       current_user.mailbox.sentbox + current_user.managers.map do |manager| manager.location.mailbox.sentbox end.flatten + current_user.business_improvement_areas.map do |bia| bia.mailbox.sentbox end.flatten
                     when "trash"
                       current_user.mailbox.trash + current_user.managers.map do |manager| manager.location.mailbox.trash end.flatten + current_user.business_improvement_areas.map do |bia| bia.mailbox.trash end.flatten
                     end
    @conversations = @conversations.sort_by(&:updated_at).reverse unless @conversations.nil?

    add_breadcrumb "Messaging"
    add_breadcrumb t("messaging.#{@folder}"), url_for(folder: params[:folder])
  end

  def show
    @conversation = Mailboxer::Conversation.find_by_id params[:id]

    current_manager = current_user
    if !@conversation.is_participant? current_manager
      current_manager = manager @conversation, current_user.managers.map(&:location) + current_user.business_improvement_areas
    end

    unless @conversation.is_participant? current_manager
      flash[:alert] = "You do not have permission to view that conversation."
      return redirect_to action: :index
    end

    @message = Message.new conversation_id: @conversation.id

    current_manager.mark_as_read @conversation

    add_breadcrumb "Messaging"
    add_breadcrumb @conversation.subject, url_for(@conversation)
  end

  def new
    @message = Message.new

    setup_recipients_and_path

    render :new, layout: false
  end

  def create
    @message = Message.new params[:message]

    setup_recipients_and_path

    if @message.conversation_id.present?
      @conversation = Mailboxer::Conversation.find @message.conversation_id

      unless @message.valid?
        return render :show
      end

      current_manager = current_user
      if !@conversation.is_participant? current_manager
        current_manager = manager @conversation, current_user.managers.map(&:location) + current_user.business_improvement_areas
      end

      unless @conversation.is_participant? current_manager
        return redirect_back
      end

      receipt = current_manager.reply_to_conversation @conversation, @message.body
    else
      @message.recipients = Location.where(id: @message.recipients.to_s.split(',')) if @message.recipients

      unless @message.valid?
        @message.recipients = @message.recipients.map(&:id).join(",")
        return render :new, layout: false
      end

      receipt = @from.send_message @message.recipients, @message.body, @message.subject
    end

    respond_to do |format|
      format.js
      format.html { redirect_to receipt.conversation }
    end
  end

  def destroy
    conversation = Mailboxer::Conversation.find_by_id params[:id]

    if conversation.is_participant? current_user
      if conversation.is_trashed? current_user
        current_user.mark_as_deleted conversation
      else
        current_user.trash conversation
      end
    end

    current_manager = manager conversation, current_user.managers.map(&:location) + current_user.business_improvement_areas
    if current_manager
      if conversation.is_trashed? current_manager
        current_manager.mark_as_deleted conversation
      else
        current_manager.trash conversation
      end
    end

    redirect_back
  end

  def messenger
    @current_profile = current_user.profile
    @conversations = Conversation.includes(:recipient, :messages).where("recipient_id = ? OR sender_id = ?", @current_profile.id, @current_profile.id)

    location_ids = Favorite.where(user_id: current_user).pluck(:location_id).compact
    @chat_boxes = Location.unscoped.joins(:vertical_market_categories)
                          .where(id: location_ids, is_profile: true)
                          .reject { |box| box.id.in?(@conversations.map{|c| [c.recipient.id, c.sender.id] }.flatten) }

    if params[:recipient].present?
      @recipient_profile = Location.unscoped.find_by_slug(params[:recipient])
      @conversation = Conversation.lookup(@current_profile.id, @recipient_profile.id)
      @messages = @conversation.messages
    end
  end

  def send_message
    @conversation = Conversation.includes(:recipient).find(params[:id])
    @message = @conversation.messages.create(body: params[:message][:body], sender_id: params[:message][:sender_id])

    respond_to do |format|
      format.js
    end
  end

  def reload_messages
    @recipient_profile = Location.unscoped.find_by_slug(params[:recipient])
    @current_profile = current_user.profile
    @conversation = Conversation.lookup(@current_profile.id, @recipient_profile.id)
    @messages = @conversation.messages.where(has_seen: false, sender_id: @recipient_profile.id).order(:created_at)
    msgs = @messages.pluck(:id)
    @messages.update_all(has_seen: true)

    respond_to do |format|
      format.json { render json: Message.where(id: msgs) }
    end
  end

  private
    def setup_recipients_and_path
      if params[:location_id]
        location = Location.find(params[:location_id])
        @message.recipients = location.id
        @path = url_for([location, :messages])
        @from = current_user
      elsif params[:business_improvement_area_id]
        bia = BusinessImprovementArea.find(params[:business_improvement_area_id])
        @message.recipients = bia.location_ids.join(",")
        @path = url_for([bia, :messages])
        @from = bia
      else
        @path = url_for([:messages])
      end
    end

    def manager(conversation, managers)
      return false if managers.empty?
      managers.select do |manager| conversation.is_participant? manager end.first
    end
end
