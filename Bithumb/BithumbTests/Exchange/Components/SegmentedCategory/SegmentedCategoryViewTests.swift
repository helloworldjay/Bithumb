//
//  SegmentedCategoryViewTests.swift
//  BithumbTests
//
//  Created by Seungjin Baek on 2022/01/30.
//

import XCTest
@testable import Bithumb

import Nimble

class SegmentedCategoryViewTests: XCTestCase {

  var sut: SegmentedCategoryView!

  override func setUp() {
    self.sut = SegmentedCategoryView(items: ["원화", "BTC", "관심"], fontSize: 14)
  }

  func test_index를_이용해_Segment의_PaymentCurrency_타입을_확인() {
    //given
    let firstIndex = 0
    let secondIndex = 1

    //when
    let firstResult = SegmentedCategoryView.SegmentedViewIndex
      .findPaymentCurrency(with: firstIndex)
    let secondResult = SegmentedCategoryView.SegmentedViewIndex
      .findPaymentCurrency(with: secondIndex)

    //then
    expect(firstResult).to(equal(PaymentCurrency.krw))
    expect(secondResult).to(equal(PaymentCurrency.btc))
  }
}
