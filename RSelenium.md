# Selenium
<p>&nbsp;&nbsp;&nbsp;&nbsp;여러 종류의 브라우저 자동화를 지원해주는 툴로, 주로 웹 애플리케이션을 테스트할 때 사용</p>

#### Selenium Server
<p>&nbsp;&nbsp;&nbsp;&nbsp;사용자 입장에서 브라우저를 구동할 수 있게 해 줌. 로컬하게 구동시키거나 Selenium Server를 이용하여 원격 머신에서 구동시킬 수 있음. RSelenium과 브라우저를 같은 컴퓨터에서 동작시킬 경우 필요함. Selenium Server 바이너리 설치는 <a href="http://selenium-release.storage.googleapis.com/index.html">여기</a></p>

### 동작방식
<p>&nbsp;&nbsp;&nbsp;&nbsp;WebDriver와 Browser는 Driver를 통해 통신

#### WebDriver
<p>&nbsp;&nbsp;&nbsp;&nbsp;실사용자가 브라우저를 사용하는 방식과 비슷하게 동작하도록 하는 것이 목표임.Selenium 1.x의 RC를 개선한 것으로, 보다 간결한 프로그래밍 인터페이스를 제공하며, 브라우저를 훨씬 더 효과적으로 구동함. 무엇보다 새로운 기능이 추가됨(파일 업로드, 다운로드, 팝업, 대화 상자 등). WebDriver 바이너리를 시스템 환경변수에 추가해야 함.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;웹 브라우저는 비동기적으로 동작하기 때문에 WebDriver는 DOM의 상태를 실시간으로 반영하지 않음. 따라서, 브라우저와 WebDriver 사용자의 명령 사이에 race condition이 발생할 수 있음. 즉, 페이지로 이동(navigate)하여 element를 찾으려 했을 때, element가 페이지가 로딩된 후에 추가되었다면 no such element 에러가 발생할 수 있음. explicitly waiting이나 blocking을 이용하여 위의 문제점을 해결할 수 있음. WebElement.click이나 WebElement.sendKeys와 같은 명령은 브라우저에서 명령이 완료될 때까지 기다려 동기화를 보장함.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;Explicit Wait은 condition을 만족시킬 때까지 계속 시도함. 즉, conditin이 일어날 때까지 기다림. Implicit Wait은 일정 시간 동안 DOM을 polling함. Explicit Wait과 Implicit Wait을 함께 사용하면 의도하지 않은 결과가 나타나므로 둘 중 하나만 이용해야 함. Fluent Wait은 condition 만족 최대 대기시간과 condition 체크 빈도를 지정할 수 있음. 또한, 특정 예외를 무시하도록 할 수 있음.</p>
  
#### Driver
<p>&nbsp;&nbsp;&nbsp;&nbsp;실제로 브라우저를 제어하는 프로그램으로, 프록시라고도 부름. 브라우저에 따라 드라이버가 다르므로 원하는 브라우저의 드라이버를 다운받아 이용하면 됨(브라우저 세션을 설정하는 방법이 약간씩 다름). Chrome(드라이버 다운로드는 <a href="https://chromedriver.storage.googleapis.com/index.html">여기</a>), Firefox(드라이버 다운로드는 <a href="https://github.com/mozilla/geckodriver/releases">여기</a>), Edge(드라이버 다운로드는 <a href="https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/">여기</a>), Internet Explorer(드라이버 다운로드는 <a href="http://selenium-release.storage.googleapis.com/index.html">여기</a>), Opera(드라이버 다운로드는 <a href="https://github.com/operasoftware/operachromiumdriver/releases">여기</a>), Safari, HtmlUnit, PhantomJS 등의 드라이버가 존재</p>

### RSelenium
<p>&nbsp;&nbsp;&nbsp;&nbsp;JsonWireProtocol을 이용하여 R과 Selenium 2.0 WebDriver를 바인딩 해주는 패키지, Selenium Webdriver API와 R을 바인딩 해줌</p>

### 환경설정
- 자바: 11.0.1
- Selenium standalone server: 3.11.0
- 웹브라우저 드라이버: phantomjs 2.1.1

#### 참고
https://seleniumhq.github.io/docs/wd.html
