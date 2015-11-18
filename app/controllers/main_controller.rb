class MainController < ApplicationController
  
  def index
    @main = Parse::Query.new("posts").value_in("tags", ["핫이슈"])
    @recent = Parse::Query.new("posts")
    @tag_arr = ["연예","스포츠","게임","시사"]
    @tag = []
    for i in (0...@tag_arr.length)
      @tag[i] = Parse::Query.new("posts").eq("main_tag", @tag_arr[i])
    end
  end
  
  def testslider
  end
  
  def post_list
    @id = params[:id]
    @list = Parse::Query.new("posts").eq("main_tag", @id).or(Parse::Query.new("posts").value_in("tags", [@id]))
  end
  
  def post_content
    @id = params[:id]
    @post = Parse::Query.new("posts").eq("objectId", params[:id].to_s)
    
    @color_arr = ["#c2bfd9","#d0ecf2","#bad9bc","#edf2c9","#f2e2ce"]
    
    #댓글부분 처리
    repliesModel = Parse::Query.new("replies")
    @repliesDisplay = repliesModel.eq("post_id",params[:id].to_s).get
    @repliesLeft = @repliesDisplay.select{|x| x["pros_or_cons"] == true}
    @repliesRight = @repliesDisplay.select{|x| x["pros_or_cons"] == false}
  end
  
  def readability
    @id = params[:id].match(/.*(?=_)/)
    @index = params[:id].last.to_i
    @read = Parse::Query.new("posts").eq("objectId",@id)
    #@news = ReadabilityParser.parse(@a)
  end
  
  def do_write
    
  end
  
  def do_reply
    def to_boolean(str)
      if str == "true"
        return true
      else
        return false
      end
    end
     replyModel = Parse::Object.new("replies")
     user_id = params[:user_id]
     content = params[:content]
     post_id = params[:post_id]
     pros_and_cons = params[:pros_and_cons]
     
     replyModel["user_id"] = user_id
     replyModel["content"] = content
     replyModel["post_id"] = post_id
     replyModel["pros_or_cons"] = to_boolean(pros_and_cons)
     replyModel.save
     redirect_to :back
  end
  
  def user_page
  end
  
end