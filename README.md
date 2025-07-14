# 💱 Currency Converter App (환율 계산기 앱)

> UIKit 기반으로 구현된 환율 계산 및 조회 앱입니다.
앱 실행 시 국가별 환율 정보가 표시되며, 검색바를 통해 조회가 가능합니다.
해당 국가 클릭 시 환율을 계산할 수 있는 화면으로 전환할 수 있습니다.  
MVVM 아키텍처와 CoreData를 기반으로 로컬 데이터 캐싱, 즐겨찾기, 환율 변화 추적, 다크모드 기능을 지원합니다.

<br>

## ⏰ 프로젝트 일정 
- **시작일**: 2025/07/02 
- **종료일**: 2025/07/14

<br>

## 📌 주요 기능
### 1. 환율 리스트 화면
- 국가별 통화 코드, 국가명, 환율 정보를 테이블로 출력
- **실시간 환율 API**를 기반으로 최신 환율 조회
- **즐겨찾기 버튼**으로 원하는 통화를 상단에 고정  
- **상승 🔼 / 하락 🔽 / 변화 없음** 여부 표시 (전일 대비)

### 2. 환율 계산기 화면
- 원하는 통화를 선택하여 환율 계산 가능
- 입력 금액 기준으로 환산 결과 출력
- 예외처리(숫자가 아니거나 입력하지 않았을 경우) 오류창 표시

### 3. 즐겨찾기 관리
- CoreData에 즐겨찾기된 통화 코드 저장
- 즐겨찾기 항목은 리스트 상단에 표시 (동일한 그룹 내 알파벳 정렬 유지)
- 앱 재실행 시 즐겨찾기 상태 유지

### 4. 환율 변화 추적
- CoreData에 통화 코드, 환율, 변화 상태, 타임스탬프 저장
- `abs(new - old) > 0.01`일 경우 변화 여부 표시
- `changeStatus`: `"up"`, `"down"`, `"same"` (기본값)

### 5. 마지막 방문 화면 복원
- 사용자가 마지막으로 방문한 화면을 CoreData에 기록
- 앱 재실행 시 해당 화면으로 자동 이동

<br>

## 🛠 기술 스택
- Swift
- Xcode
- `UIKit`
- `MVVM Architecture`
- iOS 16.0 이상 지원
- `CoreData` (로컬 데이터 저장 및 변화 추적)
- `SnapKit` (레이아웃)
- `URLSession` (API 호출)

<br>

## 📂 프로젝트 구조
```
📁 CurrencyConverterApp/
├── 📂 App/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── 📂 Model/
│   ├── CountryData.swift                             # 통화 코드와 국가명 매핑 데이터
│   ├── DataError.swift                               # 네트워크 요청 중 발생할 수 있는 오류
│   ├── ExchangeRateData.swift                        # 셀 데이터
│   ├── ExchangeRateResponse.swift                    
│   ├── MockData.swift
│   ├── RateChangeStatus.swift                        # 환율 변화 상태
│   └── ScreenType.swift
├── 📂 CoreData/
│   ├── CoreDataManager.swift                         # CoreData 관련 로직 관리
│   └── CurrencyConverterApp.xcdatamodeld
├── 📂 Network/
│   └── DataService.swift                             # API 데이터 파싱
├── 📂 Presentation/
│   ├── 📂 View/
│   │   ├── ExchangeRateView.swift                    # 환율 목록 화면
│   │   ├── CalculatorView.swift                      # 환율 계산기 화면
│   │   └── ExchangeRateCell.swift                    # 환율 정보 테이블뷰 셀
│   ├── 📂 ViewModel/
│   │   ├── ExchangeRateViewModel.swift               # 환율 리스트 로직 관리
│   │   ├── CalculatorViewModel.swift                 # 환율 계산 로직 관리
│   │   └── ViewModelProtocol.swift
│   ├── 📂 ViewController/
│   │   ├── ExchangeRateViewController.swift          # 환율 리스트 화면 구성
│   │   ├── CalculatorViewController.swift            # 계산기 화면 구성
│   │   └── ExchangeRateViewController+Extension.swift
├── 📂 Resource/
│   └── Assets
```

<br>

## 🔁 API 정보
- 환율 API: https://open.er-api.com/v6/latest/USD
- 환율은 하루 1회 갱신되며, `time_last_update_unix` 필드로 최신 업데이트 시점을 확인
- 모든 통화 기준 `USD` 환율을 기준으로 계산

<br>

## 💻 실행 화면
- 추가 예정

<br>

## 🐞 UI 디버깅
[UI 디버깅](https://github.com/Pjh01/CurrencyConverterApp/pull/1)

<br>

## 🎯 개발 목적
- 비동기 네트워크 통신 처리 능력 향상
  - `async/await`, `URLSession`, 오류 처리 흐름을 통한 비동기 API 호출 실습
  - API 응답의 시간 정보(`timeLastUpdateUnix`)를 기반으로 로직 분기 처리
- Core Data 기반 로컬 영속성 저장 학습
  - `NSFetchRequest`, `NSPredicate`, Entity 생성/조회/삭제 흐름 구현
  - 사용자 즐겨찾기, 환율 상태, 마지막 방문 화면 정보 등을 저장
- MVVM 아키텍처 설계 및 상태 관리 학습
  - `ViewModel`에서 `Action`, `State`, `onStateChange` 패턴으로 뷰와 데이터 연결
  - ViewController는 로직이 없는 단순 연결만 담당 (Low Coupling)
- 화면 전환 흐름 및 사용자 경험 향상 설계
  - 마지막 방문 화면 기억 및 앱 재시작 시 복원 (UX 개선)
  - `SceneDelegate`를 이용한 진입 화면 제어 (`Calculator` or `ExchangeRate`)
- 조건부 UI 출력 및 상태 기반 렌더링 처리
  - 환율 변화 상태 비교 후 상승/하락/동일 아이콘 표시 (`🔼`, `🔽`, `""`)
  - 검색 결과 없을 때 안내 메시지 표시 (`검색 결과 없음`)
- 재사용 가능한 커스텀 뷰 구성 경험
  - `CalculatorView`, `ExchangeRateCell`, `ExchangeRateView` 분리 및 구조화
 - `SnapKit`을 사용한 일관된 AutoLayout 작성

<br>

## ✨ 향후 개선 아이디어
- 다국어 지원 (국가명 로컬라이징)
- 단위 포맷 조정 (환율 단위, 기호 등 사용자 설정)
- 단기/장기 환율 변화 그래프 지원 (ChartKit 등)

<br>

## 📦 설치 및 실행 방법
1. Xcode 설치
2. 프로젝트 클론
```bash
git clone https://github.com/Pjh01/CurrencyConverterApp.git
```
3. Xcode에서 프로젝트 열기
4. 시뮬레이터에서 실행 및 확인
