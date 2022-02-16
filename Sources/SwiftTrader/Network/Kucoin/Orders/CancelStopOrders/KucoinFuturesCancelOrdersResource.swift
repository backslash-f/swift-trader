//
//  KucoinFuturesCancelOrdersResource.swift
//
//
//  Created by Fernando Fernandes on 16.02.22.
//

import Foundation

/// The **resource** for requesting the cancellation of all untriggered stop orders of a given symbol (contract).
///
/// https://docs.kucoin.com/futures/#stop-order-mass-cancelation
public struct KucoinFuturesCancelOrdersResource: NetworkResource {
    
    // MARK: - Properties
    
    public var url: URL {
        get throws {
            let baseURLString = KucoinAPI.Futures.baseURL()
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            urlComponents.path = KucoinAPI.Futures.Path.stopOrders
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
    
    /// Creates a new `KucoinFuturesCancelOrdersResource` instance.
    ///
    /// - Parameter symbol: `String`,  represents the specific contract for which all the untriggered stop orders will be cancelled.
    /// E.g.: "XBTUSDM".
    init(symbol: String) {
        self.symbol = symbol
    }
}
