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

  def edit
    @article = Article.find(params[:id])
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

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to articles_path
  end


  private
  def article_params
    params.require(:article).permit(:title, :text)
  end
end
