# Locators
selenium에서는 element를 식별하기 위해서 locator 이용  
아래와 같은 locators가 존재

### ID
W3C에서 한 페이지 내의 ID는 고유하게 작성할 것을 요구하므로 하나의 elemnet를 얻을 수 있음.   
id가 동적으로 생성되는 경우에는 사용할 수 없음.

### Name
id와 유사하나 여러 element가 같은 이름을 가지고 있을 경우 filter사용 가능  
filter로는 value나 index를 이용할 수 있음(index는 0부터 시작)  
정적이며 유사한 elements들의 list에 사용하기 좋음

### Link Text
hyperlink에만 작용, link의 일부분만을 이용할 수도 있음  
navigation 테스트에 유용

### DOM(Document Object Model)
문서 객체 모델로, HTML, XML 문서의 프로그래밍 인터페이스  
문서에 대해 구조화된 표현을 제공하여 프로그래밍 언어가 DOM의 구조에 접근할 수 있는 방법을 제공
페이지의 구조에 의존적  
동적인 locator 이용가능

### XPath
XML 문서의 특정 요소나 속성에 접근 하기 위한 경로를 지정하는 언어  
class, name, id가 없는 element에 접근 가능  
브라우저의 XPath 구현에 의존적

### CSS Selector
HTML의 tag, id, class, attributes를 조합하여 요소를 선택하는 문자열 패턴  
id나 name이 없는 element에도 접근이 가능

### CSS Selecotr와 XPath 비교
CSS Selector선호하는 사람들: 단순하고 속도도 빠르고 성능도 좋음(IE에 대해서)  
XPath 선호하는 사람들: 페이지를 가로지를 수 있음(child to parent 방향으로 접근 가능)  
(CSS는 forward 방향으로만 탐색가능하나 XPath는 forward/backward모두 가능)

참조:
https://www.protechtraining.com/content/selenium_tutorial-locators
