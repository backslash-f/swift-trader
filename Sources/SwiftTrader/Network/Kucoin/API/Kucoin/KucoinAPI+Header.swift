//
//  KucoinAPI+Header.swift
//  
//
//  Created by Fernando Fernandes on 30.01.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Holds logic to set values for default HTTP header fields common to all Kucoin APIs requests.
extension KucoinAPI {
    
    /// Sets values for default header fields in the given `URLRequest`
    ///
    /// Default header fields include `KC-API-KEY`, `KC-API-SIGN`, `KC-API-TIMESTAMP`, `KC-API-PASSPHRASE`, etc
    ///
    /// - Parameters:
    ///   - request: `URLRequest` where the header field values are to be set.
    ///   - kucoinAuth: `KucoinAuth` that holds Kucoin authentication data.
    static func setRequestHeaderFields(request: inout URLRequest,
                                       kucoinAuth: KucoinAuthorizing) throws {
        setAPIKey(request: &request, kucoinAuth: kucoinAuth)
        setAPIPassphrase(request: &request, kucoinAuth: kucoinAuth)
        try setAPISignature(request: &request, kucoinAuth: kucoinAuth)
        setAPITimestamp(request: &request)
    }
}

// MARK: - Private

private extension KucoinAPI {
    
    /// "KC-API-KEY"
    static func setAPIKey(request: inout URLRequest,
                          kucoinAuth: KucoinAuthorizing) {
        request.setValue(
            kucoinAuth.apiKey,
            forHTTPHeaderField: KucoinAPI.HeaderField.apiKey
        )
    }
    
    /// "KC-API-PASSPHRASE"
    static func setAPIPassphrase(request: inout URLRequest,
                                 kucoinAuth: KucoinAuthorizing) {
        request.setValue(
            kucoinAuth.apiPassphrase,
            forHTTPHeaderField: KucoinAPI.HeaderField.apiPassphrase
        )
    }
    
    /// "KC-API-SIGN"
    static func setAPISignature(request: inout URLRequest,
                                kucoinAuth: KucoinAuthorizing) throws {
        try NetworkRequestSignee.createHMACSignature(
            for: &request,
            secret: kucoinAuth.apiSecret,
            httpHeaderField: KucoinAPI.HeaderField.apiSign
        )
    }
    
    /// "KC-API-TIMESTAMP"
    static func setAPITimestamp(request: inout URLRequest) {
        request.setValue(
            "\(Date().timestampMilliseconds)",
            forHTTPHeaderField: KucoinAPI.HeaderField.apiTimestamp
        )
    }
}
