class ArticlesController < ApplicationController

  #  <%= link_to 'New article', new_article_path %> Rails erb evaluated "new_article_path" to "articles/new". And browser sends default "GET" request to server.

  # If you want to link to an action in the same controller, you don't need to specify the :controller option, as Rails will use the current controller by default.
  # >>Check that Link_to results in default GET request. (bcx it does not specify any HTTP action method)
  #     >Ex1: So article_path(article) is converted/processed by erb into "articles/article_id" and browser makes a default GET request to this address.
  #     HTML: <a href="/articles/5">Show</a>
  #     >Ex2: "articles_path" is converted to "/articles". and default request is "GET". Now when rails sees this, routes matches it to "articles#index" controller
  # >>Whereas we explicitly mention request_method = "delete" in case of destroy, whose request url is also "/articles/article_id"
  #     HTML: <a data-confirm="Are you sure?" rel="nofollow" data-method="delete" href="/articles/5">Destroy</a>
  #     This is handled by "rails-ujs.js": http://localhost:3000/assets/rails-ujs.self-817d9a8cb641f7125060cb18fefada3f35339170767c4e003105f92d4c204e39.js?body=1
  #     https://stackoverflow.com/questions/32887100/a-tag-with-data-method-and-data-confirm-attributes-how-does-it-work
  # Unobtrusive JavaScripts: "https://simonecarletti.com/blog/2010/06/unobtrusive-javascript-technique/"
  def index
    @articles = Article.all
  end

  # We use Article.find to find the article we're interested in, passing in params[:id] to get the :id parameter from the request.
  # We also use an instance variable (prefixed with @) to hold a reference to the article object.
  # We do this because Rails will pass all "instance variables" to the view
  def show
    @article = Article.find(params[:id])
  end

  # 1. The reason why we added @article = Article.new in the ArticlesController is that otherwise
  # @article would be nil in our view, and calling @article.errors.any? would throw an error.

  # 2. this action/route should only be used to display the form for a new article.
  # By default the FORM-BUILDER sends submit request to the corresponding action(in this 'new'). But we want submit request at new.html.erb to goto
  # create action. This can be done by :url option of form_with. Like "url: articles_path".
  # >>the articles_path helper is passed to the :url option.
  # >>"articles_path" helper tells Rails to point the form to the URI Pattern associated with the articles prefix;
  # >>and the "FORM will (by default) send a POST request" to that route("/articles").
  # >>This is associated with the create action of the current controller, the ArticlesController.
  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
  end

  # Notice that inside the create action we use "render" instead of "redirect_to" when save returns false.
  # The render method is used so that the @article object is passed back to the “new” template when it is rendered.
  # This rendering is done within the same request as the form submission, whereas the redirect_to will tell the browser to issue another request.
  def create
    # render plain: params[:article].inspect
    # @article = Article.new(params[:article])  #error: cannot save all parameters at once: strong_parameters
    @article = Article.new(article_params)

    # Adding custom errors?
    # if(@article.title.empty? ||@question.text.empty?)
    #   @question.add(?)
    #   render 'new'
    #   return
    # end

    if @article.save
      redirect_to @article    #redirect the user to the show action; this is not internal. we told the browser to send new request at specified "redirected path"

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

    redirect_to articles_path   #Check browser after invoking delete. it makes another call "Request URL:http://localhost:3000/articles ; Request Method:GET"

  end

  def answer
    Rails.logger.info("--------------Nimish ---------------")
    Rails.logger.info(params)
  end

  def view

  end

  private
  # We have to whitelist our controller parameters to prevent wrongful mass assignment.
  # In this case, we want to both allow and require the title and text parameters for valid use of create.
  # The syntax for this introduces require and permit.

  # https://stackoverflow.com/questions/18424671/what-is-params-requireperson-permitname-age-doing-in-rails-4
  # The params in a controller looks like a Hash, but it's actually an instance of ActionController::Parameters,
  # which provides several methods such as require and permit.

  # The "require" method ensures that a specific parameter is present, and if it's not provided, the require method throws an error.
  #   >>It returns an instance of ActionController::Parameters for the key passed into require.

  # The permit method returns a copy of the parameters object, returning only the permitted keys and values.
  # >>When creating a new ActiveRecord model, only the permitted attributes are passed into the model.
  # >>IMPORTANT: permit returns another hash that contains only the permitted key AND (this is critical) will respond with true
  # to the "permitted?" method. By default, an instance of the ActionController::Parameters class will return false for "permitted?"
  # Responding true to permitted? means the parameter object can be used in mass assignment; else the app will throw a ForbiddenAttributes error.
  def article_params
    params.require(:article).permit(:title, :text)
  end
end
