library(RSelenium)

####### setting browser
pjs <- wdman::phantomjs()
remDr <- remoteDriver(browserName = "phantomjs", port = 4567L)
remDr$open() ### sometimes failure


####### login to naver
remDr$navigate("https://nid.naver.com/nidlogin.login")

id = remDr$findElement(using="id", value="id")
id$setElementAttribute("value", "your id")

pw = remDr$findElement(using="id", value="pw")
pw$setElementAttribute("value", "your password")

loginBtn = remDr$findElement(using="css", value=".btn_global")
loginBtn$clickElement()


####### search ipad
remDr$navigate("https://cafe.naver.com/joonggonara") ### neeeed some time
queryInput = remDr$findElement(using="id", value="topLayerQueryInput")
# korean to utf-8
### nnnnneeeeeeeddddd some time, w/o time, it stucks, i don't know why
queryInput$sendKeysToElement(list("\xEC\x95\x84\xEC\x9D\xB4\xED\x8C\xA8\xEB\x93\x9C", key="enter"))


####### switch frame
### naver cafe is using frame, so change the frame
remDr$switchToFrame("cafe_main")


####### set page show yesterday's posts as many as possible 
### set search item
queryInput = remDr$findElement(using="id", value="queryTop")
# korean to utf-8
queryInput$sendKeysToElement(list("\xEC\x95\x84\xEC\x9D\xB4\xED\x8C\xA8\xEB\x93\x9C", key="enter"))

### set period doesn't work, so get to page by url
# get page Url
pageUrl = unlist(remDr$getCurrentUrl())
# https://cafe.naver.com/ArticleSearchList.nhn?search.clubid=value
# &search.searchdate=all
# &search.searchBy=num&search.query=%BE%C6%C0%CC%C6%D0%B5%E5%
# BE%C6%C0%CC%C6%D0%B5%E5
# &search.defaultValue=num&search.includeAll=&search.exclude=&search.include=&search.exact=&search.sortBy=date
# &userDisplay=15
# &search.media=0&search.option=0

### modify url so that can get as many results as possible
### and view only the posts posted yesterday
# modify the value of userDisplay to 15
mDisplay = paste0("userDisplay=", 50, "&search.media", split="")
pageUrl = gsub("userDisplay.*&search.media", mDisplay, pageUrl)

# modify the value of searchdate to yesterday(eg.2019-05-022019-05-02)
# get yesterday date
ydate = Sys.Date() - 1
ydate = as.character(ydate)

mDate = paste0("searchdate=", ydate, ydate, "&search.searchBy", sep="")
pageUrl = gsub("searchdate=.*&search.searchBy", mDate, pageUrl)

# get rid of duplicated %BE%C6%C0%CC%C6%D0%B5%E5(아이패드)
pageUrl = gsub("%BE%C6%C0%CC%C6%D0%B5%E5%BE%C6%C0%CC%C6%D0%B5%E5", "%BE%C6%C0%CC%C6%D0%B5%E5", pageUrl)

# navigate to pageUrl
remDr$navigate(pageUrl)
remDr$switchToFrame("cafe_main")

# get link which contains search.page
tmp = remDr$findElement(using="css", value="#main-area div.prev-next a")
pageUrl = tmp$getElementAttribute("href")


####### get yesterday's posts
ydf = data.frame(matrix(nrow=0, ncol=9))
page = 1
while(TRUE){
  
  remDr$navigate(pageUrl)
  Sys.sleep(sample(3:6, 1))
  remDr$switchToFrame("cafe_main")
  
  ####### get infomation from search result
  ### board-number, url, nickname, number of views, title
  ### sales status, price are not always exists(so handle exception)
  
  # get posts list
  postList = remDr$findElements(using="css", value="#main-area  > div:nth-child(5) > table > tbody > tr")
  
  # variables
  boardNumVec = c()
  nickVec = c()
  numOfViewsVec = c()
  urlVec = c()
  titleVec = c()
  saleStatusVec = c()
  priceVec = c()
  sellerVec = c()

  for (i in 1:length(postList)){
    
    # boardNumVec and urlVec
    tmp = postList[[i]]$findChildElement(using="css", value="td.td_article div.inner_number")
    tmpText = as.character(tmp$getElementText())
    boardNumVec[i] = tmpText
    urlVec[i] = paste0("https://cafe.naver.com/joonggonara/", tmpText, sep="")
     
    # nickVec
    tmp = postList[[i]]$findChildElement(using="css", value="td.td_name a")
    tmpText = as.character(tmp$getElementText())
    nickVec[i] = tmpText
    
    # number of views
    tmp = postList[[i]]$findChildElement(using="css", value="td.td_view")
    tmpText = as.character(tmp$getElementText())
    numOfViewsVec[i] = tmpText
    
    # titleVec
    tmp = postList[[i]]$findChildElement(using="css", value="td.td_article div.inner_list > a")
    tmpText = as.character(tmp$getElementText())
    titleVec[i] = tmpText
        
    Sys.sleep(sample(4:8, 1))
  }

  for(i in 1:length(urlVec)){
    
    tryCatch({
      
      # saleStatusVec
      remDr$navigate(urlVec[i])
      remDr$switchToFrame("cafe_main")
      
      tmp = remDr$findElement(using="tag name", value="em")
      tmpText = as.character(tmp$getElementAttribute("aria-label"))
      saleStatusVec[i] = tmpText
      
      # sellerVec
      if(tmpText == "완료"){
        sellerVec[i] = NA
      }
      else{
        tmp = remDr$findElement(using="id", value="bt_email")
        tmpText = as.character(tmp$getElementText())
        sellerVec[i] = tmpText
      }
      
      # priceVec
      tmp = remDr$findElement(using="css", value=".cost")
      tmpText = as.character(tmp$getElementText())
      priceVec[i] = tmpText
    },
    error = function(e){
      saleStatusVec[i] = NA
      sellerVec[i] = NA
      priceVec[i] = NA
    },
    finally = {
      Sys.sleep(sample(30:52, 1))
    })  
  }
  
  # combine the infomation on each vector into datframe ydf
  ydf = rbind(ydf, cbind(boardNumVec, urlVec, nickVec, numOfViewsVec, titleVec, saleStatusVec, priceVec, sellerVec))
  tdate = format(Sys.Date()-1, "%Y.%m.%d.")
  dateVec = rep(tdate, nrow(ydf))
  edate = ifelse(saleStatusVec == "완료", tdate, NA)
  ydf = cbind(ydf, tdate, edate)

  # sometimes even if it is not in the end of list, it stops
  # maybe have some problems during get postList and can't get 50 trs.
  if(length(postList) != 50) break
  page = page + 1
  pageNum = paste0("search.page=", page, sep="")
  pageUrl = gsub("search.page=.*", pageNum, pageUrl)
  
}

####### write data to file
write.table(ydf, "D:/scrap/scrapInfo.csv", sep=",", append=TRUE, na="NA", row.names=FALSE, col.names=FALSE)

####### close
remDr$close() 
pjs$stop()

