//
//  ExchangeRateViewModel.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import Foundation

// 환율 리스트를 관리하는 ViewModel
class ExchangeRateViewModel: ViewModelProtocol {
  
  enum Action {
    case fetch                    // 환율 데이터 새로고침
    case search(String)           // 검색어에 따른 필터링
    case toggleFavorite(String)   // 즐겨찾기 토글
    case saveLastVisitedScreen    // 마지막 방문 화면 저장
  }
  
  struct State {
    var rates = [ExchangeRateData]()    // 현재 보여줄 환율 데이터 목록
    var errorMessage: String?           // 에러 메시지
    var searchKeyword = ""              // 현재 검색어
    var isEmpty: Bool { rates.isEmpty && !searchKeyword.isEmpty }   // 검색 결과가 없을 때 true
  }
  
  // 상태 변경 시 뷰에 알려주기 위한 클로저
  private(set) var state = State() {
    didSet { onStateChange?(state) }
  }
  
  var onStateChange: ((State) -> Void)?
  var action: ((Action) -> Void)?
  
  private var allRates = [ExchangeRateData]()   // 전체 환율 데이터 (필터링 전)
  private let dataService: DataService          // API 호출 서비스
  
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
        CoreDataManager.shared.saveLastVisitedScreen(screenType: ScreenType.list.rawValue, currencyCode: "")
      }
    }
  }
  
  // 비동기 API 호출 및 데이터 업데이트
  private func fetchRates() {
    Task {
      do {
        let result = try await dataService.fetchData()
        
        let newTime = Date(timeIntervalSince1970: TimeInterval(result.timeLastUpdateUnix))
        
        let favoriteCurrencyCodes = CoreDataManager.shared.loadFavorites()
        
        // 환율 목록을 모델에 맞게 변환 및 변경 상태 업데이트
        self.allRates = result.rates.compactMap { currencyCode, rate in
          var changeStatus: RateChangeStatus
          let entity = CoreDataManager.shared.loadExchangeRate(for: currencyCode)
          
          if Calendar.current.isDate(entity.timeStamp, inSameDayAs: newTime) {
            // 같은 날짜면 기존 상태 유지
            changeStatus = RateChangeStatus(rawValue: entity.changeStatus) ?? .same
          } else {
            // 날짜가 다르면 변동 여부 계산 후 업데이트
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
  
  // 즐겨찾기 상태 토글
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
  
  // 검색어에 따른 필터링 및 정렬된 상태 업데이트
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
  
  // 즐겨찾기 우선 정렬, 그 다음 알파벳 순 정렬
  private func sortItems(_ items: [ExchangeRateData]) -> [ExchangeRateData] {
    let favorites = items.filter { $0.isFavorite }.sorted { $0.currencyCode < $1.currencyCode }
    let nonFavorites = items.filter { !$0.isFavorite }.sorted { $0.currencyCode < $1.currencyCode }
    return favorites + nonFavorites
  }
  
  // 환율 변동 상태 계산 함수
  private func compareRate(old: Double, new: Double) -> RateChangeStatus {
    let diff = new - old
    if abs(diff) <= 0.01 { return .same }
    return diff > 0 ? .up : .down
  }
}
