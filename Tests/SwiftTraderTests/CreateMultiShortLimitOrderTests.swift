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

            // MARK: Unique prices

            let prices = result.map { $0.price }
            let uniquePrices = Set(prices)

            XCTAssertEqual(
                prices.count,
                uniquePrices.count,
                "There should be no duplicate prices in the orders: \(uniquePrices)"
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

            let totalExpectedSize = testCase.expectedSizes.compactMap { Double($0) }.reduce(0, +)
            let totalSize = testCase.input.totalSize

            XCTAssertTrue(
                totalExpectedSize <= totalSize,
                """
                    The expected size should be less then/equal to the total size \(totalSize)
                    -- and not \(totalExpectedSize)
                """
            )
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

    var cheapInput: SwiftTraderMultiShortLimitOrderInput {
        .init(
            symbol: "CHEAP-USDT",
            initialPrice: "0.046",
            targetProfitPercentage: 0.66,
            priceDecrement: 0.01,
            totalSize: 4333
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
                expectedSizes: [
                    "18",
                    "18",
                    "18",
                    "18",
                    "18"
                ]
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
                expectedSizes: [
                    "14097098",
                    "14097098",
                    "14097098",
                    "14097098",
                    "14097098"
                ]
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
                expectedSizes: [
                    "0.12",
                    "0.12",
                    "0.12",
                    "0.12",
                    "0.12"
                ]
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
                expectedSizes: [
                    "27",
                    "27",
                    "27",
                    "27",
                    "27"
                ]
            ),

            TestCase(
                input: cheapInput,
                expectedPrices: [
                    "0.076",
                    "0.075",
                    "0.074",
                    "0.073",
                    "0.072"
                ],
                expectedSizes: [
                    "866",
                    "866",
                    "866",
                    "866",
                    "866"
                ]
            )
        ]
    }

    struct TestCase {
        let input: SwiftTraderMultiShortLimitOrderInput
        let expectedPrices: [String]
        let expectedSizes: [String]
    }
}
