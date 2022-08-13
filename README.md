# swift-trader
A Swift package for connecting and trading on crypto exchanges such as Kucoin and FTX.

It can calculate the stop and limit prices for a trailing stop strategy based on the given input parameters.  
(See [SwiftTrader+TrailingStop.swift](https://github.com/backslash-f/swift-trader/blob/main/Sources/SwiftTrader/SwiftTrader%2BTrailingStop.swift))

Supports being deployed to Heroku (Linux).  
This means [trading automation](https://youtu.be/gMRee2srpe8) by using webhooks and scripts such as the [Profit Percentage Tracker](https://www.tradingview.com/script/p6NBsV48-Profit-Percentage-Tracker/) (TradingView). #ka-ching!

List of implemented APIs:

[Kucoin Futures](https://github.com/backslash-f/swift-trader/blob/main/Sources/SwiftTrader/SwiftTrader%2BKucoinFutures.swift) | Explanation | API Documentation
--- | --- | ---
`kucoinFuturesAccountOverview(currencySymbol:)` | Retrieves the overview of a Kucoin Futures account. | https://docs.kucoin.com/futures/#account
`SwiftTrader.kucoinFuturesStopOrderList(symbol:)` | Retrieves the list of un-triggered stop orders. | https://docs.kucoin.com/futures/#get-untriggered-stop-order-list
`kucoinFuturesOrderList(orderStatus:)` | Retrieves the list of active Futures orders. | https://docs.kucoin.com/futures/#get-order-list
`kucoinFuturesPlaceStopLimitOrder(_:)` | Places a Futures stop limit order. | https://docs.kucoin.com/futures/#place-an-order
`kucoinFuturesCancelStopOrders(symbol:)` | Cancels all untriggered Futures stop orders of a given symbol (contract). | https://docs.kucoin.com/futures/#stop-order-mass-cancelation
`kucoinFuturesPositionList()` | Lists open Futures positions. | https://docs.kucoin.com/futures/#get-position-list

[Kucoin Spot](https://github.com/backslash-f/swift-trader/blob/main/Sources/SwiftTrader/SwiftTrader%2BKucoinSpot.swift) | Explanation | API Documentation
--- | --- | ---
`kucoinSpotListAccounts(currencySymbol:)` | Gets the list of accounts. | https://docs.kucoin.com/#list-accounts
`kucoinSpotGetAccount(accountID:)` | Retrieves information for a single account. | https://docs.kucoin.com/#get-an-account
`kucoinSpotGetTransferable(currencySymbol:)` | Returns the transferable balance of a specified account. | https://docs.kucoin.com/#get-the-transferable
`kucoinSpotPlaceStopLimitOrder(_:)` | Places a spot stop limit order. | https://docs.kucoin.com/#place-a-new-order
`kucoinSpotOrderList()` | Lists active Spot orders. | https://docs.kucoin.com/#list-orders
`kucoinSpotStopOrderList()` | Lists active Spot **stop** orders. | https://docs.kucoin.com/#list-stop-orders
`kucoinSpotCancelStopOrders(symbol:)` | Cancels all untriggered stop orders of a given symbol (contract). | https://docs.kucoin.com/#cancel-orders

[FTX](https://github.com/backslash-f/swift-trader/blob/main/Sources/SwiftTrader/SwiftTrader%2BFTX.swift) | Explanation | API Documentation
--- | --- | ---
`ftxTriggerOrdersList(market:)` | Retrieves the list of open trigger orders. | https://docs.ftx.com/?python#get-open-trigger-orders
`ftxPositions()` | Lists open positions. | https://docs.ftx.com/#get-positions
`ftxPlaceStopLimitOrder(_:)` | Places a stop limit order within FTX. | https://docs.ftx.com/?python#place-trigger-order
`cancelAllOrders(cancelOrderParameters:)` | Cancels all open orders. | https://docs.ftx.com/?python#cancel-all-orders
