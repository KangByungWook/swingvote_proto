class TestsController < ApplicationController
  def scroll
    @posts = Post.paginate(:page => params[:page], :per_page => 5)
  end
end
