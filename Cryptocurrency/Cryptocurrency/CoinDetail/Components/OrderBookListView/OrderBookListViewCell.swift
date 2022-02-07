//
//  OrderBookListViewCell.swift
//  Bithumb
//
//  Created by 이영우 on 2022/02/07.
//

import Foundation

import SnapKit
import Then

final class OrderBookListViewCell: UITableViewCell {

  // MARK: Properties

  private let bidQuantitylabel: PaddingLabel
  private let askQuantityLabel: PaddingLabel
  private let priceLabel: PaddingLabel
  private let priceChangedRatioLabel: PaddingLabel
  private let priceStackView: UIStackView


  // MARK: Initializer

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    let padding = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    self.priceChangedRatioLabel = PaddingLabel(padding: padding)
    self.bidQuantitylabel = PaddingLabel(padding: padding)
    self.askQuantityLabel = PaddingLabel(padding: padding)
    self.priceLabel = PaddingLabel(padding: padding)
    self.priceStackView = UIStackView()

    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.attribute()
    self.layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func attribute() {
    self.askQuantityLabel.do {
      $0.textAlignment = .left
      $0.textColor = .black
      $0.font = .systemFont(ofSize: 12)
    }

    [self.bidQuantitylabel, self.priceLabel, self.priceChangedRatioLabel].forEach {
      $0.textAlignment = .right
      $0.textColor = .black
      $0.font = .systemFont(ofSize: 12)
    }
  }

  private func layout() {
    [self.bidQuantitylabel, self.askQuantityLabel, self.priceStackView].forEach {
      self.contentView.addSubview($0)
    }

    [self.priceLabel, self.priceChangedRatioLabel].forEach {
      self.priceStackView.addArrangedSubview($0)
    }

    self.bidQuantitylabel.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.top.bottom.equalToSuperview().inset(2)
      $0.width.equalToSuperview().multipliedBy(0.3)
    }

    self.askQuantityLabel.snp.makeConstraints {
      $0.leading.equalTo(self.priceStackView.snp.trailing).offset(2)
      $0.trailing.equalToSuperview()
      $0.top.bottom.equalToSuperview().inset(2)
      $0.width.equalToSuperview().multipliedBy(0.3)
    }

    self.priceStackView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(2)
      $0.leading.equalTo(self.bidQuantitylabel.snp.trailing).offset(2)
    }

    self.priceChangedRatioLabel.setContentHuggingPriority(.required, for: .horizontal)
    self.priceChangedRatioLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    self.priceChangedRatioLabel.attributedText = nil
    self.priceLabel.attributedText = nil
    self.askQuantityLabel.text = nil
    self.bidQuantitylabel.text = nil
    self.askQuantityLabel.backgroundColor = nil
    self.bidQuantitylabel.backgroundColor = nil
    self.priceStackView.backgroundColor = nil
  }

  func setData(with data: OrderBookListViewCellData) {
    if data.orderBook == .ask {
      self.askQuantityLabel.text = data.orderQuantityText()
      self.askQuantityLabel.backgroundColor = .ask
      self.priceStackView.backgroundColor = .ask
    } else {
      self.bidQuantitylabel.text = data.orderQuantityText()
      self.bidQuantitylabel.backgroundColor = .bid
      self.priceStackView.backgroundColor = .bid
    }
    
    if data.priceChangedRatio > .zero {
      self.priceChangedRatioLabel.attributedText = data.priceChangedRatioText()
      self.priceLabel.attributedText = data.orderPriceText()
    } else {
      self.priceChangedRatioLabel.attributedText = data.priceChangedRatioText()
      self.priceLabel.attributedText = data.orderPriceText()
    }
  }
}