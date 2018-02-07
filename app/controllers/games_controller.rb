class GamesController < ApplicationController

  def index

  end

  # page where the user can see his score and the scores of other users.
  # also shows which category the user has answered the best in.
  def show_ratings
    @users = User.all
    @cur_user = current_user

    @responses = Response.all
    @scores=Hash.new(0) #https://stackoverflow.com/questions/2990812/initializing-hashes
    @total_correct = 0
    @total_incorrect = 0
    @upvotes=0          #For each question current_user has created, how many people upvoted it
    @downvotes=0
    @best_category='Nothing best yet!'
    cat=Hash.new(0)     #category and its score: for current user only

    return if @responses.empty?

    # Traverse all responses. each response belongs to a unique question. and that question has unique owner(q.user_id)
    @responses.each{|r|
      @scores[r.user_id]+= (r.eval==true ? 4:-1)
      q=r.question
      tags=q.tags

      # Score upvote/downvotes for question_creator. For current user also count total upvotes and downvotes.
      if(!r.vote.nil?)
        @scores[q.user_id] +=r.vote
        if(q.user_id==current_user.id)
          if r.vote>0 then @upvotes+=1 else @downvotes+=1 end
        end
      end

      #other stats for current user
      if(r.user == current_user)
        # show best category
        if !tags.nil?
          tags.each{|t|
            cat[t.value]+=(r.eval==true ? 4:-1)
          }
        end

        # total correct, total incorrect
        if(r.eval==true) then @total_correct+=1 else @total_incorrect+=1 end

      end

    }

    #Sort map by value. Get the first key
    ar = cat.sort_by {|k,v| v}.reverse
    @best_category = ar.first[0]  unless ar.empty?  #[["bonds", 8], ["relationships", 8], ["personal", 8], ["general", 4], ["bio", 3], ["medical", -1]]
  end

end
