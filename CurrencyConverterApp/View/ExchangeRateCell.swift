//
//  ExchangeRateCell.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import UIKit
import SnapKit

final class ExchangeRateCell: UITableViewCell {
  
  static let id = "ExchangeRateCell"
  
  private let currencyLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textColor = .label
    return label
  }()
  
  private let rateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.textAlignment = .right
    label.textColor = .label //.black
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    contentView.backgroundColor = .systemBackground
    [currencyLabel, rateLabel].forEach { contentView.addSubview($0) }
    
    currencyLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(16)
      $0.centerY.equalToSuperview()
    }
    
    rateLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(16)
      $0.centerY.equalToSuperview()
      $0.leading.greaterThanOrEqualTo(currencyLabel.snp.trailing).offset(16)
      $0.width.equalTo(120)
    }
  }
  
  public func configureCell(_ data: ExchangeRateData) {
    currencyLabel.text = data.currencyCode
    rateLabel.text = data.formattedRate
  }
}
