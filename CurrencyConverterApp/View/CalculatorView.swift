//
//  CalculatorView.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import UIKit
import SnapKit

class CalculatorView: UIView {
  
  private let currencyLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24, weight: .bold)
    label.textColor = .label
    return label
  }()
  
  private let countryLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.textColor = .secondaryLabel
    return label
  }()
  
  private let labelStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 4
    stackView.alignment = .center
    return stackView
  }()
  
  private let amountTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.keyboardType = .decimalPad
    textField.textAlignment = .center
    textField.placeholder = "달러(USD)를 입력하세요"
    return textField
  }()
  
  private lazy var convertButton: UIButton = {
    let button = UIButton()
    button.setTitle("환율 계산", for: .normal)
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    button.layer.cornerRadius = 8
    button.addTarget(self, action: #selector(handleConvertButtonTap), for: .touchUpInside)
    return button
  }()
  
  let resultLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 20, weight: .medium)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.text = "계산 결과가 여기에 표시됩니다"
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    [currencyLabel, countryLabel].forEach { labelStackView.addArrangedSubview($0) }
    [labelStackView, amountTextField, convertButton, resultLabel].forEach { addSubview($0) }
    
    labelStackView.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide).inset(32)
      $0.centerX.equalToSuperview()
    }
    
    amountTextField.snp.makeConstraints {
      $0.top.equalTo(labelStackView.snp.bottom).offset(32)
      $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(24)
      $0.height.equalTo(44)
    }
    
    convertButton.snp.makeConstraints {
      $0.top.equalTo(amountTextField.snp.bottom).offset(24)
      $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(24)
      $0.height.equalTo(44)
    }
    
    resultLabel.snp.makeConstraints {
      $0.top.equalTo(convertButton.snp.bottom).offset(32)
      $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(24)
    }
  }
  
  func configure(data: ExchangeRateData) {
    currencyLabel.text = data.currencyCode
    countryLabel.text = data.country
  }
  
  @objc private func handleConvertButtonTap() {
    
  }
}

