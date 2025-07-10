//
//  ExchangeRateView.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import UIKit
import SnapKit

class ExchangeRateView: UIView {
  
  let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "통화 검색"
    searchBar.searchBarStyle = .minimal
    searchBar.autocapitalizationType = .none
    return searchBar
  }()
  
  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.rowHeight = 60
    tableView.register(ExchangeRateCell.self, forCellReuseIdentifier: ExchangeRateCell.id)
    return tableView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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
  
}
