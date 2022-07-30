//
//  KucoinGetAccountResource.swift
//
//
//  Created by Fernando Fernandes on 16.07.22.
//

import Foundation

/// The **resource** for getting a Kucoin account.
///
/// https://docs.kucoin.com/#get-an-account
public struct KucoinGetAccountResource: NetworkResource {
    
    // MARK: - Properties
    
    public var url: URL {
        get throws {
            let baseURLString = try KucoinAPI.Spot.baseURL()
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            urlComponents.path = KucoinAPI.Spot.Path.accounts(pathComponent: accountID)
            guard let url = urlComponents.url else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            return url
        }
    }
    
    // MARK: Private
    
    private let accountID: String
    
    // MARK: - Lifecycle
    
    /// Creates a new `KucoinGetAccountResource` instance.
    ///
    /// - Parameter accountID: `String`.
    init(accountID: String) {
        self.accountID = accountID
    }
}
