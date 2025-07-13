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
    case toggleFavorite(String)
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
  private let coreDataManager: CoreDataManager
  
  init(dataService: DataService = DataService(), coreDataManager: CoreDataManager) {
    self.dataService = dataService
    self.coreDataManager = coreDataManager
    self.state = State()
    setupActions()
  }
  
  private func setupActions() {
    action = { [weak self] action in
      switch action {
      case .fetch:
        self?.fetchRates()
      case .search(let keyword):
        self?.search(keyword: keyword)
      case .toggleFavorite(let code):
        self?.toggleFavorite(code: code)
      }
    }
  }
  
  private func fetchRates() {
    Task {
      do {
        let result = try await dataService.fetchData()
        
        let favoriteCurrencyCodes = coreDataManager.loadFavorites()
        self.allRates = result.rates.map { currencyCode, rate in
          ExchangeRateData(
            currencyCode: currencyCode,
            country: CountryData[currencyCode] ?? "Unknown",
            rate: rate,
            isFavorite: favoriteCurrencyCodes.contains(currencyCode)
          )
        }.sorted { $0.currencyCode < $1.currencyCode }
        
        updateRateState()
      } catch {
        state = State(errorMessage: DataError.parsingFailed.localizedDescription)
      }
    }
  }
  
  private func search(keyword: String) {
    state.searchKeyword = keyword
    updateRateState()
  }
  
  private func toggleFavorite(code: String) {
    if let index = allRates.firstIndex(where: { $0.currencyCode == code }) {
      allRates[index].isFavorite.toggle()
      
      if allRates[index].isFavorite {
        coreDataManager.addFavorite(code)
      } else {
        coreDataManager.removeFavorite(code)
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
}
