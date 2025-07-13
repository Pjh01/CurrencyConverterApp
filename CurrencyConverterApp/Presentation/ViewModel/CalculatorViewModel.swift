//
//  CalculatorViewModel.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

// 환율 계산기 ViewModel
class CalculatorViewModel: ViewModelProtocol {
  
  // 사용자의 액션 정의
  enum Action {
    case convert(String)          // 환율 변환
    case saveLastVisitedScreen    // 마지막 방문 화면 저장
  }
  
  // UI 상태 정의
  struct State {
    var resultText: String = ""   // 변환 결과 문자열
    var errorMessage: String?     // 에러 메시지
  }
  
  // 현재 상태를 바인딩할 때마다 onStateChange 클로저 호출
  private(set) var state = State() {
    didSet { onStateChange?(state) }
  }
  
  var action: ((Action) -> Void)?
  var onStateChange: ((State) -> Void)?
  
  let rateData: ExchangeRateData
  
  // 초기화 시 액션 바인딩 처리
  init(rateData: ExchangeRateData) {
    self.rateData = rateData
    self.state = State()
    self.action = { [weak self] action in
      switch action {
      case .convert(let input):
        self?.convert(input: input)
      case .saveLastVisitedScreen:
        CoreDataManager.shared.saveLastVisitedScreen(screenType: ScreenType.calculator.rawValue, currencyCode: rateData.currencyCode)
      }
    }
  }
  
  // 환율 변환 처리 로직
  private func convert(input: String) {
    // 공백 입력 방지
    guard !input.trimmingCharacters(in: .whitespaces).isEmpty else {
      state = State(resultText: "", errorMessage: "금액을 입력해주세요")
      return
    }
    
    // 숫자 입력 확인
    guard let isNumber = Double(input) else {
      state = State(resultText: "", errorMessage: "올바른 숫자를 입력해주세요")
      return
    }
    
    // 변환 결과 계산 후, 상태 갱신
    let convertedNumber = (isNumber * rateData.rate).formatted(format: "%.2f")
    let resultText = "$\(isNumber.formatted(format: "%.2f")) → \(convertedNumber) \(rateData.currencyCode)"
    state = State(resultText: resultText, errorMessage: nil)
  }
}
