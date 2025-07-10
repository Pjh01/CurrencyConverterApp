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
  }
  
  private func setupUI() {
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.title = "환율 계산기"
    calculatorView.configure(data: selected)
  }
}

