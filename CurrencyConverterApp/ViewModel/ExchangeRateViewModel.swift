//
//  ExchangeRateViewModel.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

class ExchangeRateViewModel: ViewModelProtocol {
  
  enum Action {
    case fetch
    case search(String)
  }
  
  struct State {
    var rates = [ExchangeRateData]()
    var errorMessage: String?
    var searchKeyword = ""
    var isEmpty: Bool { rates.isEmpty && !searchKeyword.isEmpty }
  }
  
  private(set) var state = State() {
    didSet { onStateChange?(state) }
  }
  
  var onStateChange: ((State) -> Void)?
  var action: ((Action) -> Void)?
  
  private var allRates = [ExchangeRateData]()
  
  init() {
    self.action = { [weak self] action in
      switch action {
      case .fetch:
        self?.fetchRates()
      case .search(let keyword):
        self?.search(keyword: keyword)
      }
    }
  }
  
  private func fetchRates() {
    Task {
      do {
        let result = try await DataService().fetchData()
        self.allRates = result
        state = State(rates: result)
      } catch {
        state = State(errorMessage: DataError.parsingFailed.localizedDescription)
      }
    }
  }
  
  private func search(keyword: String) {
    let filteredRate = keyword.isEmpty
    ? allRates
    : allRates.filter { $0.currencyCode.localizedCaseInsensitiveContains(keyword) || $0.country.localizedCaseInsensitiveContains(keyword)}
    
    state = State(rates: filteredRate, errorMessage: nil, searchKeyword: keyword)
  }
}
