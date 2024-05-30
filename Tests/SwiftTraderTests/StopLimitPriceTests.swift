import XCTest
@testable import SwiftTrader

final class StopLimitPriceTests: XCTestCase {

    var swiftTrader: SwiftTrader!

    override func setUp() {
        super.setUp()
        let binanceSpot = BinanceAuth.Spot(apiKey: "dummy", apiSecret: "dummy")
        let binanceAuth = BinanceAuth(spot: binanceSpot)
        swiftTrader = SwiftTrader(binanceAuth: binanceAuth, kucoinAuth: nil)
    }

    override func tearDown() {
        swiftTrader = nil
        super.tearDown()
    }

    func testCalculateStopLimitPriceWithInvalidOffset() {
        let input = pepeInputInvalidOffset
        XCTAssertThrowsError(try swiftTrader.calculateStopLimitPrice(for: input)) { error in
            XCTAssertEqual(
                error as? SwiftTraderError,
                SwiftTraderError.invalidOffset(
                    offset: input.offset,
                    profitPercentage: input.profitPercentage
                )
            )
        }
    }

    func test_calculateStopLimitPriceForLongPositionBTC() {
        let input = btcInput(isLong: true)
        do {
            let result = try swiftTrader.calculateStopLimitPrice(for: input)
            XCTAssertEqual(result.stop.double, 40410, accuracy: 0.01)
            XCTAssertEqual(result.limit.double, 40400, accuracy: 0.01)
        } catch {
            XCTFail("Expected successful stop limit price calculation, got error: \(error)")
        }
    }

    func test_calculateStopLimitPriceForShortPositionBTC() {
        let input = btcInput(isLong: false)
        do {
            let result = try swiftTrader.calculateStopLimitPrice(for: input)
            XCTAssertEqual(result.stop.double, 39590, accuracy: 0.01)
            XCTAssertEqual(result.limit.double, 39600, accuracy: 0.01)
        } catch {
            XCTFail("Expected successful stop limit price calculation, got error: \(error)")
        }
    }

    func test_calculateStopLimitPriceForLongPositionSAND() {
        let input = sandInput(isLong: true)
        do {
            let result = try swiftTrader.calculateStopLimitPrice(for: input)
            XCTAssertEqual(result.stop.double, 0.36061, accuracy: 0.01)
            XCTAssertEqual(result.limit.double, 0.36051, accuracy: 0.01)
        } catch {
            XCTFail("Expected successful stop limit price calculation, got error: \(error)")
        }
    }

    func test_calculateStopLimitPriceForShortPositionSAND() {
        let input = sandInput(isLong: false)
        do {
            let result = try swiftTrader.calculateStopLimitPrice(for: input)
            XCTAssertEqual(result.stop.double, 0.33941, accuracy: 0.01)
            XCTAssertEqual(result.limit.double, 0.33951, accuracy: 0.01)
        } catch {
            XCTFail("Expected successful stop limit price calculation, got error: \(error)")
        }
    }
}

// MARK: - Private

private extension StopLimitPriceTests {
    var pepeInputInvalidOffset: SwiftTraderStopLimitOrderInput {
        .init(
            cancelStopOrders: true,
            contractSymbol: "PEPE",
            entryPrice: 0.00001,
            exchange: .binance,
            isLong: true,
            offset: 10,
            profitPercentage: 1,
            size: 1000,
            ticker: "PEPEUSDT",
            tickerSize: "0.0000000001"
        )
    }

    func btcInput(isLong: Bool) -> SwiftTraderStopLimitOrderInput {
        .init(
            cancelStopOrders: true,
            contractSymbol: "BTC",
            entryPrice: 40000,
            exchange: .binance,
            isLong: isLong,
            offset: 1,
            profitPercentage: 2,
            size: 1,
            ticker: "BTCUSDT",
            tickerSize: "1"
        )
    }

    func sandInput(isLong: Bool) -> SwiftTraderStopLimitOrderInput {
        .init(
            cancelStopOrders: true,
            contractSymbol: "SAND",
            entryPrice: 0.35,
            exchange: .binance,
            isLong: isLong,
            offset: 5, // 3%
            profitPercentage: 8,
            size: 5714, // 1999,9
            ticker: "SANDUSDT",
            tickerSize: "0.00001"
        )
    }
}
