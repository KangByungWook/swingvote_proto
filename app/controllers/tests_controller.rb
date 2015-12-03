class TestsController < ApplicationController
  def scroll
    @posts = Post.paginate(:page => params[:page], :per_page => 5)
  end
  
  def calculate_level(point)
    @index = 1
    copy_point = point
    for x in 1...100 do
       copy_point -= @index*200
       @index += 1
       if copy_point < @index*200
         break
       end
    end
    return @index
  end
  
end
