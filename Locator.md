<!--https://www.guru99.com/locators-in-selenium-ide.html
https://www.softwaretestingmaterial.com/locators-in-selenium/
https://www.protechtraining.com/content/selenium_tutorial-locators-->

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

### DOM
HTML element 트리를 다루는 표준  
페이지의 구조에 의존적  
동적인 locator 이용가능

### XPath
XML 노드를 찾을 때 사용하는 표준    
class, name, id가 없는 element에 접근 가능  
브라우저의 XPath 구현에 의존적

### CSS Selector
HTML의 tag, id, class, attributes를 조합하여 element를 선택하는 문자열 패턴  
id나 name이 없는 element에도 접근이 가능

### CSS Selecotr와 XPath 비교
CSS Selector선호하는 사람들: 단순하고 속도도 빠르고 성능도 좋음(IE에 대해서)
XPath 선호하는 사람들: 페이지를 가로지를 수 있음(child to parent 방향으로 접근 가능)

CSS는 forward 방향으로만 탐색가능하나 XPath는 forward/backward모두 가능

### CSS Selectors
웹 페이지 내의 element를 찾기 위한 element selector와 값의 조합
HTML tags, attributes, id와 class에 대한 문자열 표현

####DIRECT CHILD
parent > direct child

#### CHILD or SUBCHILD
parent child: 공백이용

####ID
#id

####class
.class

####NEXT SIBLING
list navigate시 유용
같은 부모 내의 다음 인접 element찾음

####ATTRIBUTE VALUES
필드[속성='값'][속성2='값']

<!--
**결과
*****결과 얻기위한 doc
발표-->
