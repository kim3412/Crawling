# Selenium
<p>&nbsp;&nbsp;&nbsp;&nbsp;여러 종류의 브라우저 자동화를 지원해주는 툴로, 주로 웹 애플리케이션을 테스트할 때 사용</p>

#### Selenium Server
<p>&nbsp;&nbsp;&nbsp;&nbsp;사용자 입장에서 브라우저를 구동할 수 있게 해 줌. 로컬하게 구동시키거나 Selenium Server를 이용하여 원격 머신에서 구동시킬 수 있음. RSelenium과 브라우저를 같은 컴퓨터에서 동작시킬 경우 필요함. Selenium Server 바이너리 설치는 <a href="http://selenium-release.storage.googleapis.com/index.html">여기</a></p>

### 동작방식
<p>&nbsp;&nbsp;&nbsp;&nbsp;WebDriver와 Browser는 Driver를 통해 통신

#### WebDriver
<p>&nbsp;&nbsp;&nbsp;&nbsp;Selenium 1.x의 RC를 개선한 것으로, 보다 간결한 프로그래밍 인터페이스를 제공하며, 브라우저를 훨씬 더 효과적으로 구동함. 무엇보다 새로운 기능이 추가됨(파일 업로드, 다운로드, 팝업, 대화 상자). 실사용자가 브라우저를 사용하는 방식을 최대한 가깝게 모방하는 것이 목표임. WebDriver 바이너리를 시스템 환경변수에 추가해야 함.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;웹 브라우저가 비동기적으로 동작하기 때문에 WebDriver는 DOM의 실시간 상태를 추적하지 않음. 브라우저와 WebDriver 사용자의 지시 사이에 race condition이 발생할 수 있음(eg. 페이지로 이동하여 element를 찾으려 했을 때 no such element 에러가 발생할 수 있음). navigate는 문서가 readyState에서 complete 상태로 바뀔 때까지 기다림.</p>

#### Driver
<p>&nbsp;&nbsp;&nbsp;&nbsp;실제로 브라우저를 제어, 프록시라고도 부름. 브라우저에 따라 드라이버가 다르므로 원하는 브라우저의 드라이버를 다운받아 이용하면 됨(브라우저 세션을 설정하는 방법이 약간씩 다름). Chrome, Firefox, Edge, Internet Explorer, Opera, Safari, HtmlUnit, PhantomJS 등의 드라이버가 존재</p>

### RSelenium
JsonWireProtocol을 이용하여 R과 Selenium 2.0 WebDriver를 바인딩 해주는 패키지  
Selenium Webdriver API와 R을 바인딩 해줌

#### 참고
https://seleniumhq.github.io/docs/wd.html
