//
//  KucoinAccountOverviewResource.swift
//  
//
//  Created by Fernando Fernandes on 29.01.22.
//

import Foundation

/// The **resource** for requesting an overview of a Kucoin Futures account.
///
/// https://docs.kucoin.com/futures/#account
public struct KucoinAccountOverviewResource: APIResource {
    
    // MARK: - Properties
    
    public var url: URL {
        get throws {
            let baseURLString = KucoinAPI.URL.base
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            urlComponents.path = KucoinAPI.Path.accountOverview
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
    
    /// Creates a new `KucoinAccountOverviewResource` instance.
    ///
    /// - Parameter currencySymbol: `CurrencySymbol`, default is `USDT`.
    init(currencySymbol: CurrencySymbol = .USDT) {
        self.currencySymbol = currencySymbol
    }
}
