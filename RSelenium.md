# RSelenium
R에서 Selenium Server나 Remote Selenium Server에 연결 해주는 패키지

### Selenium
<p>&nbsp;&nbsp;&nbsp;&nbsp;브라우저를 자동화해주는 툴로, 주로 웹 애플리케이션을 테스트할 때 사용</p>

### Selenium Server
<p>&nbsp;&nbsp;&nbsp;&nbsp;다양한 브라우저에서 HTML 테스트 해 볼 수 있게 해주는  standalone java 프로그램(외부 모듈이나 라이브러리 프로그램 등을 로드하지 않고 동작하는 프로그램, 즉 독자적으로 실행가능한 프로그램)으로, RSelenium과 브라우저를 같은 컴퓨터에서 동작시킬 경우 필요함. Selenium Server 바이너리 설치는 <a href="http://selenium-release.storage.googleapis.com/index.html">여기</a></p>

### Docker
<p>&nbsp;&nbsp;&nbsp;&nbsp;wdman(Webdriver Manager)의 rsDriver를 이용하거나 java 바이너리를 수동으로 작동시킬 수 있으나, Docker를 이용하여 Selenium Server를 동작시킬 예정</p>

<p>&nbsp;&nbsp;&nbsp;&nbsp;도커는 <strong>컨테이너 기반의 오픈소스 가상화 플랫폼</strong>으로 프로그램, 실행환경을 컨테이너로 추상화하여 동일한 인터페이스를 제공해줌으로써 프로그램의 배포 및 관리를 단순하게 해줌. <a href="https://subicura.com/2017/01/19/docker-guide-for-beginners-1.html">참고한 사이트</a></p>

<p>&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://docs.docker.com/toolbox/toolbox_install_windows/">도커 설치 가이드</a>  
/설치 조건: Windows 7이상, 64bit 운영체제</p>

<p>&nbsp;&nbsp;&nbsp;&nbsp;status 125 error, 사용하지 않은 port번호로 변경해주면 해결, 포트번호 풀어주는 방법 찾아봐야겠음...</p>

<p>&nbsp;&nbsp;&nbsp;&nbsp;docker-machine ip 명령시 No machine name specified and no "default" machine exists 에러 메시지 뜸</p>

<a href="https://docs.docker.com/machine/drivers/hyper-v/">Microsoft Hyper-V로</a> vm 생성, vm생성하고 vm이름주어서 docker-machine ip 명령 내리면 ip주소 반환, shell('명령어')을 관리자 권한으로 실행할 수 있는 방법... </p>
