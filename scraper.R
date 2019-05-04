library(RSelenium)

####### setting browser
pjs <- wdman::phantomjs()
remDr <- remoteDriver(browserName = "phantomjs", port = 4567L)
remDr$open() ### sometimes failure


####### login to naver
remDr$navigate("https://nid.naver.com/nidlogin.login")

id = remDr$findElement(using="id", value="id")
pw = remDr$findElement(using="id", value="pw")
id$sendKeysToElement(list("yourId"))
pw$sendKeysToElement(list("yourPw"))

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
ydate = Sys.Date()
ydate = as.numeric(ydate) - 1
ydate = as.Date(ydate, origin='1970-01-01')
ydate = as.character(ydate)

mDate = paste0("searchdate=", ydate, ydate, "&search.searchBy", sep="")
pageUrl = gsub("searchdate=.*&search.searchBy", mDate, pageUrl)

# get rid of duplicated %BE%C6%C0%CC%C6%D0%B5%E5(아이패드)
pageUrl = gsub("%BE%C6%C0%CC%C6%D0%B5%E5%BE%C6%C0%CC%C6%D0%B5%E5", "%BE%C6%C0%CC%C6%D0%B5%E5", pageUrl)

# navigate to pageUrl
remDr$navigate(pageUrl)
remDr$switchToFrame("cafe_main")


####### get infomation from search result
### board-number, writer, number of views, url, title
### sales status, price are not always exists(so handle exception)

# get posts list
postList = remDr$findElements(using="css", value="#main-area  > div:nth-child(5) > table > tbody > tr")

# variables
boardNumVec = c()
writerVec = c()
numOfViewsVec = c()
urlVec = c()
titleVec = c()
slaesStatusVec = c()
priceVec = c()

for (i in 1:length(postList)){
  # boardNumVec
  tmp = postList[[i]]$findChildElement(using="css", value="td.td_article div.inner_number")
  tmpText = as.character(tmp$getElementText())
  boardNumVec[i] = tmpText
  
  # writerVec
  tmp = postList[[i]]$findChildElement(using="css", value="td.td_name a")
  tmpText = as.character(tmp$getElementText())
  writerVec[i] = tmpText
  
  # number of views
  tmp = postList[[i]]$findChildElement(using="css", value="td.td_view")
  print("tmp created")
  tmpText = as.character(tmp$getElementText())
  print(tmpText)
  numOfViewsVec[i] = tmpText
  
  # urlVec
  tmp = postList[[i]]$findChildElement(using="css", value="td.td_article div.inner_list > a")
  tmpText = as.character(tmp$getElementAttribute("href"))
  numOfViewsVec[i] = tmpText
  tmpText2 = as.character(tmp$getElementText())
  titleVec[i] = tmpText2
}

####### close
remDr$close() 
pjs$stop()

