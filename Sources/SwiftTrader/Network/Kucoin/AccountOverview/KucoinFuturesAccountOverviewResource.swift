//
//  KucoinFuturesAccountOverviewResource.swift
//  
//
//  Created by Fernando Fernandes on 29.01.22.
//

import Foundation

/// The **resource** for requesting an overview of a Kucoin Futures account.
///
/// https://docs.kucoin.com/futures/#account
public struct KucoinFuturesAccountOverviewResource: NetworkResource {
    
    // MARK: - Properties
    
    public var url: URL {
        get throws {
            let baseURLString = try KucoinAPI.Futures.baseURL()
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            urlComponents.path = KucoinAPI.Futures.Path.accountOverview
            let queryItems = [
                URLQueryItem(name: KucoinAPI.QueryParam.currency, value: currencySymbol.rawValue)
            ]
            urlComponents.queryItems = queryItems
            guard let url = urlComponents.url else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            return url
        }
    }
    
    // MARK: Private
    
    private let currencySymbol: CurrencySymbol
    
    // MARK: - Lifecycle
    
    /// Creates a new `KucoinFuturesAccountOverviewResource` instance.
    ///
    /// - Parameter currencySymbol: `CurrencySymbol`.
    init(currencySymbol: CurrencySymbol) {
        self.currencySymbol = currencySymbol
    }
}
