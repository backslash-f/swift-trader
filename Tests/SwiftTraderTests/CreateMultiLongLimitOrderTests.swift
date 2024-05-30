//
//  CreateMultiLongLimitOrderTests.swift
//
//
//  Created by Fernando Fernandes on 26.05.24.
//

import Foundation

import XCTest
@testable import SwiftTrader

final class CreateMultiLongLimitOrderTests: XCTestCase {

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

    func test_createMultiLongLimitOrders() {
        for testCase in testCases {
            let result = swiftTrader.createMultipleLongLimitOrders(for: testCase.input)

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
                    testCase.expectedSizes[index],
                    "Order \(index + 1) size should be \(testCase.expectedSizes[index])"
                )
            }
        }
    }
}

// MARK: - Private

private extension CreateMultiLongLimitOrderTests {

    var merlInput: SwiftTraderMultiLongLimitOrderInput {
        .init(
            symbol: "MERL-USDT",
            initialPrice: "0.4692",
            initialPriceIncrement: 0.11,
            priceIncrement: 0.01,
            totalFunds: 50
        )
    }

    var pepeInput: SwiftTraderMultiLongLimitOrderInput {
        .init(
            symbol: "PEPE-USDT",
            initialPrice: "0.00000121",
            initialPriceIncrement: 0.12,
            priceIncrement: 0.02,
            totalFunds: 100
        )
    }

    var ethInput: SwiftTraderMultiLongLimitOrderInput {
        .init(
            symbol: "ETH-USDT",
            initialPrice: "208.04",
            initialPriceIncrement: 0.13,
            priceIncrement: 0.03,
            totalFunds: 150
        )
    }

    var oneAndSomethingInput: SwiftTraderMultiLongLimitOrderInput {
        .init(
            symbol: "ONEANDSOMETHING-USDT",
            initialPrice: "1.17",
            initialPriceIncrement: 0.14,
            priceIncrement: 0.04,
            totalFunds: 200
        )
    }

    var testCases: [TestCase] {
        [
            TestCase(
                input: merlInput,
                expectedPrices: [
                    "0.5208",
                    "0.5260",
                    "0.5313",
                    "0.5366",
                    "0.5420"
                ],
                expectedSizes: [
                    "19",
                    "19",
                    "18",
                    "18",
                    "18"
                ]
            ),

            TestCase(
                input: pepeInput,
                expectedPrices: [
                    "0.00000136",
                    "0.00000138",
                    "0.00000141",
                    "0.00000144",
                    "0.00000147"
                ],
                expectedSizes: [
                    "14705882",
                    "14492753",
                    "14184397",
                    "13888888",
                    "13605442"
                ]
            ),

            TestCase(
                input: ethInput,
                expectedPrices: [
                    "235.09",
                    "242.14",
                    "249.40",
                    "256.88",
                    "264.59"
                ],
                expectedSizes: [
                    "0.13",
                    "0.12",
                    "0.12",
                    "0.12",
                    "0.11"
                ]
            ),

            TestCase(
                input: oneAndSomethingInput,
                expectedPrices: [
                    "1.33",
                    "1.39",
                    "1.44",
                    "1.50",
                    "1.56"
                ],
                expectedSizes: [
                    "30",
                    "28",
                    "27",
                    "26",
                    "25"
                ]
            )
        ]
    }

    struct TestCase {
        let input: SwiftTraderMultiLongLimitOrderInput
        let expectedPrices: [String]
        let expectedSizes: [String]
    }
}
