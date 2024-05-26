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

    var merlInput: SwiftTraderMultiLimitOrderInput {
        .init(
            symbol: "MERLUSDT",
            maxBid: "0.4692",
            initialPriceIncrement: 0.16,
            priceIncrement: 0.1,
            totalFunds: 50
        )
    }

    var pepeInput: SwiftTraderMultiLimitOrderInput {
        .init(
            symbol: "PEPEUSDT",
            maxBid: "0.00000121",
            initialPriceIncrement: 0.16,
            priceIncrement: 0.1,
            totalFunds: 50
        )
    }

    var ethInput: SwiftTraderMultiLimitOrderInput {
        .init(
            symbol: "ETHUSDT",
            maxBid: "208.04",
            initialPriceIncrement: 0.16,
            priceIncrement: 0.1,
            totalFunds: 50
        )
    }

    var oneAndSomethingInput: SwiftTraderMultiLimitOrderInput {
        .init(
            symbol: "ONESOMETHINGUSDT",
            maxBid: "1.17",
            initialPriceIncrement: 0.16,
            priceIncrement: 0.1,
            totalFunds: 50
        )
    }

    var testCases: [TestCase] {
        [
            TestCase(
                input: merlInput,
                expectedPrices: [
                    "0.5443",
                    "0.5987",
                    "0.6586",
                    "0.7244",
                    "0.7969"
                ],
                expectedSizes: [
                    "18",
                    "16",
                    "15",
                    "13",
                    "12"
                ]
            ),

            TestCase(
                input: pepeInput,
                expectedPrices: [
                    "0.00000140",
                    "0.00000154",
                    "0.00000170",
                    "0.00000187",
                    "0.00000206"
                ],
                expectedSizes: [
                    "7142857",
                    "6493506",
                    "5882352",
                    "5347593",
                    "4854368"
                ]
            ),

            TestCase(
                input: ethInput,
                expectedPrices: [
                    "241.33",
                    "265.46",
                    "292.00",
                    "321.21",
                    "353.33"
                ],
                expectedSizes: [
                    "0.04",
                    "0.04",
                    "0.03",
                    "0.03",
                    "0.03"
                ]
            ),

            TestCase(
                input: oneAndSomethingInput,
                expectedPrices: [
                    "1.36",
                    "1.49",
                    "1.64",
                    "1.81",
                    "1.99"
                ],
                expectedSizes: [
                    "7",
                    "6",
                    "6",
                    "5",
                    "5"
                ]
            )
        ]
    }

    struct TestCase {
        let input: SwiftTraderMultiLimitOrderInput
        let expectedPrices: [String]
        let expectedSizes: [String]
    }
}
