//
//  CalculatorView.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import UIKit
import SnapKit

// 환율 계산기 화면의 View
class CalculatorView: UIView {
  
  var convertButtonTapped: ((String) -> Void)?
  
  // 통화 코드
  private let currencyLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24, weight: .bold)
    label.textColor = .label
    return label
  }()
  
  // 국가 이름
  private let countryLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.textColor = .secondaryLabel
    return label
  }()
  
  // 통화/국가 라벨을 담을 수직 스택
  private let labelStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 4
    stackView.alignment = .center
    return stackView
  }()
  
  // 사용자 입력 필드
  private let amountTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.keyboardType = .decimalPad
    textField.textAlignment = .center
    textField.placeholder = "달러(USD)를 입력하세요"
    return textField
  }()
  
  // 환율 계산 버튼
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
  
  // 결과를 표시할 라벨
  let resultLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 20, weight: .medium)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.textColor = .label
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
  
  // UI 컴포넌트 설정 및 제약조건
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
  
  // 외부에서 View에 데이터 세팅
  func configure(data: ExchangeRateData) {
    currencyLabel.text = data.currencyCode
    countryLabel.text = data.country
  }
  
  // 환율 계산 버튼 클릭 시 호출
  @objc private func handleConvertButtonTap() {
    endEditing(true) // 키보드 닫기
    let input = amountTextField.text ?? ""
    convertButtonTapped?(input)
  }
}

