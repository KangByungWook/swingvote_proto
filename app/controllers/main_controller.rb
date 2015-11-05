class MainController < ApplicationController
  
  def index
      #핫이슈 메인 슬라이더
      @main_sub = ["국정교과서 과연 옳은 선택인가","하핫"]
      @main_pic = ["http://imgnews.naver.net/image/001/2015/11/02/PYH2015110210430001300_P2_99_20151102215904.jpg?type=w540",
                   "..."]
      @main_tag = [["정치","국정교과서","한국사"],["빈태그","qwertyuiopasdfghjklzxcvbm"]]
      
      uri = URI("http://www.naver.com/")
      html_doc = Nokogiri::HTML(Net::HTTP.get(uri))
      @rank_arr = html_doc.css("#realrank li//a").inner_html.gsub(/<span.+?<\/span>/,'/').split("///")
      
      # 시사태그
      @sisa_tag_name = "시사이슈"
      @sisa_sub = ["[북한 서부전선 포격]","[한일 관계, 어떻게 생각하시나요]",
                  "[한명숙 대법원 판결]","[중국 톈진 폭발사고]",
                  "[광복절 특별사면]"]
      @sisa_pic = ["http://imgnews.naver.net/image/022/2015/08/21/20150821000937_0_99_20150824215604.jpg?type=w540",
                    "http://imgnews.naver.net/image/003/2015/08/14/NISI20150814_0005780556_web_99_20150814205704.jpg?type=w540",
                    "http://imgnews.naver.net/image/001/2015/08/20/PYH2015082011960001300_P2_99_20150820224405.jpg?type=w540",
                    "http://imgnews.naver.net/image/001/2015/08/20/AKR20150820062051083_01_i_99_20150820175312.jpg?type=w540",
                    "http://imgnews.naver.net/image/001/2015/08/13/PYH2015081303620001300_P2_99_20150813164512.jpg?type=w540"]
      @sisa_tag = [["시사이슈","북한"],
                   ["시사이슈","일본","아베 담화"],
                   ["시사이슈","정치"],
                   ["시사이슈","중국","사고"],
                   ["시사이슈","광복절"]
                  ]
                    
      #연예
      @girl_tag_name = "걸그룹"
      @girl_sub = ["최고의 걸그룹은??", "최고의 솔로가수는??", "수지 vs 효성", "AOA vs EXID", "솔지 vs 하니"]
      @girl_pic = ["http://pds.joins.com/news/component/osen_new/201305/12/201305121759770343_518f5a9c96dbe.jpg",
                    "https://i.ytimg.com/vi/1SiLiFrZJ74/maxresdefault.jpg", "http://i.ytimg.com/vi/4jsJlyXT95w/maxresdefault.jpg",
                    "http://www.billboard.co.kr/wp-content/uploads/2015/07/37.png","http://fimg2.pann.com/new/download.jsp?FileID=30261949"]
      @girl_tag = [["걸그룹","가수"],
                   ["걸그룹","가수"],
                   ["걸그룹","수지","전효성"],
                   ["걸그룹","AOA","EXID"],
                   ["걸그룹","솔지","하니"]
                  ]
      
  end
  
  def testslider
  end
  
  def post_list
    @list_pic=["http://www.hapdongnews.co.kr/news/photo/201509/3748_879_4544.jpg",
              "http://edudonga.com/data/article/1510/9857d1cb99afc00a6fb1e39c82fdb85b_1445818831_5626.JPG",
              "http://edudonga.com/data/article/1510/83d0219c3ac7c2d4518efc57ff9ded3a_1445558741_5332.jpg"]
    @list_subject=["국정화 교과서 논란", "형사처벌 대상연령을 낮추어야 할 것인가?","길거리 쓰레기통을 설치해야하는가"]
    @list_choice=[["찬성","반대"], 
                  ["현행 유지","낮추어야 한다"], 
                  ["설치해야한다","필요없다"]
                ]
    
  end
  
  def post_content
    a = params[:id]
    if a == 'accept'
      @index = 0
    elsif a == 'reject'
      @index = 1
    end

  end
  
  def readability
    @news = ReadabilityParser.parse("http://news.naver.com/main/read.nhn?oid=001&sid1=102&aid=0007963027&mid=shm&mode=LSD&nh=20151103181334")
    @title = @news.title
    @content = @news.content.to_s.match(/<p>(.|\n){100,}p>/)
  end
  
end
