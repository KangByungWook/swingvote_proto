class MainController < ApplicationController
  
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
    return @index-1
  end
  
  def index
    if !params[:current_userId_mobile].nil?
      session[:account] = params[:current_userId_mobile]
      session[:from_mobile] = true
    elsif current_user
      session[:account] = current_user.id
    end
    
    if !session[:account].nil?
      if Userdatum.all.where(user_id: session[:account]).length == 0
        a = Userdatum.new
        a.user_id = session[:account].to_s
        if current_user
          a.username=current_user.nickname
        else
          a.username = params[:nickname]
        end
        a.tags = {}
        a.posts = {}
        main_tags = Hash.new
        main_tags["IT"] = 10 
        main_tags["스포츠"] = 10
        main_tags["시사"] = 10
        main_tags["연예"] = 10
        a.main_tag = main_tags
        a.user_point = 0
        tag = Hash.new
        tag["IT"] = 10 
        tag["스포츠"] = 10
        tag["시사"] = 10
        tag["연예"] = 10
        a.tags = tag
        a.save
      end
    end
    
    
    @main = Post.all.select{|x| x.tags.include? "핫이슈"}
    @recent = Post.all
    if !session[:account].nil?
      @user = Userdatum.where(:user_id => session[:account].to_s)[0]
      
      @tags = @user.tags.sort_by do |x, y| y end
      @tags.reverse!
      @tag_arr = []
        @tags.each do |x, y|
        @tag_arr.push("#{x}")
        end
      
     @tag = []
      for i in (0...@tag_arr.length)
        @tag[i] = Post.all.select{|x| x.tags.include? @tag_arr[i]}
      end
    else
      #default
      @tag_arr = ["연예","스포츠","IT","시사"]
      @tag = []
      for i in (0...@tag_arr.length)
        @tag[i] = Post.all.select{|x| x.main_tag == @tag_arr[i]}
      end
    end
    @tag_arr = @tag_arr.paginate(:page => params[:page], :per_page => 5)
  end
  
  def testslider
  end
  
  def post_list
    @id = params[:id]
    @list = Post.all.select{|x|x.tags.include? @id}
    if !session[:account].nil?
      @approach = Userdatum.all.where(user_id: session[:account].to_s)
    end
    @list = @list.reverse.paginate(:page => params[:page], :per_page => 10)
  end
  
  def post_content
    @id = params[:id]
    #알림용 투표검증
    @voteIndex = params[:voteIndex]
    #로그인 검증
    @is_login = false
    if !session[:account].nil?
      @is_login = true
    else
      @is_login = false
    end
    
    if !session[:account].nil?
      #투표 참여 검증
      @approach = Userdatum.all.where(user_id: session[:account].to_s)
      #@approach = Userdatum.all.select{|x|x.user_id == current_user.id}
      
      @is_participated = false
      
      if !@approach.first.posts[@id].nil?
        @is_participated = true
      else
      end
      @current_user_pos = @approach.first.posts[@id]
    end
    
    
    @post = Post.select{|x|x.id == params[:id].to_i}
    #통계치 부분 처리
    @left_num = @post.first.left["value"]
    @left_content = @post.first.left["content"]
    @right_num = @post.first.right["value"]
    @right_content = @post.first.right["content"]
    @total = @left_num + @right_num
    if @total == 0
      @total = 1
    end
    
    #댓글부분 처리
    @repliesDisplay = Reply.all.select{|x|x.post_id == params[:id]}
    @repliesLeft = @repliesDisplay.select{|x| x.pro_or_cons == true}.sort_by{|x|x.get_likes.size}.reverse
    @repliesRight = @repliesDisplay.select{|x| x.pro_or_cons == false}.sort_by{|x|x.get_likes.size}.reverse
    @total_equal_replies = []
    for x in (0...@repliesDisplay.length) do
      if !@repliesLeft[x].nil?
        @total_equal_replies.push(@repliesLeft[x])
      end
      if !@repliesRight[x].nil?
        @total_equal_replies.push(@repliesRight[x])
      end
    end
    @total_equal_replies = @total_equal_replies.paginate(:page => params[:page], :per_page => 3)
  end
  
  def readability
    @post_id = /(.*)_(.*)/.match(params[:id])[1].to_i
    @link_index = /(.*)_(.*)/.match(params[:id])[2].to_i
    @read = Post.select{|x|x.id == @post_id}
  end
  
  def do_write
    
  end
  
  def do_reply
    @post_id = params[:id]
    def to_boolean(str)
      if str == "true"
        return true
      else
        return false
      end
    end
    
    # 댓글 썼을 때 포인트 30점
    a = Userdatum.all.select{|x|x.user_id == session[:account].to_s}[0]
    a.user_point += 30
    a.save
     replyModel = Reply.new
     replyModel.user_id = session[:account].to_s
     replyModel.content = params[:content]
     replyModel.post_id = params[:id]
     replyModel.pro_or_cons = to_boolean(params[:pros_and_cons])
     replyModel.save
     
     redirect_to "/main/post_content/#{@post_id}" 
  end
  
  def do_reply_like
      @reply = Reply.find(params[:id])
      @reply.liked_by Userdatum.where(user_id: session[:account])[0]
      redirect_to :back
  end
  
  def do_reply_dislike
      @reply = Reply.find(params[:id])
      @reply.disliked_by Userdatum.where(user_id: session[:account])[0]
      redirect_to :back
  end
  
  def do_vote
      @original_id = params[:id]
      # @current_userId_web = params[:current_userId_web]
      # @current_userId_mobile = params[:current_userId_mobile]
      
      @post_id = /(.*)_(.*)/.match(params[:id])[1].to_i
      select_index = /(.*)_(.*)/.match(params[:id])[2].to_i
      
      target_post = Post.all.select{|x|x.id == @post_id}[0]
      #target_post = Parse::Query.new("posts").eq("objectId", @post_id).get.first
      target_user = Userdatum.all.select{|x|x.user_id == session[:account].to_s}[0]
      #target_user = Parse::Query.new("userdata").eq("userId", session[:account]).get.first
      a= target_user.posts
      if select_index == 0
        a[@post_id.to_s] = "left"
        target_user["posts"] = a
        target_post.left["value"] += 1
      elsif select_index == 1
        a[@post_id.to_s] = "right"
        target_user["posts"] = a
        target_post.right["value"] += 1
      end
      
      #사용자의 태그정보 반영
      target_post.tags.each do |x|
        if target_user.tags.nil?
          target_user["tags"] = {"#{x}" => 1}
        else
          if target_user.tags[x].nil?
            target_user.tags[x] = 1
          else
            target_user.tags[x] +=1
          end
        end
      end
      
      main_tag = target_post.main_tag
      if target_user.main_tag[main_tag].nil?
          target_user.main_tag[main_tag] = 1
          target_user.tags[main_tag] = 1
      else
          target_user.main_tag[main_tag] += 1
          if target_user.tags[main_tag].nil?
            target_user.tags[main_tag] =1
          else
            target_user.tags[main_tag] +=1
          end
      end
      target_user.user_point += 10
      
      #사용자 정보 저장(태그, 참여기록)
      target_user.save
      #글 정보 저장(투표수)
      target_post.save
      #TODO스크립트 POST 리퀘스트 처리하기
      
      #redirect_to "/main/post_content/#{@post_id}"
      redirect_to :back
    
  end
  
  def user_page
    @userdata = Userdatum.all.where(user_id: session[:account])[0]
    @user_level = calculate_level(@userdata.user_point)
    @level_sum = 0
    for x in 1..100 do
      if x == @user_level
        break
      end
      @level_sum+=x
    end
    @point_remain = @userdata.user_point - @level_sum*200
    
    if @userdata.tags.nil?
      @tagindex = 0
    else
      @tagindex = 1
      @tags = @userdata.tags.sort_by do |x, y| y end
      @tags.reverse!
      
      @tag_arr = []
      @tags.take(18).each do |x, y|
        @tag_arr.push("#{x}")
      end
      @tag_arr.reverse!
    end
    
    if @userdata.posts.nil?
      @postindex = 0
    else
      @postindex = 1
      @posts = @userdata.posts
      @post_arr = []
      @posts.each do |x, y|
        @post_arr.push("#{x}")
      end
    end
    
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
    userdatacreate["main_tag"] = {"IT" => 1,"스포츠" => 1,"시사" => 1,"연예" => 1}
    #userdatacreate["posts"] = {"" => ""}
    userdatacreate.save
    redirect_to "/main/logintest"
  end
  
  def logintest
  end
  
  def logouttest
    session.delete(:account)
    redirect_to '/'
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
  def do_uploading
    a = Post.new
    a.main_tag = params[:main_tag]
    subTagArray = Array.new
    subTagArray.push(params[:main_tag])
    subTagArray.push(params[:sub_tag1])
    subTagArray.push(params[:sub_tag2])
    subTagArray.push(params[:sub_tag3])
    subTagArray.push(params[:sub_tag4])
    subTagArray.delete_if{|x| x == ""}
    a.tags = subTagArray
    
    a.subject = params[:subject]
    leftObject = Hash.new
    leftObject["content"] = params[:left]
    leftObject["value"] = 0
    a.left = leftObject
    
    rightObject = Hash.new
    rightObject["content"] = params[:right]
    rightObject["value"] = 0
    a.right = rightObject
    
    linkArray = Array.new
    linkArray.push(params[:link1])
    linkArray.push(params[:link2])
    linkArray.push(params[:link3])
    linkArray.push(params[:link4])
    linkArray.push(params[:link5])
    linkArray.push(params[:link6])
    linkArray.delete_if{|x| x == ""}
    linkObjectArray = []
    for x in 0...linkArray.length do
      object = {}
      object["link_url"] = linkArray[x]
      if LinkThumbnailer.generate(linkArray[x]).images.length == 0
        object["link_img_url"] = ""
      else
        object["link_img_url"] = LinkThumbnailer.generate(linkArray[x]).images.first.src.to_s
      end
      
      object["link_title"] = LinkThumbnailer.generate(linkArray[x]).title
      linkObjectArray.push(object)
    end
    a.links = linkObjectArray
    
    a.img_url = params[:img_url]
    a.save
    
    redirect_to :back
  end
  
  
end