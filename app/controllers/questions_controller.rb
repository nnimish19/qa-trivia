class QuestionsController < ApplicationController

  def new
    @question = Question.new
    @question.user_id = current_user.id
    @tags = Tag.all   # to suggest tags at the bottom
  end

  def create
    Rails.logger.info("\n-----------Create Question--------------\n")
    # Rails.logger.info(params)
    @question = Question.new(question_params)

    if !@question.save
      render 'new'
      return
    end

    # if tags: split, trim, save in "redis-cache";if doesn't exist save it.
    tag_values = params[:question][:qtags]
    tag_values = tag_values.downcase
    tag_values = tag_values.split(',')
    tag_values = tag_values.map{|x| x.strip}
    tag_values = tag_values.reject { |x| x.empty? }

    if !tag_values.empty?                          #tag_values[/[a-z]+/]  != tag_values
      # for each tag call first or create
      tag_values.each{ |tag|
        tobj = Tag.where(:value => tag).first_or_create
        QuestionTag.where(:question_id=>@question.id, :tag_id=>tobj.id).first_or_create
      }
    end

    @question.reload
    # Rails.logger.info(@question.tags.inspect)

    redirect_to games_path  # redirect_to :controller=>'games', :action=>'index'    # https://stackoverflow.com/questions/11964312/rails-redirect-to-custom-view

  end


  private
  def question_params
    params.require(:question).permit(:user_id, :statement, :answer)
  end
end
