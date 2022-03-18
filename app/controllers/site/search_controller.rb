class Site::SearchController < SiteController
  def questions
    #@questions = Question.includes(:answers).page(params[:page])

    @questions = Question._search_(params[:page], params[:term])
  end 
end
