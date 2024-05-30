//
//  CreateMultiShortLimitOrderTests.swift
//
//
//  Created by Fernando Fernandes on 26.05.24.
//

import Foundation

import XCTest
@testable import SwiftTrader

final class CreateMultiShortLimitOrderTests: XCTestCase {

    var swiftTrader: SwiftTrader!

    override func setUp() {
        super.setUp()

        let kucoinSpot = KucoinAuth.Spot(
            apiKey: "apiKeyDummy",
            apiSecret: "apiSecretDummy",
            apiPassphrase: "apiPassphraseDummy"
        )

        let kucoinAuth = KucoinAuth(spot: kucoinSpot, futures: kucoinSpot)

        swiftTrader = SwiftTrader(binanceAuth: nil, kucoinAuth: kucoinAuth)
    }

    override func tearDown() {
        swiftTrader = nil
        super.tearDown()
    }

    func test_createMultiShortLimitOrders() {
        for testCase in testCases {
            let result = swiftTrader.createMultipleShortLimitOrders(for: testCase.input)

            // MARK: Order count

            let expectedOrderCount = 5
            let actualOrderCount = result.count

            XCTAssertEqual(
                expectedOrderCount,
                actualOrderCount,
                "The number of orders should be \(expectedOrderCount), not \(actualOrderCount)"
            )

            // MARK: Order prices

            for (index, order) in result.enumerated() {
                XCTAssertEqual(
                    order.price,
                    testCase.expectedPrices[index],
                    "Order \(index + 1) price should be \(testCase.expectedPrices[index])"
                )
            }

            // MARK: Order sizes

            for (index, order) in result.enumerated() {
                XCTAssertEqual(
                    order.size,
                    testCase.expectedSize,
                    "Order \(index + 1) size should be \(testCase.expectedSize)"
                )
            }
        }
    }
}

// MARK: - Private

private extension CreateMultiShortLimitOrderTests {

    var merlInput: SwiftTraderMultiShortLimitOrderInput {
        .init(
            symbol: "MERL-USDT",
            initialPrice: "0.4692",
            targetProfitPercentage: 0.51,
            priceDecrement: 0.01,
            totalSize: 92
        )
    }

    var pepeInput: SwiftTraderMultiShortLimitOrderInput {
        .init(
            symbol: "PEPE-USDT",
            initialPrice: "0.00000121",
            targetProfitPercentage: 0.52,
            priceDecrement: 0.01,
            totalSize: 70485494
        )
    }

    var ethInput: SwiftTraderMultiShortLimitOrderInput {
        .init(
            symbol: "ETH-USDT",
            initialPrice: "208.04",
            targetProfitPercentage: 0.53,
            priceDecrement: 0.01,
            totalSize: 0.6
        )
    }

    var oneAndSomethingInput: SwiftTraderMultiShortLimitOrderInput {
        .init(
            symbol: "ONEANDSOMETHING-USDT",
            initialPrice: "1.17",
            targetProfitPercentage: 0.54,
            priceDecrement: 0.01,
            totalSize: 136.0
        )
    }

    var testCases: [TestCase] {
        [
            TestCase(
                input: merlInput,
                expectedPrices: [
                    "0.7085",
                    "0.7014",
                    "0.6944",
                    "0.6874",
                    "0.6806"
                ],
                expectedSize: "92"
            ),

            TestCase(
                input: pepeInput,
                expectedPrices: [
                    "0.00000184",
                    "0.00000182",
                    "0.00000180",
                    "0.00000178",
                    "0.00000177"
                ],
                expectedSize: "70485494"
            ),

            TestCase(
                input: ethInput,
                expectedPrices: [
                    "318.30",
                    "315.12",
                    "311.97",
                    "308.85",
                    "305.76"
                ],
                expectedSize: "0.60"
            ),

            TestCase(
                input: oneAndSomethingInput,
                expectedPrices: [
                    "1.80",
                    "1.78",
                    "1.77",
                    "1.75",
                    "1.73"
                ],
                expectedSize: "136"
            )
        ]
    }

    struct TestCase {
        let input: SwiftTraderMultiShortLimitOrderInput
        let expectedPrices: [String]
        let expectedSize: String
    }
}
