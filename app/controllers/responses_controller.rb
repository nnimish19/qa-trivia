class ResponsesController < ApplicationController

  # FETCH unanswered questions by this user. if none: say no questions yet
  # Give an exist session option to the user in view: that is link to /games/index
  def new
    @question = Question.left_outer_joins(:responses).where("questions.user_id!=? AND (responses.user_id!=? or responses.user_id is NULL)",current_user.id,current_user.id).first
    @response = Response.new
    @response.question_id = @question.id unless @question.nil?
    @response.user_id = current_user.id
  end

  def create
    Rails.logger.info("\n--------------Create Response----------------\n")

    @response = Response.new(response_params)
    @question = Question.find(params[:response][:question_id])

    @response.statement = @response.statement.downcase.strip

    if(@response.statement == @question.answer)
      @response.eval = true
    else
      @response.eval = false
    end

    @response.save

    render 'new'

  end


  private
  def response_params
    params.require(:response).permit(:question_id, :user_id, :statement)
  end
end
