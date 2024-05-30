//
//  SwiftTraderCreateMultipleOrderTests.swift
//
//
//  Created by Fernando Fernandes on 26.05.24.
//

import Foundation

import XCTest
@testable import SwiftTrader

final class SwiftTraderCreateMultipleOrderTests: XCTestCase {

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

    func test_createMultipleOrders() {
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

private extension SwiftTraderCreateMultipleOrderTests {

    var merlInput: SwiftTraderMultiLongLimitOrderInput {
        .init(
            symbol: "MERLUSDT",
            initialPrice: "0.4692",
            initialPriceIncrement: 0.11,
            priceIncrement: 0.01,
            totalFunds: 50
        )
    }

    var pepeInput: SwiftTraderMultiLongLimitOrderInput {
        .init(
            symbol: "PEPEUSDT",
            initialPrice: "0.00000121",
            initialPriceIncrement: 0.12,
            priceIncrement: 0.2,
            totalFunds: 100
        )
    }

    var ethInput: SwiftTraderMultiLongLimitOrderInput {
        .init(
            symbol: "ETHUSDT",
            initialPrice: "208.04",
            initialPriceIncrement: 0.13,
            priceIncrement: 0.3,
            totalFunds: 150
        )
    }

    var oneAndSomethingInput: SwiftTraderMultiLongLimitOrderInput {
        .init(
            symbol: "ONEANDSOMETHINGUSDT",
            initialPrice: "1.17",
            initialPriceIncrement: 0.14,
            priceIncrement: 0.4,
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
                    "0.00000163",
                    "0.00000195",
                    "0.00000234",
                    "0.00000281"
                ],
                expectedSizes: [
                    "14705882",
                    "12269938",
                    "10256410",
                    "8547008",
                    "7117437"
                ]
            ),

            TestCase(
                input: ethInput,
                expectedPrices: [
                    "235.09",
                    "305.61",
                    "397.29",
                    "516.48",
                    "671.43"
                ],
                expectedSizes: [
                    "0.13",
                    "0.10",
                    "0.08",
                    "0.06",
                    "0.04"
                ]
            ),

            TestCase(
                input: oneAndSomethingInput,
                expectedPrices: [
                    "1.33",
                    "1.87",
                    "2.61",
                    "3.66",
                    "5.12"
                ],
                expectedSizes: [
                    "30",
                    "21",
                    "15",
                    "10",
                    "7"
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
