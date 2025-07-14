//
//  ExchangeRateView.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import UIKit
import SnapKit

// 환율 목록 화면의 View 구성 클래스
class ExchangeRateView: UIView {
  
  // 검색 바
  let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "통화 검색"
    searchBar.searchBarStyle = .minimal
    searchBar.autocapitalizationType = .none
    return searchBar
  }()
  
  // 환율 데이터를 표시할 테이블뷰
  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.rowHeight = 60
    tableView.register(ExchangeRateCell.self, forCellReuseIdentifier: ExchangeRateCell.id)
    return tableView
  }()
  
  // 검색 결과가 없을 때 표시되는 라벨
  private let filterLabel: UILabel = {
    let label = UILabel()
    label.text = "검색 결과 없음"
    label.textColor = .secondaryLabel
    label.textAlignment = .center
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // UI 컴포넌트 레이아웃 설정
  private func setupUI() {
    
    [searchBar, tableView].forEach { addSubview($0) }
    
    searchBar.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide)
      $0.trailing.leading.equalToSuperview()
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(searchBar.snp.bottom)
      $0.bottom.leading.trailing.equalTo(safeAreaLayoutGuide)
    }
  }
  
  // 검색 결과가 비었을 때 백그라운드 라벨 표시
  func updateTableViewBackground(isEmpty: Bool) {
    tableView.backgroundView = isEmpty ? filterLabel : nil
  }
}
