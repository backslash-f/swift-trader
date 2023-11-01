//
//  BinanceAPI+Header.swift
//  
//
//  Created by Fernando Fernandes on 04.12.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Holds logic to set values for default HTTP header fields common to all Binance APIs requests.
extension BinanceAPI {

    /// Sets values for default header fields in the given `URLRequest`
    ///
    /// Default header fields include `X-MBX-APIKEY`.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` where the header field values are to be set.
    ///   - binanceAuth: `BinanceAuth` that holds Binance authentication data.
    static func setRequestHeaderFields(request: inout URLRequest,
                                       binanceAuth: BinanceAuthorizing) throws {
        setAPIKey(request: &request, binanceAuth: binanceAuth)
    }
}

// MARK: - Private

private extension BinanceAPI {

    /// "X-MBX-APIKEY"
    static func setAPIKey(request: inout URLRequest,
                          binanceAuth: BinanceAuthorizing) {
        request.setValue(
            binanceAuth.apiKey,
            forHTTPHeaderField: BinanceAPI.HeaderField.apiKey
        )
    }
}
