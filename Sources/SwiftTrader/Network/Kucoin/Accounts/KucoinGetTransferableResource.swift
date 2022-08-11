//
//  KucoinGetTransferableResource.swift
//  
//
//  Created by Fernando Fernandes on 11.08.22.
//

import Foundation

/// The **resource** for getting the transferable balance of a specified account.
///
/// https://docs.kucoin.com/#get-the-transferable
public struct KucoinGetTransferableResource: NetworkResource {

    // MARK: - Properties

    public var url: URL {
        get throws {
            let baseURLString = try KucoinAPI.Spot.baseURL()
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            urlComponents.path = KucoinAPI.Spot.Path.transferable
            let queryItems = [
                URLQueryItem(name: KucoinAPI.QueryParam.currency, value: currencySymbol.rawValue),
                URLQueryItem(name: KucoinAPI.QueryParam.type, value: accountType.rawValue.uppercased())
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
    private let accountType: KucoinAccountType

    // MARK: - Lifecycle

    /// Creates a new `KucoinGetTransferableResource` instance.
    ///
    /// - Parameters:
    ///   - currencySymbol: `CurrencySymbol`.
    ///   - accountType: `KucoinAccountType`.
    init(currencySymbol: CurrencySymbol, accountType: KucoinAccountType) {
        self.currencySymbol = currencySymbol
        self.accountType = accountType
    }
}
