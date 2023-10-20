class TradeAssociationsController < ApplicationController
  load_and_authorize_resource
  
  # GET /trade_associations
  # GET /trade_associations.json
  def index
    @trade_associations = TradeAssociation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trade_associations }
    end
  end

  # GET /trade_associations/1
  # GET /trade_associations/1.json
  def show
    @trade_association = TradeAssociation.find(params[:id])
    @status_updates = @trade_association.status_updates + @trade_association.location_status_updates
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trade_association }
    end
  end

  # GET /trade_associations/new
  # GET /trade_associations/new.json
  def new
    @trade_association = TradeAssociation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trade_association }
    end
  end

  # GET /trade_associations/1/edit
  def edit
    @trade_association = TradeAssociation.find(params[:id])
  end

  # POST /trade_associations
  # POST /trade_associations.json
  def create
    @trade_association = TradeAssociation.new(trade_association_params)

    respond_to do |format|
      if @trade_association.save
        format.html { redirect_to @trade_association, notice: 'Trade association was successfully created.' }
        format.json { render json: @trade_association, status: :created, location: @trade_association }
      else
        format.html { render action: "new" }
        format.json { render json: @trade_association.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trade_associations/1
  # PUT /trade_associations/1.json
  def update
    @trade_association = TradeAssociation.find(params[:id])

    respond_to do |format|
      if @trade_association.update_attributes(trade_association_params)
        format.html { redirect_to @trade_association, notice: 'Trade association was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @trade_association.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trade_associations/1
  # DELETE /trade_associations/1.json
  def destroy
    @trade_association = TradeAssociation.find(params[:id])
    @trade_association.destroy

    respond_to do |format|
      format.html { redirect_to trade_associations_url }
      format.json { head :no_content }
    end
  end

  private

  def trade_association_params
    params.require(:trade_association).permit(:description, :name, :slug, :website_url, :city, :province, :home_page_image, :logo, :city, :province,
      :city_id, :province_id, :status_updates_attributes)
  end
end
