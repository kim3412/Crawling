############### function definition

##### data cleaning

### preprocess title of given dataframe
titlePreprocess <- function(reg_expr, mdata, contain = TRUE) {
  index = grepl(reg_expr, mdata$title, ignore.case=TRUE)
  if(!contain)
    index = !index
  return (subset(mdata, index))
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

#----------------------------------------------------------------#

##### extract infomation from title

### extract only one attribute
# It is considered an error if there are multiple attributes
# use this function to extract display, connect, storage
# cause price information is meaningless when different types exist
extractOne <- function(reg_expr, ex, err_msg){
  result = c()
  for(i in 1:nrow(ex))
  {
    tmp = gregexpr(reg_expr, ex[i, 4], ignore.case=TRUE)
    if(length(tmp[[1]]) > 1){
      result[i] = err_msg
    } else if(tmp[[1]] == -1){
      result[i] = NA
    } else result[i] = substr(ex[i, 4], tmp[[1]], tmp[[1]]+attr(tmp[[1]], "match.length")-1)
  }
  return (result)
}

### extract connect attribute
# change the various expressions of sellers
# to be uniform
extractConnect <- function(reg_expr, ex, err_msg){
  connect = extractOne(reg_expr, ex, err_msg)
  connect = gsub("셀룰?롤?러?|lte", "cellular", connect)
  connect = gsub("와이?파이?|wi-?fi", "wifi", connect)
  return (connect)
}


### extract all attributes
# use this function to extract color, service
extractAll <- function(reg_expr, attrC, ex){
  result = c()
  for(i in 1:nrow(ex)){
    acc = ""
    for(j in 1:length(reg_expr)){
      if(grepl(reg_expr[j], ex[i, 4])) acc = paste0(acc, attrC[j], sep = "|")
    }
    if(acc == "") acc = NA
    result[i] = acc
  }
  return (result)
}

### extract state
# more states need to be handled
# eg. s급, ~사용, 이상, 고장, 부품용 등
extractState <- function(ex){
  state= c()
  stateC = c("풀박스", "리퍼제품", "미개봉", "새상품")
  stateR = c("풀박", "리퍼\\s?후?\\s?(미개봉|새\\s?상품|새\\s?제품|미사용|신품)", "미개봉", "새\\s?상품|새\\s?제품|새\\S?거임|새\\s?것임")
  for(i in 1:nrow(ex)){
    acc = ""  
    for(at in 1:length(stateC)){
      tmp = regexpr(stateR[at], ex[i, 4])
      if(tmp[1] != -1){
        acc = stateC[at]
        break
      }
    }
    if(acc == "") acc = NA
    state[i] = acc
  }
  return (state)
}

### extract whether a characteristic exists
# use this function to extract pencil
extractExist <- function(reg_expr, ex){
  result = c()
  for(i in 1:nrow(ex)){
    tmp = regexpr(reg_expr, ex[i, 4], ignore.case=TRUE)
    if(tmp[1] == -1){
      result[i] = 0
    } else result[i] = 1
  }
  return (result)
}

### extract whether a keyboard is included
# include keyboard
# exclude keyboard case
extractKeyboard <- function(ex){
  keyboard = c()
  for(i in 1:nrow(ex)){
    reg_expr = "키보드"
    tmp = regexpr(reg_expr, ex[i, 4], ignore.case=TRUE)
    if(tmp[1] == -1){
      keyboard[i] = 0
    } else{
      reg_expr = "키보드\\s?케이스"
      tmp = regexpr(reg_expr, ex[i, 4], ignore.case=TRUE)
      if(tmp[1] == -1){
        keyboard[i] = 1
      } else keyboard[i] = 0
    } 
  }
  return (keyboard)
}

### generate regular expressions
### for the color of the device
colorReg <- function(opts){
  color = ""
  if(grepl("실버", opts))
    color = paste0(color, "실버|silver|화이트|white", '@')
  if(grepl("스페이스 그레이", opts))
    color = paste0(color, "스페?이?스?그레?이?|space|gray|sg", '@')
  if(grepl("로즈골드", opts))
    color = paste0(color, "로즈\\s?골드|로즈\\s?핑크|rose\\s?gold|pink", '@')
  if(grepl("골드", opts))
    color = paste0(color, "골드|gold", '@')
  color = substr(color, 1, nchar(color)-1)
  return (color)
}


### make reg_expr list
# give the options by type as a parameter
# return a vector of regular expressions
options <- function(opts){
  reg_expr = c()
  # display size
  reg_expr[1] = opts[1]
  # connection method
  reg_expr[2] = "셀룰?롤?러?|lte|와이?파이?|wi-?fi"
  # storage size
  reg_expr[3] = opts[2]
  # color
  reg_expr[4] = colorReg(opts[3])
  # service
  reg_expr[5] = "리퍼.*남음?은?|리퍼\\s?남아\\s?있음|리퍼\\s?가능|리퍼.*까지|리퍼.*년|리퍼\\s?.*\\d{2}[-/.]*(0?[1-9]|1[012])[-/.]*@케어|케플"
  # pencil
  reg_expr[6] = "pencil|펜슬|팬슬"
  
  return (reg_expr)
}

### obtain attribute values
### and combine them into a single dataframe
makeDataFrame <- function(reg_expr, attr_expr, mdata){
  display = extractOne(reg_expr[1], mdata, -1)
  connect = extractConnect(reg_expr[2], mdata, "Error")
  
  storage = extractOne(reg_expr[3], mdata, -1)
  storage = gsub("1\\s?테라|1tb?", 1024, storage, ignore.case=TRUE)
  
  regC = unlist(strsplit(reg_expr[4], "@"))
  attrC = unlist(strsplit(attr_expr[1], "@"))
  color = extractAll(regC, attrC, mdata)
  
  regC = unlist(strsplit(reg_expr[5], "@"))
  attrC = unlist(strsplit(attr_expr[2], "@"))
  service = extractAll(regC, attrC, mdata)
  
  state = extractState(mdata)
  
  pencil = extractExist(reg_expr[6], mdata)
  
  keyboard = extractKeyboard(mdata)
  
  return (cbind(display, connect, storage, color, service, state, pencil, keyboard))
}

### extract pro types from data 
### and extract information from pro types
### then save
extractProAndSave <- function(mdata){
  # pro
  reg_expr = "프로|pro/i"
  pro = titlePreprocess(reg_expr, mdata)
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
  
  # 기종별 게시글 수
  numOfPosts = c(nrow(pro), nrow(pro2), nrow(pro3))

  # 3세대 데이터 프레임 추출하고 저장하기
  pro3AttrReg = options(c("11|12.9", "64|256|512|1\\s?테라|1tb?", "실버 스페이스 그레이"))
  pro3Attr = c("실버@스페이스 그레이", "리퍼@애플케어플러스")
  pro3DF = makeDataFrame(pro3AttrReg, pro3Attr, pro3)
  pro3DF = cbind(pro3DF, subset(pro3, select=c("price", "title", "url")))
  write.table(pro3DF, "D:/scrap/pro3.csv", sep=",", append=TRUE, na="NA", row.names = FALSE, col.names = FALSE)

  # 2세대 데이터 프레임 추출하고 저장하기
  pro2AttrReg = options(c("10.5|12.9", "64|256|512", "실버 스페이스 그레이 로즈골드 골드"))
  pro2Attr = c("실버@스페이스 그레이@로즈골드@골드", "리퍼@애플케어플러스")
  pro2DF = makeDataFrame(pro2AttrReg, pro2Attr, pro2)
  pro2DF = cbind(pro2DF, subset(pro2, select=c("price", "title", "url", "sdate")))
  write.table(pro2DF, "D:/scrap/pro2.csv", sep=",", append=TRUE, na="NA", row.names = FALSE, col.names = FALSE)

  # 1세대 데이터 프레임 추출하고 저장하기
  proAttrReg = options(c("9.7|12.9", "32|128|256", "실버 스페이스 그레이 로즈골드 골드"))
  proAttr = c("실버@스페이스 그레이@로즈골드@골드", "리퍼@애플케어플러스")
  proDF = makeDataFrame(proAttrReg, proAttr, pro)
  proDF = cbind(proDF, subset(pro, select=c("price", "title", "url")))
  write.table(proDF, "D:/scrap/pro.csv", sep=",", append=TRUE, na="NA", row.names = FALSE, col.names = FALSE)
  return (numOfPosts)  
}

# make date vector
may = paste0("05", c(20:21, 23:26, 28, 30, 31))
june = paste0("060", c(1, 2, 4:9))
june = c(june, paste0("06", c(10:11)))
dateV = c(may, june)
fnameV = paste0("D:/scrap/scrapInfo2019", dateV, ".csv")

dailyPost = data.frame(matrix(nrow=0, ncol = 5))
for(i in 1:length(fnameV)){
  print(dateV[i])
  t = Preprocess(fnameV[i])
  tmp = extractProAndSave(t)
  print(tmp)
  dailyPost = rbind(dailyPost, c(nrow(t), tmp))
}
dailyPost = cbind(dateV, dailyPost)
write.table(dailyPost, "D:/scrap/dailyPost.csv", sep=",", append=TRUE, na="NA", row.names = FALSE, col.names = FALSE)
