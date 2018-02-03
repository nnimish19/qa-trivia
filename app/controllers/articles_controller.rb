class ArticlesController < ApplicationController

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  # The reason why we added @article = Article.new in the ArticlesController is that otherwise
  # @article would be nil in our view, and calling @article.errors.any? would throw an error.
  def new
    @article = Article.new
  end

  def create
    # render plain: params[:article].inspect
    # @article = Article.new(params[:article])  #error: cannot save all parameters at once: strong_parameters
    @article = Article.new(article_params)

    # @article.save
    # redirect_to @article    #CALL to show action?
    if @article.save
      redirect_to @article
    else
      render 'new'
    end
  end

  private
  def article_params
    params.require(:article).permit(:title, :text)
  end
end
