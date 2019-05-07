# Web Crawling

<p>&nbsp;&nbsp;&nbsp;&nbsp;웹사이트에서 웹 페이지를 가져와 정보를 추출하는 것</p>

### 정적 페이지
<p>&nbsp;&nbsp;&nbsp;&nbsp;서버에 미리 저장된 파일이 그대로 전달되는 웹 페이지</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;요청에 대한 파일을 전송하기만 하면 되므로 빠름.
하지만, 저장된 정보만을 보여줄 수 있기 때문에 서비스가 한정적임. 또한, 웹페이지에 정보를 추가/수정/삭제하는 작업을 직접 해야 하므로 관리가 힘듬.</p>

### 동적 페이지
<p>&nbsp;&nbsp;&nbsp;&nbsp;스크립트에 의해 데이터들이 가공처리 후 전달되는 웹페이지</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;사용자의 요청에 따라 데이터를 처리하는 작업이 필요하므로 정적 페이지에 비해 느리나 다양한 서비스를 제공할 수 있음.</p>

### crawling 기법
<p>&nbsp;&nbsp;&nbsp;&nbsp;정적페이지에서는 HTML의 tag와 속성을 이용하여 원하는 정보를 추출할 수 있음. 하지만 JavaScript를 이용하여 동적으로 
렌더링되는 경우 단순히 HTML에서 정보를 얻을 수 없음. 페이지에서 제공하는 API 활용, Web Driver 이용, 
Ajax 요청을 분석하는 방법 등을 사용하여 정보를 얻어 올 수 있음.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;API를 이용할 경우, 정확한 정보를 빠르게 얻을 수 있음. API 쓰는 방법을 익혀야 하고, API 키를 발급받아야 함.
Web Driver는 웹브라우저 UI 테스팅 툴로 동적 로딩을 지원하고 브라우징을 자동화 해주기 때문에 크롤링할 때 많이 사용됨. 브라우저를 작동시켜서
정보를 얻어오므로 네트워크 상태에 영향을 많이 받고 느리다는 단점이 있음. Ajax 요청을 분석하는 방법은 네트워크 리버싱을 통해 
데이터 송/수신 구조를 추정하는 방법임. </p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;Ajax는 Asynchronous JavaScript and XML의 줄임말로 웹 개발 기법임. <del>어떻게 동작하는 거고,
  어떻게 크롤링이 가능한 것인지에 대한 조사 필요</del></p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;네이버카페에 대해서 카페 가입하기, 카페 게시글 쓰기 API가 제공되고 있음.
게시글 정보를 제공하는 API는 존재하지 않으므로 Selenium을 이용하여 Web Driver를 구동시켰음.</p>

#### 참조
정적/동적 웹 페이지: https://titus94.tistory.com/category/%EC%9E%90%EA%B2%A9%EC%A6%9D/%EC%A0%84%EC%9E%90%EC%83%81%EA%B1%B0%EB%9E%98  
크롤링 기법: https://www.slideshare.net/wangwonLee/2018-datayanolja-moreeffectivewebcrawling
