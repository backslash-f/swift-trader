//
//  FTXListTriggerOrdersResource.swift
//
//
//  Created by Fernando Fernandes on 09.03.22.
//

import Foundation

/// The **resource** for requesting the list of all open trigger orders of a given (contract) symbol.
///
/// https://docs.ftx.com/?python#get-open-trigger-orders
public struct FTXListTriggerOrdersResource: NetworkResource {
    
    // MARK: - Properties
    
    public var url: URL {
        get throws {
            let baseURLString = FTXAPI.BaseURL.production
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            urlComponents.path = FTXAPI.Path.conditionalOrders
            let queryItems = [
                URLQueryItem(name: FTXAPI.QueryParam.market, value: market)
            ]
            urlComponents.queryItems = queryItems
            guard let url = urlComponents.url else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            return url
        }
    }
    
    // MARK: Private
    
    private let market: String
    
    // MARK: - Lifecycle
    
    /// Creates a new `FTXListTriggerOrdersResource` instance.
    ///
    /// - Parameter market: `String`,  Restrict to cancelling orders only on this market.
    /// E.g.: "PAXG-PERP".
    init(market: String) {
        self.market = market
    }
}
