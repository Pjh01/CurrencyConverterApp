//
//  ViewController.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import UIKit

class ExchangeRateViewController: UIViewController {
  
  let exchangeRateView = ExchangeRateView()
  var allData = [ExchangeRateData]()
  var filteredData = [ExchangeRateData]()
  
  override func loadView() {
    self.view = exchangeRateView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupDelegates()
    fetchCurrencyData()
  }
  
  private func setupUI() {
    view.backgroundColor = .systemBackground
    navigationItem.title = "환율 정보"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
  }
  
  private func setupDelegates() {
    exchangeRateView.tableView.delegate = self
    exchangeRateView.tableView.dataSource = self
    exchangeRateView.searchBar.delegate = self
  }
  
  private func fetchCurrencyData() {
    Task {
      do {
        let result = try await DataService().fetchCurrencyData()
        allData = result
        filteredData = result
        exchangeRateView.tableView.reloadData()
      } catch {
        showAlert(DataError.parsingFailed)
      }
    }
  }
  
  func showAlert(_ error: Error) {
    let alert = UIAlertController(title: "오류", message: error.localizedDescription, preferredStyle: .alert)
    alert.addAction(.init(title: "확인", style: .default))
    present(alert, animated: true)
  }
}

