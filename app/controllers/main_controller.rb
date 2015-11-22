class MainController < ApplicationController
  
  def index
    @objID = params[:objID]
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
    
    #통계치 부분 처리
    @left_num = @post.get.first["left"]["value"]
    @left_content = @post.get.first["left"]["content"]
    @right_num = @post.get.first["right"]["value"]
    @right_content = @post.get.first["right"]["content"]
    @total = @left_num + @right_num
    if @total == 0
      @total = 1
    end
    
    #댓글부분 처리
    repliesModel = Parse::Query.new("replies")
    @repliesDisplay = repliesModel.eq("post_id",params[:id].to_s).get
    @repliesLeft = @repliesDisplay.select{|x| x["pros_or_cons"] == true}
    @repliesRight = @repliesDisplay.select{|x| x["pros_or_cons"] == false}
  end
  
  def readability
    @post_id = /(.*)_(.*)/.match(params[:id])[1].to_s
    @link_index = /(.*)_(.*)/.match(params[:id])[2].to_i
    @read = Parse::Query.new("posts").eq("objectId",@post_id)
    #@news = ReadabilityParser.parse(@a)
    
    #개선된 버전
    
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
  
  def do_vote
      @original_id = params[:id]
      post_id = /(.*)_(.*)/.match(params[:id])[1].to_s
      select_index = /(.*)_(.*)/.match(params[:id])[2].to_i
      
      target_post = Parse::Query.new("posts").eq("objectId", post_id).get.first
      
      if select_index == 0
        target_post["left"]["value"] += 1
        target_post.save
      elsif select_index == 1
        target_post["right"]["value"] += 1
        target_post.save
      end
      
      redirect_to "/main/post_content/#{post_id}"
  end
  
  def user_page
  end
  
  def signuptest
  end
  
  def after_signup
    username = params[:username].to_s
    password = params[:password].to_s
    user = Parse::User.new({
      :username => username,
      :password => password
    })
    user.save
    redirect_to "/main/logintest"
  end
  
  def logintest
  end
  
  #def after_login
  #  username = params[:username]
  #  password = params[:password]
  #  
  #  body = {
  #    "username" => username,
  #    "password" => password
  #  }
  #
  #  @response = Parse.client.request(Parse::Protocol::USER_LOGIN_URI, :get, nil, body)
  #  Parse.client.session_token = @response[Parse::Protocol::KEY_USER_SESSION_TOKEN]
  #
  #  #new(SUPER_class = response)
  #  redirect_to '/'
  #end
  
end