class NewsArticlesController < ApplicationController
  load_resource :location
  load_and_authorize_resource :news_article, through: [:location]

  # GET /news_articles
  # GET /news_articles.json
  def index

    @location = Location.find(params[:location_id])
    @news_articles = @location.news_articles

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @news_articles }
    end
  end

  # GET /news_articles/1
  # GET /news_articles/1.json
  def show
    @location = Location.find(params[:location_id])
    @news_article = NewsArticle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @news_article }
    end
  end

  # GET /news_articles/new
  # GET /news_articles/new.json
  def new
    @location = Location.find(params[:location_id])
    @news_article = @location.news_articles.new(user_id: current_user.id)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @news_article }
    end
  end

  # GET /news_articles/1/edit
  def edit
    @news_article = NewsArticle.find(params[:id])
    @location = Location.find(params[:location_id])
  end

  # POST /news_articles
  # POST /news_articles.json
  def create

    @location = Location.find(params[:location_id])
    @news_article = @location.news_articles.new(params[:news_article])

    respond_to do |format|
      if @news_article.save
        format.html { redirect_to location_news_article_url(@location, @news_article), notice: 'News article was successfully created.' }
        format.json { render json: @news_article, status: :created, location: @news_article }
      else
        format.html { render action: "new" }
        format.json { render json: @news_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /news_articles/1
  # PUT /news_articles/1.json
  def update
    @news_article = NewsArticle.find(params[:id])
    @location = Location.find(params[:location_id])
    respond_to do |format|
      if @news_article.update_attributes(params[:news_article])
        format.html { redirect_to location_news_article_path(@location, @news_article), notice: 'News article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @news_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news_articles/1
  # DELETE /news_articles/1.json
  def destroy
    @news_article = NewsArticle.find(params[:id])
    @newsable = @news_article.newsable_type.constantize.find(@news_article.newsable_id)
    @news_article.destroy

    respond_to do |format|
      format.html { redirect_to polymorphic_url([@newsable, :news_articles]) }
      format.json { head :no_content }
    end
  end
end
