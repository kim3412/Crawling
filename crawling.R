library(RSelenium)
library(data.table)
# get yesterday's date
ydate = Sys.Date() - 1
ydate = as.character(ydate)
tdate = as.character(Sys.Date())
# set log file
logFileName = paste0("D:/scrap/", ydate, ".txt", sep="")
tt = file(logFileName, open="at")
sink(tt, type=c("output", "message"), append=TRUE)

####### setting browser
pjs <- wdman::phantomjs()
Sys.sleep(5)
### neeeeeeed some time # Sys.sleep(time in sec)
eCap <- list(phantomjs.page.settings.userAgent = "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:29.0) Gecko/20120101 Firefox/29.0")
remDr <- remoteDriver(browserName = "phantomjs", port = 4567L, extraCapabilities=eCap)
remDr$open() ### sometimes failure


####### login to naver
remDr$navigate("https://nid.naver.com/nidlogin.login")

id = remDr$findElement(using="id", value="id")
id$setElementAttribute("value", "yourId")
Sys.sleep(3)

pw = remDr$findElement(using="id", value="pw")
pw$setElementAttribute("value", "yourPW")
Sys.sleep(3)

loginBtn = remDr$findElement(using="css", value=".btn_global")
loginBtn$clickElement()


# use results directly
pageUrl = "https://cafe.naver.com/ArticleSearchList.nhn?search.clubid=10050146&search.media=0&search.searchdate=2019-05-062019-05-06&search.defaultValue=1&userDisplay=50&search.option=0&search.sortBy=date&search.searchBy=1&search.searchBlockYn=0&search.query=%BE%C6%C0%CC%C6%D0%B5%E5&search.viewtype=title&search.page=1"

# modify date
mDate = paste0("searchdate=", ydate, ydate, "&search.defaultValue", sep="")
pageUrl = gsub("searchdate=.*&search.defaultValue", mDate, pageUrl)


####### get yesterday's posts
ydf = data.frame(matrix(nrow=0, ncol=11))
ydf1 = data.frame(matrix(nrow=0, ncol=10))
page = 1

while(TRUE){
  tryCatch({
    
    print("navigate list")
    
    print(pageUrl)
    remDr$navigate(pageUrl)
    Sys.sleep(sample(3:6, 1))
    remDr$switchToFrame("cafe_main")
    
    ####### get infomation from search result
    ### board-number, url, nickname, number of views, title
    ### sales status, price are not always exists(so handle exception)
    
    # get posts list
    
    postList = remDr$findElements(using="css", value="#main-area  > div:nth-child(5) > table > tbody > tr")
    ### postList list
    saleStatusVec = c()
    priceVec = c()
    sellerVec = c()
    contentVec = c()
    commentVec = c()
    
    # boardNumVec and urlVec
    tmp = sapply(postList, function(x){x$findChildElement(using="css", value="td.td_article div.inner_number")})
    tmpText = sapply(tmp, function(x){as.character(x$getElementText())})
    urlVec = sapply(tmpText, function(x){paste0("https://cafe.naver.com/joonggonara/", x, sep="")})
    print("urlVec")
    
    # nickVec
    tmp = sapply(postList, function(x){x$findChildElement(using="css", value="td.td_name a")})
    nickVec = sapply(tmp, function(x){as.character(x$getElementText())})
    print("nickVec")
    
    # number of views
    tmp = sapply(postList, function(x){x$findChildElement(using="css", value="td.td_view")})
    numOfViewsVec = sapply(tmp, function(x){as.character(x$getElementText())})
    print("numOfViewsVec")
    
    # titleVec
    tmp = sapply(postList, function(x){x$findChildElement(using="css", value="td.td_article div.inner_list > a")})
    titleVec = sapply(tmp, function(x){as.character(x$getElementText())})
    print("titleVec")
    
    
    for(i in 1:length(urlVec)){
      
      tryCatch({
        
        print(i)
        # saleStatusVec
        remDr$navigate(urlVec[i])
        Sys.sleep(sample(3:6, 1))
        remDr$switchToFrame("cafe_main")
        
        tmp = remDr$findElement(using="tag name", value="em")
        tmpText = as.character(tmp$getElementAttribute("aria-label"))
        saleStatusVec[i] = tmpText
        print(tmpText)
        
        # sellerVec
        if(tmpText == "완료"){
          sellerVec[i] = NA
        }
        else{
          tmp = remDr$findElement(using="id", value="bt_email")
          tmpText = as.character(tmp$getElementText())
          sellerVec[i] = tmpText
          print(tmpText)
        }
        
        # priceVec
        tmp = remDr$findElement(using="css", value=".cost")
        tmpText = as.character(tmp$getElementText())
        tmpText = gsub(',', '', tmpText)
        priceVec[i] = tmpText
        print(tmpText)
        
        # contents
        tbody = remDr$findElement(using="id", value="tbody")
        textTbody = tbody$getElementText()
        textTbody = paste(unlist(textTbody), collapse='')
        contentVec[i] = textTbody
        
        # comments
        commentList = remDr$findElements(using="css", value="#cmt_list > li > div > p")
        if(!is.null(commentList)){
          tmp = unlist(sapply(commentList, function(x){x$getElementText()}))
          commentVec[i] = paste(tmp, collapse = '|')
        } else commentVec[i] = NA
      },
      error = function(e){
        saleStatusVec[i] = NA
        sellerVec[i] = NA
        priceVec[i] = NA
        print(e)
      })
    }
    
    # combine the infomation on each vector into datframe ydf
    ydf = rbind(ydf, cbind(urlVec, nickVec, numOfViewsVec, titleVec, saleStatusVec, priceVec, sellerVec, contentVec, commentVec))
  },
  error = function(e){
    merror = paste0("fail to get list ", pageUrl)
    print(merror)
    print(e)
    break
  },
  finally = {
    
    # sometimes even if it is not in the end of list, it stops
    # maybe have some problems during get postList and can't get 50 trs.
    page = page + 1
    pageNum = paste0("search.page=", page, sep="")
    pageUrl = gsub("search.page=.*", pageNum, pageUrl)
    
  })
  
}

tydate = gsub('-', '', ydate)
sdate = paste0(gsub('-', '.', ydate), '.')
dateVec = rep(sdate, nrow(ydf))
edate = ifelse(ydf$saleStatusVec == "완료", tdate, NA)
ydf = cbind(ydf, sdate, edate)
names(ydf) = c("url", "nick", "views", "title", "sale", "price", "d", "content", "comment", "sdate", "edate")
ydf1 = subset(ydf, select=-c(content, comment))

fname = paste0("D:/scrap/scrapInfo", tydate, ".csv")
fname1 = paste0("D:/scrap/scrapInfo", tydate, "t.csv")
write.table(ydf1, fname, sep=",", append=TRUE, na="NA", row.names = FALSE, col.names = FALSE)

write.table(ydf, fname1, sep=",", append=TRUE, na="NA", row.names = FALSE, col.names = FALSE)

ydf$본문내용
sink()
####### close
remDr$close() 
pjs$stop()
