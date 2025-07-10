//
//  ViewController.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import UIKit

class ExchangeRateViewController: UIViewController {
  
  private let exchangeRateView = ExchangeRateView()
  var allData = [ExchangeRateData]()
  
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
  }
  
  private func setupDelegates() {
    exchangeRateView.tableView.delegate = self
    exchangeRateView.tableView.dataSource = self
  }
  
  private func fetchCurrencyData() {
    Task {
      do {
        let result = try await DataService().fetchCurrencyData()
        self.allData = result
        self.exchangeRateView.tableView.reloadData()
      } catch {
        self.showAlert(DataError.parsingFailed)
      }
    }
  }
  
  func showAlert(_ error: Error) {
    let alert = UIAlertController(title: "오류", message: error.localizedDescription, preferredStyle: .alert)
    alert.addAction(.init(title: "확인", style: .default))
    present(alert, animated: true)
  }
}

