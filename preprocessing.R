############### function definition
### preprocess data by using title
titlePreprocess <- function(reg_expr, data, contain = TRUE) {
  index = grepl(reg_expr, data$title, ignore.case=TRUE)
  if(!contain)
    index = !index
  return (subset(data, index))
}

### exclude not needed data
Preprocess <- function(fname){
  # 데이터 읽어오기
  tdf = read.csv(fname, header = FALSE)
  names(tdf) = c("url", "nick", "views", "title", "sale", "price", "id", "sdate", "edate")
  
  # 제목에 아이패드를 포함하지 않는 게시글 제거
  reg_expr = "(:?아이패드|ipad/i)"
  adf = titlePreprocess(reg_expr, tdf)
  
  # 케이스, 파우치, 키보드 등 단품 제외
  # 단품이 들어간 게시글 tmp에 저장
  reg_expr = "(:?파우치|케이스|슬리브|키보드|필름|강화유리|충전기|폴리오|커버|젠더|거치대|가방|케이블|어댑터|펜슬|folio/i|case/i|keyboard/i)"
  tmp = titlePreprocess(reg_expr, adf)
  adf = titlePreprocess(reg_expr, adf, FALSE)
  # 단품이 포함된 게시글 중 세트 게시글 다시 adf에 포함
  reg_expr = "\\+|\\/|포함|증정"
  adf = rbind(adf, titlePreprocess(reg_expr, tmp))
  
  # 교환 글 제외
  reg_expr = "교환"
  adf = titlePreprocess(reg_expr, adf, FALSE)
  
  # 사기게시글 알려주는 게시글 분리
  # 사기, 사 기, ㅅ ㅏㄱ ㅣ
  reg_expr = "사\\s?기|ㅅ ㅏㄱ ㅣ"
  adf = titlePreprocess(reg_expr, adf, FALSE)
  
  # 매입글 분리
  # 구해요, 구합니다
  # 구매 합니다. 구매 해요, 구매 희망 합니다, 구매 희망 해요, 구매 원합니다, 구매 원해요
  # 구매 희망
  reg_expr = "삽니다|매입|구(:?해요|합니다)|구매\\s?(:?희망|원|)?\\s?(:?합니다|해요)|구매\\s?희망"
  adf = titlePreprocess(reg_expr, adf, FALSE)
  
  return (adf)
}

### extract pro types from data 
### and extract information from pro types
### then save
extractProAndSave <- fucntion(data){
  ## extract pro types from data
  # pro
  reg_expr = "프로|pro/i"
  pro = titlePreprocess(reg_expr, data)
  # 3세대
  # 애플펜슬 2세대는 3세대와만 호환, 프로 3세대를 그냥 프로로 기재하고 펜슬 2세대와 함께 파는 경우 존재
  reg_expr = "3세대|프로3|펜슬\\s?2"
  pro3 = titlePreprocess(reg_expr, pro)
  pro = titlePreprocess(reg_expr, pro, FALSE)
  # 2세대
  # 3세대에서 펜슬 2세대 결과를 분리했으므로 2세대로 검색해도 됨
  # 프로 256기가 제외하기 위해 프로2다음에 띄어쓰기 포함해서 검색
  reg_expr = "2세대|프로2\\s"
  pro2 = titlePreprocess(reg_expr, pro)
  pro = titlePreprocess(reg_expr, pro, FALSE)
  
  ## extract information from pro types
  # display
  reg_expr = "11|12.9"
  tmp = gregexpr(reg_expr, ex)
  # 12.9형과 11형을 모두 팔 경우 에러로 표시(-1)
  if(length(tmp[[1]]) > 1){
    display = -1
  } else if(tmp[[1]] == -1){
    display = NA
  } else display = substr(ex, tmp[[1]], tmp[[1]]+attr(tmp[[1]], "match.length")-1)

  # connect
  # lte, LTE, 셀룰러, 셀룰, 셀롤러
  # wifi, wi-fi, Wi-Fi, WiFi, WIFI, 와이파이, 와파
  reg_expr = "(:?셀룰?롤?러?|lte|와이?파이?|wi-?fi)"
  #|wi/i-?fi/i|와이?파이?)"
  tmp = gregexpr(reg_expr, ex, ignore.case=TRUE)
  if(length(tmp[[1]]) > 1){
    connect = "Error"
  } else if(tmp[[1]] == -1){
    connect = NA
  } else connect = substr(ex, tmp[[1]], tmp[[1]]+attr(tmp[[1]], "match.length")-1)

  # storage
  # pro3의 경우 64, 256, 512, 1024 기가
  reg_expr = "64|256|512|1\\s?테라|1tb?"
  tmp = gregexpr(reg_expr, ex, ignore.case=TRUE)
  if(length(tmp[[1]]) > 1){
    storage = -1
  } else if(tmp[[1]] == -1){
    storage = NA
  } else storage = substr(ex, tmp[[1]], tmp[[1]]+attr(tmp[[1]], "match.length")-1)

  if(grepl("1", storage)) storage = 1024


  # color
  # pro3의 경우 실버와 스그
  color = ""
  reg_expr = "실버|silver|화이트|white"
  if(grepl(reg_expr, ex)) color = paste(color, "실버", sep="|")

  reg_expr = "스페?이?스?그레?이?|space|gray|sg"
  if(grepl(reg_expr, ex)) color = paste(color, "스페이스 그레이", sep="|")

  if(color == "") color = NA

  # state
  # 미개봉
  # 새상품
  # 리퍼신품
  # s급
  # aa급
  # 고장, 이상, 찍힘, 눌림
  # ~ 사용 ~
  # 못 할 것 같은데 말이지...

  # 펜슬
  reg_expr = "펜슬|pencil"
  tmp = regexpr(reg_expr, ex, ignore.case=TRUE)
  if(tmp[1] == -1){
    pencil = 0
  } else pencil = 1

  # 키보드
  # folio 키보드, 정품 키보드, 정품 스마트 키보드, 스마트 폴리오 키보드, 애플 스마트 키보드
  # 로지텍(logitech) ... 키보드
  # 벨킨(belkin) ... 키보드
  # 기타 키보드: 무선 키보드, 블루투스 키보드
  # 키보드 케이스는 포함되면 안됨
  reg_expr = "폴리오|folio|스마트\\s?키보드|로지텍\\s?키보드|logitech\\s?키보드|벨킨\\s?키보드|belkin\\s?키보드|무선\\s?키보드|블루투스\\s?키보드"
  tmp = regexpr(reg_expr, ex, ignore.case=TRUE)
  if(tmp[1] == -1){
    keyboard = 0
  } else keyboard = 1

}

t = Preprocess("D:/scrap/scrapInfo20190528.csv")
