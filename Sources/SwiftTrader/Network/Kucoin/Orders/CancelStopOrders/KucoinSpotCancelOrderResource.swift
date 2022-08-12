//
//  KucoinSpotCancelOrdersResource.swift
//  
//
//  Created by Fernando Fernandes on 12.08.22.
//

import Foundation

/// The **resource** for requesting the cancellation of all untriggered stop orders of a given (contract) symbol.
///
/// https://docs.kucoin.com/#cancel-orders
public struct KucoinSpotCancelOrdersResource: NetworkResource {

    // MARK: - Properties

    public var url: URL {
        get throws {
            let baseURLString = try KucoinAPI.Spot.baseURL()
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            urlComponents.path = KucoinAPI.Spot.Path.stopOrderCancel
            let queryItems = [
                URLQueryItem(name: KucoinAPI.QueryParam.symbol, value: symbol)
            ]
            urlComponents.queryItems = queryItems
            guard let url = urlComponents.url else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            return url
        }
    }

    // MARK: Private

    private let symbol: String

    // MARK: - Lifecycle

    /// Creates a new `KucoinSpotCancelOrdersResource` instance.
    ///
    /// - Parameter symbol: `String`,  represents the specific contract for which all the untriggered stop orders will be cancelled.
    /// E.g.: "BTC-USDT".
    init(symbol: String) {
        self.symbol = symbol
    }
}
