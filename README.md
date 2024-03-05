# 🪙 Crypto Coin Watch

- 서비스 소개: 코인 가격 정보 조회 및 즐겨찾기
- 개발인원: 1인
- 개발기간: 2024.02.26 ~ 2024.03.04


## 🛠️ 기술스택
- UIKit, RxSwift
- MVVM, Input/Ouput
- Alamofire, Realm
- Snapkit, Kingfisher, Charts

## 핵심기능
- 트렌트 코인 및 NFT 정보 조회
- 코인 검색
- 차트를 통한 코인 가격 기록 확인
- 즐겨찾기 코인 조회

## 고려사항
- 코인 즐겨찾기 추가 시 저장할 데이터
- 분당 호출수 제한에 따른 과호출 에러 핸들링

## 트러블슈팅
- 의존성 주입 시 뷰모델의 초기화 구문에서 주는 값을 받을 Observable 객체의 종류
- 네트워크의 Response를 Relay타입으로 받았을 때 런타임 에러 발생