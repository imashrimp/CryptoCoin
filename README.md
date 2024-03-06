# 🪙 Crypto Coin Watch

---
## 개발환경
> 서비스 소개: 실시간 가상화폐 가격정보 조회 및 즐겨찾기로 코인 정보 관리<br>
> 개발 인원: 1인<br>
> 개발 기간: 2024.02.26 ~ 2024.03.04

<br>

## 기술스택
- UIKit, RxSwift
- MVVM, Input/Ouput
- Alamofire, Realm
- Snapkit, Kingfisher, Charts

<br>

## 핵심기능
- **가상화폐 가격정보 조회**(등락률, 신고점, 신저점, 고가, 저가, 현재 가격)
- **가상화폐 검색**(검색어 강조)
- **가상화폐 즐겨찾기**(추가 / 삭제)
- **차트**(LineChart를 통한 변동 추이 확인)

<br>

## 고려사항
1. 호출수 제한에 따른 과호출 에러 핸들링
  - 네트워크 호출을 줄이기 위해 검색화면에서의 즐겨찾기 추가 및 삭제는 통신을 하지 않고 처리
  - 과호출 에러 발생 시 얼럿을 통해 사용자가 일정 시간 후 앱을 다시 사용할 수 있도록 안내
<br>
2. 코인 즐겨찾기 추가 시 저장할 데이터
 

  - 가상화폐의 실시간 가격정보 전달이 가장 중요하기 때문에 가격 정보는 Realm에 저장하지 않고,<br>즐겨찾기 코인 조회에 필요한 coinID만 RealmDB에 저장

<br>

3. 데이터 전달방식 결정
  - 즐겨찾기 목록 동기화를 위해 두 뎁스 이상 차이가 나는 화면에 대해서는 NotificationCenter를 사용<br>한 뎁스 차이가 나는 화면에서는 클로저를 사용해 동기화 처리함

## 트러블슈팅
- 의존성 주입 시 뷰모델의 초기화 구문에서 주는 값을 받을 RxCocoa 객체의 종류(Behavior VS Publish)
  - PublishSubject 또는 PublishRelay로 의존성 주입을 통해 이벤트를 전달할 경우, viewModel 인스턴스가 생성된 시점에서 Publish에 대한 구독이 되어있지 않기 때문에 전달된 이벤트가 무의미함
  - BehaviorSubject 또는 BehaviroRelay로 이벤트를 받게 되면, Behavior의 특성상 구독 이전에 받은 이벤트를 갖고 있다가 구독이 되면 해당 이벤트를 방출하므로
  - 의존성 주입을 통해 이벤트를 전달할 때는 Behavior가 더 적합함 
- 네트워크의 Response를 Relay타입으로 받았을 때 런타임 에러 발생
  - Relay는 Subject와 다르게 error와 completed 이벤트를 처리하지 않음
  - 과호출 에러를 Relay타입으로 받아서 런타입 에러 발생했고, 이를 해결하기 위해 통신 메서드의 반환 타입을 Result으로 설정해 error 이벤트를 받는 Observer를 따로 만들어 런타임 에러 해결
