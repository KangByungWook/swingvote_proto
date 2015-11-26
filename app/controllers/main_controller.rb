class MainController < ApplicationController
  
  def index
    @app_session = params[:current_userId_mobile]
    @web_session = params[:current_userId_web]
    @main = Parse::Query.new("posts").value_in("tags", ["핫이슈"])
    @recent = Parse::Query.new("posts")
    if !@app_session.nil?
      #app_session
      @user = Parse::Query.new("userdata").eq("userId", @app_session).get.first
      @tags = @user["tags"].sort_by do |x, y| y end
      @tags.reverse!
      @tag_arr = []
      @tags.each do |x, y|
        @tag_arr.push("#{x}")
      end
      @tag = []
      for i in (0...@tag_arr.length)
        @tag[i] = Parse::Query.new("posts").eq("main_tag", @tag_arr[i]).or(Parse::Query.new("posts").value_in("tags", [@tag_arr[i]]))
      end
    elsif !@web_session.nil?
      #web_session
      @user = Parse::Query.new("userdata").eq("userId", @web_session).get.first
      @tags = @user["tags"].sort_by do |x, y| y end
      @tags.reverse!
      @tag_arr = []
      @tags.each do |x, y|
        @tag_arr.push("#{x}")
      end
      @tag = []
      for i in (0...@tag_arr.length)
        @tag[i] = Parse::Query.new("posts").eq("main_tag", @tag_arr[i]).or(Parse::Query.new("posts").value_in("tags", [@tag_arr[i]]))
      end
    else
      #default
      @tag_arr = ["연예","스포츠","IT","시사"]
      @tag = []
      for i in (0...@tag_arr.length)
        @tag[i] = Parse::Query.new("posts").eq("main_tag", @tag_arr[i])
      end
    end
  end
  
  def testslider
  end
  
  def post_list
    @id = params[:id]
    @app_session = params[:current_userId_mobile]
    @web_session = params[:current_userId_web]
    if !@app_session.nil?
      @user = Parse::Query.new("_User").eq("objectId", @app_session).get.first
    elsif !@app_session.nil?
      @user = Parse::Query.new("_User").eq("objectId", @web_session).get.first
    else
    end
    
    @list = Parse::Query.new("posts").eq("main_tag", @id).or(Parse::Query.new("posts").value_in("tags", [@id]))
  end
  
  def post_content
    @id = params[:id]
    @current_userId_web = params[:current_userId_web]
    @current_userId_mobile = params[:current_userId_mobile]
    
    #로그인 검증
    @is_login = false
    if @current_userId_web.nil? and @current_userId_mobile.nil?
      @is_login = false
    else
      @is_login = true
    end
    
    #투표 참여 검증
    @web_approach = Parse::Query.new("userdata").eq("userId",@current_userId_web).get.first
    @mobile_approach = Parse::Query.new("userdata").eq("userId",@current_userId_mobile).get.first
    
    @is_participated = false
    
    if @web_approach.nil?
    else
      @real_userId = params[:current_userId_web]
      if @web_approach["posts"].nil?
      else
        if !@web_approach["posts"][@id].nil?
          @current_username = @web_approach["username"]
          @current_user_pos = @web_approach["posts"][@id]
          @is_participated = true
        else
        end
      end
    end
   
    if @mobile_approach.nil?
    else
      @real_userId = params[:current_userId_mobile]
      if @mobile_approach["posts"].nil?
      else
        if !@mobile_approach["posts"][@id].nil?
          @current_username = @mobile_approach["username"]
          @current_user_pos = @mobile_approach["posts"][@id]
          @is_participated = true
        else
        end
      end
    end
    
    @real_approach = Parse::Query.new("userdata").eq("userId",@real_userId).get.first
    
    
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
    @post_id = params[:id]
    @current_userId_mobile = params[:current_userId_mobile]
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
     
  end
  
  def do_vote
      @original_id = params[:id]
      @current_userId_web = params[:current_userId_web]
      @current_userId_mobile = params[:current_userId_mobile]
      
      @post_id = /(.*)_(.*)/.match(params[:id])[1].to_s
      select_index = /(.*)_(.*)/.match(params[:id])[2].to_i
      
      target_post = Parse::Query.new("posts").eq("objectId", @post_id).get.first
      
      if select_index == 0
        target_post["left"]["value"] += 1
        if !@current_userId_web.nil?
          #투표 반영
          target_user = Parse::Query.new("userdata").eq("userId", @current_userId_web).get.first
          if target_user["posts"].nil?
            a= Hash.new
          else
            a= target_user["posts"]
          end
          a[@post_id] = "left"
          target_user["posts"] = a
          
          #사용자의 태그정보 반영
          target_post["tags"].each do |x|
            if target_user["tags"][x].nil?
              target_user["tags"][x] = 1
            else
              target_user["tags"][x] +=1
            end
          end
          
        else
          if !@@current_userId_mobile.nil?
            target_user = Parse::Query.new("userdata").eq("userId", @current_userId_mobile).get.first
            if target_user["posts"].nil?
              a= Hash.new
            else
              a= target_user["posts"]
            end
            a[@post_id] = "left"
            target_user["posts"] = a
            target_user.save
          end
        end
        #사용자 정보 저장(태그, 참여기록)
        target_user.save
        #글 정보 저장(투표수)
        target_post.save
      elsif select_index == 1
        target_post["right"]["value"] += 1
        if !@current_userId_web.nil?
          #투표 반영
          target_user = Parse::Query.new("userdata").eq("userId", @current_userId_web).get.first
          if target_user["posts"].nil?
            a= Hash.new
          else
            a= target_user["posts"]
          end
          a[@post_id] = "right"
          target_user["posts"] = a
          
          #사용자의 태그정보 반영
          target_post["tags"].each do |x|
            if target_user["tags"][x].nil?
              target_user["tags"][x] = 1
            else
              target_user["tags"][x] +=1
            end
          end
          
        else
          if !@current_userId_mobile.nil?
            target_user = Parse::Query.new("userdata").eq("userId", @current_userId_mobile).get.first
            if target_user["posts"].nil?
              a= Hash.new
            else
              a= target_user["posts"]
            end
            a[@post_id] = "right"
            target_user["posts"] = a
            target_user.save
          end
        end
        #사용자 정보 저장(태그, 참여기록)
        target_user.save
        #글 정보 저장(투표수)
        target_post.save
      end
      
      #TODO스크립트 POST 리퀘스트 처리하기
      #redirect_to "/main/post_content/#{post_id}"
      
  end
  
  def user_page
    @app_session = params[:current_userId_mobile]
    @web_session = params[:current_userId_web]
    if !@app_session.nil?
      #app_session
      @user = Parse::Query.new("_User").eq("objectId", @app_session).get.first
      @userdata = Parse::Query.new("userdata").eq("userId", @app_session).get.first
    elsif !@web_session.nil?
      #web_session
      @user = Parse::Query.new("_User").eq("objectId", @web_session).get.first
      @userdata = Parse::Query.new("userdata").eq("userId", @web_session).get.first
    end
    @tags = @userdata["tags"].sort_by do |x, y| y end
    @tag_arr = []
    @tags.each do |x, y|
      @tag_arr.push("#{x}")
    end
    @posts = @userdata["posts"]
    
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
    userdata = Parse::Query.new("_User").eq("username", username).get.first
    userdatacreate = Parse::Object.new("userdata")
    userdatacreate["username"] = userdata["username"]
    userdatacreate["userId"] = userdata.id
    userdatacreate["tags"] = {"IT" => 1,"스포츠" => 2,"시사" => 3,"연예" => 4}
    userdatacreate["posts"] = {"" => ""}
    userdatacreate.save
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