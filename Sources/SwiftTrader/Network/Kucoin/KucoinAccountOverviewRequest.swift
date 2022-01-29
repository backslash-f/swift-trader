//
//  KucoinAccountOverviewRequest.swift
//  
//
//  Created by Fernando Fernandes on 29.01.22.
//

import Foundation

/// A **request** for an overview of a Kucoin Futures account.
///
/// https://docs.kucoin.com/futures/#account
public struct KucoinAccountOverviewRequest: NetworkRequest {
    
    // MARK: - Properties
    
    public typealias DecodableModel = KucoinFuturesAccountOverviewResponse
    
    public var session: URLSession
    
    public var request: URLRequest {
        get throws {
            let accountOverviewResource = KucoinAccountOverviewResource(currencySymbol: currencySymbol)
            var urlRequest = URLRequest(url: try accountOverviewResource.url)
            urlRequest.httpMethod = HTTPMethod.GET.rawValue
            
#warning("TODO: header")
            //    request.setValue(key, forHTTPHeaderField: "KC-API-KEY")
            //    request.setValue(signature(secret: secret), forHTTPHeaderField: "KC-API-SIGN")
            //    request.setValue("\(timestampMilliseconds)", forHTTPHeaderField: "KC-API-TIMESTAMP")
            //    request.setValue(passphrase, forHTTPHeaderField: "KC-API-PASSPHRASE")
            
            return urlRequest
        }
    }
    
    // MARK: Private
    
    private let currencySymbol: CurrencySymbol
    
    private let kucoinAuth: KucoinAuth
    
    // MARK: - Lifecycle
    
    /// Creates a new `KucoinAccountOverviewRequest` instance.
    ///
    /// - Parameter session: `URLSession` instance, the default is `.shared`.
    public init(session: URLSession = .shared, currencySymbol: CurrencySymbol = .USDT, kucoinAuth: KucoinAuth) {
        self.session = session
        self.currencySymbol = currencySymbol
        self.kucoinAuth = kucoinAuth
    }
}

// MARK: - Network Request Protocol

public extension KucoinAccountOverviewRequest {
    
#warning("TODO: kucoin error")
    // case couldNotDecodeKucoinError(error: Error)
    // case statusCodeNotOK(statusCode: Int, error: String, kucoinError: String)
    func decode(_ data: Data) throws -> KucoinFuturesAccountOverviewResponse {
        try JSONDecoder().decode(KucoinFuturesAccountOverviewResponse.self, from: data)
    }
}
