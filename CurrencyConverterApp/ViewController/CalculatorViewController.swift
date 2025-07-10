//
//  CalculatorViewController.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import UIKit

class CalculatorViewController: UIViewController {
  
  var selected: ExchangeRateData
  private var calculatorView = CalculatorView()
  
  init(selected: ExchangeRateData) {
    self.selected = selected
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = calculatorView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupAction()
  }
  
  private func setupUI() {
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.title = "환율 계산기"
    calculatorView.configure(data: selected)
  }
  
  private func setupAction() {
    calculatorView.convertButtonTapped = { [weak self] input in
      self?.handleConversion(input)
    }
  }
  
  private func handleConversion(_ input: String) {
    guard !input.trimmingCharacters(in: .whitespaces).isEmpty else {
      self.showAlert("금액을 입력해주세요")
      return
    }
    
    guard let isNumber = Double(input) else {
      self.showAlert("올바른 숫자를 입력해주세요")
      return
    }
    
    let convertedNumber = (isNumber * self.selected.rate).formatted(format: "%.2f")
    self.calculatorView.resultLabel.text = "$\(isNumber.formatted(format: "%.2f")) → \(convertedNumber) \(self.selected.currencyCode)"
  }
  
  func showAlert(_ message: String) {
    let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
    alert.addAction(.init(title: "확인", style: .default))
    present(alert, animated: true)
  }
}

