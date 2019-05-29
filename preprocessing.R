tdf = read.csv("D:/scrap/scrapInfo20190528.csv", header = FALSE)
names(tdf) = c("url", "nick", "views", "title", "sale", "price", "id", "sdate", "edate")

### 전처리
# 제목에 아이패드가 포함되지 않은 row 제거
# :? 비캡쳐링 그룹, 그룹으로 묶어 주지만 캡쳐는 하지 않음
# | or
# /i flag, 대소문자 구분 하지 않음
# subset은 logical이 필요하므로 grepl 이용
ipad = grepl("(:?아이패드|ipad/i)", tdf$title)
#ttdf = subset(tdf, ipad)
tdf = subset(tdf, ipad)

# 케이스, 파우치, 키보드 등 단품 제외
# ?= lookaheads 연산자, 조건 매치 후 0으로 돌아가 검색 다시
single = grepl("(:?파우치|케이스|슬리브|키보드|필름|강화유리|충전기|case/i|keyboard/i)", tdf$title)
#tttdf = subset(ttdf, single)
ttdf = subset(tdf, single)
tdf = subset(tdf, !single)
single = grepl("(:?\\+|\\/|포함|증정)", ttdf$title)
#ttttdf = subset(tttdf, single)
ttdf = subset(ttdf, single)
tdf = rbind(tdf, ttdf)

# 교환 글 제외
exchange = grepl("교환", tdf)
tdf = subset(tdf, !exchange)

# 사기게시글 알려주는 게시글 분리
fraudI = grepl("사기|사 기|ㅅ ㅏㄱ ㅣ", tdf$title)
fraud = subset(tdf, fraudI)
tdf = subset(tdf, !fraudI)

### 기종별 분류
# pro
proI = grepl("프로|pro/i", tdf$title)
pro = subset(tdf, proI)
# 3세대
pro3I = grepl("3세대|프로3", pro$title)
pro3 = subset(pro, pro3I)
pro = subset(pro, !pro3I)
# 2세대
# 애플펜슬 2세대 결과 제외(3세대부터 호환)
pro2I = grepl("프로 2세대|프로2", pro$title)
pro2 = subset(pro, pro2I)
pro = subset(pro, !pro2I)
