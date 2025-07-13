//
//  ExchangeRateViewModel.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import Foundation

class ExchangeRateViewModel: ViewModelProtocol {
  
  enum Action {
    case fetch
    case search(String)
    case toggleFavorite(String)
    case saveLastVisitedScreen
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
  private let dataService: DataService
  
  init(dataService: DataService = DataService()) {
    self.dataService = dataService
    self.state = State()
    setupActions()
  }
  
  private func setupActions() {
    action = { [weak self] action in
      switch action {
      case .fetch:
        self?.fetchRates()
      case .search(let keyword):
        self?.state.searchKeyword = keyword
        self?.updateRateState()
      case .toggleFavorite(let code):
        self?.toggleFavorite(code: code)
      case .saveLastVisitedScreen:
        CoreDataManager.shared.saveLastVisitedScreen(screenType: "list", currencyCode: "")
      }
    }
  }
  
  private func fetchRates() {
    Task {
      do {
        let result = try await dataService.fetchData()
        
        let newTime = Date(timeIntervalSince1970: TimeInterval(result.timeLastUpdateUnix))
        
        let favoriteCurrencyCodes = CoreDataManager.shared.loadFavorites()
        self.allRates = result.rates.compactMap { currencyCode, rate in
          var changeStatus: RateChangeStatus
          let entity = CoreDataManager.shared.getExchangeRate(for: currencyCode)
          
          if Calendar.current.isDate(entity.timeStamp, inSameDayAs: newTime) {
            changeStatus = RateChangeStatus(rawValue: entity.changeStatus) ?? .same
          } else {
            changeStatus = compareRate(old: entity.rate, new: rate)
            
            CoreDataManager.shared.updateExchangeRate(currencyCode: currencyCode, rate: rate, changeStatus: changeStatus.rawValue, timeStamp: newTime)
          }
          
          return ExchangeRateData(
            currencyCode: currencyCode,
            country: CountryData[currencyCode] ?? "Unknown",
            rate: rate,
            isFavorite: favoriteCurrencyCodes.contains(currencyCode),
            changeStatus: changeStatus
          )
        }
        
        updateRateState()
      } catch {
        state = State(errorMessage: DataError.parsingFailed.localizedDescription)
      }
    }
  }
  
  private func toggleFavorite(code: String) {
    if let index = allRates.firstIndex(where: { $0.currencyCode == code }) {
      allRates[index].isFavorite.toggle()
      
      if allRates[index].isFavorite {
        CoreDataManager.shared.addFavorite(code)
      } else {
        CoreDataManager.shared.removeFavorite(code)
      }
      
      updateRateState()
    }
  }
  
  private func updateRateState() {
    let keyword = state.searchKeyword
    let filtered = keyword.isEmpty
    ? allRates
    : allRates.filter {
      $0.currencyCode.localizedCaseInsensitiveContains(keyword) ||
      $0.country.localizedCaseInsensitiveContains(keyword)
    }
    
    state = State(
      rates: sortItems(filtered),
      errorMessage: nil,
      searchKeyword: keyword
    )
  }
  
  private func sortItems(_ items: [ExchangeRateData]) -> [ExchangeRateData] {
    let favorites = items.filter { $0.isFavorite }.sorted { $0.currencyCode < $1.currencyCode }
    let nonFavorites = items.filter { !$0.isFavorite }.sorted { $0.currencyCode < $1.currencyCode }
    return favorites + nonFavorites
  }
  
  private func compareRate(old: Double, new: Double) -> RateChangeStatus {
    let diff = new - old
    if abs(diff) <= 0.01 { return .same }
    return diff > 0 ? .up : .down
  }
}
