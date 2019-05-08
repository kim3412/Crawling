library(RSelenium)

# set logfile name as yesterday's date
ydate = Sys.Date() - 1
ydate = as.character(ydate)
logFileName = paste0("D:/scrap/", ydate, ".txt")
# sink
tt = file("D:/scrap/0507.txt", open="at")
sink(tt, type=c("output", "message"), append=TRUE)

####### setting browser
pjs <- wdman::phantomjs()
Sys.sleep(5)
eCap <- list(phantomjs.page.settings.userAgent = "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:29.0) Gecko/20120101 Firefox/29.0")
remDr <- remoteDriver(browserName = "phantomjs", port = 4567L, extraCapabilities=eCap)
remDr$open()


####### login to naver
remDr$navigate("https://nid.naver.com/nidlogin.login")

id = remDr$findElement(using="id", value="id")
id$setElementAttribute("value", "Input your id")
Sys.sleep(3)

pw = remDr$findElement(using="id", value="pw")
pw$setElementAttribute("value", "Input your pw")
Sys.sleep(3)

loginBtn = remDr$findElement(using="css", value=".btn_global")
loginBtn$clickElement()


# use url directly
pageUrl = "https://cafe.naver.com/ArticleSearchList.nhn?search.clubid=10050146&search.media=0&search.searchdate=2019-05-062019-05-06&search.defaultValue=1&search.exact=&search.include=&userDisplay=50&search.exclude=&search.option=0&search.sortBy=date&search.searchBy=0&search.searchBlockYn=0&search.includeAll=&search.query=%BE%C6%C0%CC%C6%D0%B5%E5&search.viewtype=title&search.page=1"

# modify date
mDate = paste0("searchdate=", ydate, ydate, "&search.defaultValue", sep="")
pageUrl = gsub("searchdate=.*&search.defaultValue", mDate, pageUrl)


####### get yesterday's posts
ydf = data.frame(matrix(nrow=0, ncol=10))
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
      print(i)
      
      # boardNumVec and urlVec
      tmp = postList[[i]]$findChildElement(using="css", value="td.td_article div.inner_number")
      tmpText = as.character(tmp$getElementText())
      boardNumVec[i] = tmpText
      urlVec[i] = paste0("https://cafe.naver.com/joonggonara/", tmpText, sep="")
      print(tmpText)
      
      # nickVec
      tmp = postList[[i]]$findChildElement(using="css", value="td.td_name a")
      tmpText = as.character(tmp$getElementText())
      nickVec[i] = tmpText
      print(tmpText)
      
      # number of views
      tmp = postList[[i]]$findChildElement(using="css", value="td.td_view")
      tmpText = as.character(tmp$getElementText())
      numOfViewsVec[i] = tmpText
      print(tmpText)
      
      # titleVec
      tmp = postList[[i]]$findChildElement(using="css", value="td.td_article div.inner_list > a")
      tmpText = as.character(tmp$getElementText())
      titleVec[i] = tmpText
      print(tmpText)
      
      Sys.sleep(sample(4:8, 1))
    }
    
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
        priceVec[i] = tmpText
        print(tmpText)
      },
      error = function(e){
        saleStatusVec[i] = NA
        sellerVec[i] = NA
        priceVec[i] = NA
        print(e)
      })
      
      Sys.sleep(sample(8:11, 1))
    }
    
  },
  error = function(e){
    merror = paste0("fail to get list ", pageUrl)
    print(merror)
    print(e)
    
  },
  finally = {
    # combine the infomation on each vector into datframe ydf
    ydf = rbind(ydf, cbind(boardNumVec, urlVec, nickVec, numOfViewsVec, titleVec, saleStatusVec, priceVec, sellerVec))
    
    if(length(postList) != 50) break
    page = page + 1
    pageNum = paste0("search.page=", page, sep="")
    pageUrl = gsub("search.page=.*", pageNum, pageUrl)
    
  })
  
}

# add posting date and sales end date to the data frame
# then store data frame
tdate = format(Sys.Date()-1, "%Y.%m.%d.")
dateVec = rep(tdate, nrow(ydf))
edate = ifelse(ydf$saleStatusVec == "완료", tdate, NA)
ydf = cbind(ydf, tdate, edate)
write.table(ydf, "D:/scrap/scrapInfo.csv", sep=",", append=TRUE, na="NA", row.names = FALSE, col.names = FALSE)

# relase the sink
sink()
####### close
remDr$close() 
pjs$stop()
