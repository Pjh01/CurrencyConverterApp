//
//  CalculatorViewModel.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

class CalculatorViewModel: ViewModelProtocol {
  
  enum Action {
    case convert(String)
  }
  
  struct State {
    var resultText: String = ""
    var errorMessage: String?
  }
  
  private(set) var state = State() {
    didSet { onStateChange?(state) }
  }
  
  var action: ((Action) -> Void)?
  var onStateChange: ((State) -> Void)?
  
  let rateData: ExchangeRateData
  
  init(rateData: ExchangeRateData) {
    self.rateData = rateData
    self.action = { [weak self] action in
      switch action {
      case .convert(let input):
        self?.convert(input: input)
      }
    }
  }
  
  private func convert(input: String) {
    guard !input.trimmingCharacters(in: .whitespaces).isEmpty else {
      state = State(resultText: "", errorMessage: "금액을 입력해주세요")
      return
    }
    
    guard let isNumber = Double(input) else {
      state = State(resultText: "", errorMessage: "올바른 숫자를 입력해주세요")
      return
    }
    
    let convertedNumber = (isNumber * rateData.rate).formatted(format: "%.2f")
    let resultText = "$\(isNumber.formatted(format: "%.2f")) → \(convertedNumber) \(rateData.currencyCode)"
    state = State(resultText: resultText, errorMessage: nil)
  }
}
