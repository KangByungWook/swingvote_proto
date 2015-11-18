class MainController < ApplicationController
  
  def index
      #핫이슈 메인 슬라이더
      @main_sub = ["아이유 '제제' 논란","..."]
      @main_pic = ["http://thumb.mt.co.kr/06/2015/11/2015110809195059394_1.jpg?time=054222",
                   "..."]
      @main_tag = [["아이유","제제","연예"],["빈태그","..."]]
      
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
      @girl_tag_name = "연예"
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
    @id = params[:id]

    @list_pic=["http://thumb.mt.co.kr/06/2015/11/2015110809195059394_1.jpg?time=054222",
              "http://i.ytimg.com/vi/4jsJlyXT95w/maxresdefault.jpg",
              "http://www.billboard.co.kr/wp-content/uploads/2015/07/37.png"]
    @list_subject=["아이유 '제제' 논란", "수지 vs 효성","AOA vs EXID"]
    @list_choice=[["찬성","반대"], 
                  ["현행 유지","낮추어야 한다"], 
                  ["설치해야한다","필요없다"]
                ]
    
  end
  
  def post_content
    @id = params[:id]
    
    @link_arr = ["http://stoo.asiae.co.kr/news/view.htm?idxno=2015111314533739620",
                 "http://economy.hankooki.com/lpage/entv/201511/e20151110200531143500.htm",
                 "http://news.chosun.com/site/data/html_dir/2015/11/10/2015111002112.html",
                 "http://news20.busan.com/controller/newsController.jsp?newsId=20151108000078"]
                 
    #링크 배열에 있는 각각의 이미지를 같은 크기의 배열로 만듬
    
    
    
    @news_arr = []
    @title_arr = []
    @link_img = []
    
    for x in (0...@link_arr.length)
      @news_arr[x] = ReadabilityParser.parse(@link_arr[x])
      @title_arr[x] = @news_arr[x].title
      @link_img[x] = ReadabilityParser.parse(@link_arr[x]).content.to_s.match(/<img.*>/)
    end
    
    @color_arr = ["#c2bfd9","#d0ecf2","#bad9bc","#edf2c9","#f2e2ce"]
  end
  
  def readability
    @id = params[:id].to_i
    @link_arr = ["http://stoo.asiae.co.kr/news/view.htm?idxno=2015111314533739620",
                 "http://economy.hankooki.com/lpage/entv/201511/e20151110200531143500.htm",
                 "http://news.chosun.com/site/data/html_dir/2015/11/10/2015111002112.html",
                 "http://news20.busan.com/controller/newsController.jsp?newsId=20151108000078"]
                 
    @news = ReadabilityParser.parse(@link_arr[@id])
    @title = @news.title
    @content = @news.content.to_s.match(/<p>(.|\n){100,}p>/)

  end
  
  def do_write
    
  end
  
  def user_page
  end
  
end