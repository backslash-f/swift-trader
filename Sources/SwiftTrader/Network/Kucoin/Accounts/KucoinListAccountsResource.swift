//
//  KucoinListAccountsResource.swift
//  
//
//  Created by Fernando Fernandes on 16.07.22.
//

import Foundation

/// The **resource** for listing Kucoin accounts.
///
/// https://docs.kucoin.com/#list-accounts
public struct KucoinListAccountsResource: NetworkResource {
    
    // MARK: - Properties
    
    public var url: URL {
        get throws {
            let baseURLString = try KucoinAPI.Spot.baseURL()
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            urlComponents.path = KucoinAPI.Spot.Path.accounts()
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
    
    /// Creates a new `KucoinListAccountsResource` instance.
    ///
    /// - Parameter currencySymbol: `CurrencySymbol`.
    init(currencySymbol: CurrencySymbol) {
        self.currencySymbol = currencySymbol
    }
}
