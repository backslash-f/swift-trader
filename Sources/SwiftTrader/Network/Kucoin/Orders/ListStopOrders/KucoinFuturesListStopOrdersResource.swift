//
//  KucoinFuturesListStopOrdersResource.swift
//
//
//  Created by Fernando Fernandes on 02.03.22.
//

import Foundation

/// The **resource** for requesting the list of all untriggered stop orders of a given (contract) symbol.
///
/// https://docs.kucoin.com/futures/#get-untriggered-stop-order-list
public struct KucoinFuturesListStopOrdersResource: NetworkResource {
    
    // MARK: - Properties
    
    public var url: URL {
        get throws {
            let baseURLString = try KucoinAPI.Futures.baseURL()
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
    
    /// Creates a new `KucoinFuturesListStopOrdersResource` instance.
    ///
    /// - Parameter symbol: `String`,  represents the specific contract for which all the untriggered stop orders will be listed.
    /// E.g.: "XBTUSDM".
    init(symbol: String) {
        self.symbol = symbol
    }
}
