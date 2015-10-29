class MainController < ApplicationController
  
  def index
  end
  
  def testslider
  end
  
  def post_list
  end
  
  def post_content
    a = params[:id]
    if a == 'accept'
      @index = 0
    elsif a == 'reject'
      @index = 1
    end
  end
  
end
