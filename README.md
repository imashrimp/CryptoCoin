# 🪙 Crypto Coin Watch
<img src = "https://github.com/imashrimp/CryptoCoin/assets/114081840/1b746b07-2862-4522-90db-84313d2eb900.png" width="18%" height="40%">
<img src = "https://github.com/imashrimp/CryptoCoin/assets/114081840/475f60e4-3e02-4b5b-80d2-b441bdb0be7d" width="18%" height="40%">
<img src = "https://github.com/imashrimp/CryptoCoin/assets/114081840/f51b5b80-ad27-4774-9c60-729191861bb1" width="18%" height="40%">
<img src = "https://github.com/imashrimp/CryptoCoin/assets/114081840/ce7a9d1e-e625-4afb-b99a-6e249cf27448" width="18%" height="40%">
<img src = "https://github.com/imashrimp/CryptoCoin/assets/114081840/aaf78ddc-ccfb-4bda-bf72-906a2ed1af9d)" width="18%" height="40%">


---

- 서비스 소개: 실시간 가상화폐 가격정보 조회 및 즐겨찾기로 코인 정보 관리<br>
- 개발 인원: 1인<br>
- 개발 기간: 2024.02.26 ~ 2024.03.04

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
1.  호풀수 제한에 따른 과호출 에러 핸들링
   
    - 네트워크 호출을 줄이기 위해 검색화면에서의 즐겨찾기 기능은 통신없이 처리 가능
    - 과호출 에러 발생 시 얼럿을 통해 사용자가 일정 시간 후 앱을 다시 사용할 수 있도록 안내

2. Realm 저장 데이터

    - 가상화페의 실시간 가격정보 전달이 핵심이라 가격 정보는 Realm에 저장하지 않고,<br>즐겨찾기 코인 조회에 필요한 coinID만 RealmDB에 저장

3. 동기화 처리를 위한 데이터 전달 방식 결정
    - 즐겨찾기 목록 도익화를 위해 두 뎁스 이상 차이가 나는 화면에 대해서는 NotificationCenter를 사용<br>한 뎁스 차이가 나는 화면에서는 클로저를 사용해 데이터 전달
   

<br>

## 트러블슈팅
- 의존성 주입 시 뷰모델의 초기화 구문에서 주는 값을 받을 RxCocoa 객체의 종류(Behavior VS Publish)
  - 의존성 주입을 통해 초기값이 설정되는 객체는 해당 시점에서 구독되지 않았기 때문에 Publish타입으로 초기값 설정 이벤트를 받으면 이벤트 전달이 무의미 하게됨
  - BehaviorSubject 또는 BehaviroRelay로 이벤트를 받게 되면, Behavior의 특성상 구독 이전에 받은 이벤트를 갖고 있다가 구독이 되면 해당 이벤트를 방출하므로 의존성 주입을 통해 이벤트를 전달할 때는 Behavior가 더 적합함
    
<br>

- 네트워크의 Response를 Relay타입으로 받았을 때 런타임 에러 발생
  - Relay는 Subject와 다르게 error와 completed 이벤트를 처리하지 않음
  - 과호출 에러를 Relay타입으로 받아서 런타입 에러 발생했고,<br>이를 해결하기 위해 통신 메서드의 반환 타입을 Result으로 설정해 error 이벤트를 받는 객체를 Subject 타입으로 따로 만들어 런타임 에러 해결
