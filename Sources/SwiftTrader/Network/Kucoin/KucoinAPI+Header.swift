//
//  KucoinAPI+Header.swift
//  
//
//  Created by Fernando Fernandes on 30.01.22.
//

import Foundation

/// Holds logic to set values for default HTTP header fields common to all Kucoin APIs requests.
extension KucoinAPI {
    
    /// Sets values for default header fields in the given `URLRequest`
    ///
    /// Default header fields include `KC-API-KEY`, `KC-API-SIGN`, `KC-API-TIMESTAMP`, `KC-API-PASSPHRASE`, etc
    ///
    /// - Parameters:
    ///   - request: `URLRequest` where the header field values are to be set.
    ///   - kucoinAuth: `KucoinAuth` that holds Kucoin authentication data.
    static func setRequestHeaderFields(request: inout URLRequest, kucoinAuth: KucoinAuth) throws {
        setAPIKey(request: &request, kucoinAuth: kucoinAuth)
        setAPIPassphrase(request: &request, kucoinAuth: kucoinAuth)
        try setAPISignature(request: &request, kucoinAuth: kucoinAuth)
        setAPITimestamp(request: &request, kucoinAuth: kucoinAuth)
    }
}

// MARK: - Private

private extension KucoinAPI {
    
    /// "KC-API-KEY"
    static func setAPIKey(request: inout URLRequest, kucoinAuth: KucoinAuth) {
        request.setValue(kucoinAuth.apiKey, forHTTPHeaderField: KucoinAPI.HeaderField.apiKey)
    }
    
    /// "KC-API-PASSPHRASE"
    static func setAPIPassphrase(request: inout URLRequest, kucoinAuth: KucoinAuth) {
        request.setValue(kucoinAuth.apiPassphrase, forHTTPHeaderField: KucoinAPI.HeaderField.apiPassphrase)
    }
    
    /// "KC-API-SIGN"
    static func setAPISignature(request: inout URLRequest, kucoinAuth: KucoinAuth) throws {
        guard let httpMethodString = request.httpMethod else {
            throw KucoinAPIError.missingHTTPMethod
        }
        guard let httpMethod = HTTPMethod(rawValue: httpMethodString) else {
            throw KucoinAPIError.unsupportedHTTPMethod
        }
        guard let url = request.url else {
            throw KucoinAPIError.missingURL(url: request.url)
        }
        guard !url.path.isEmpty else {
            throw KucoinAPIError.missingPath(url: url)
        }
        let finalPath: String
        if let query = url.query, !query.isEmpty {
            finalPath = "\(url.path)?\(query)"
        } else {
            finalPath = url.path
        }
        let signature = try createSignature(for: httpMethod, path: finalPath, secret: kucoinAuth.apiSecret)
        request.setValue(signature, forHTTPHeaderField: KucoinAPI.HeaderField.apiSign)
    }
    
    /// "KC-API-TIMESTAMP"
    static func setAPITimestamp(request: inout URLRequest, kucoinAuth: KucoinAuth) {
        request.setValue("\(Date().timestampMilliseconds)", forHTTPHeaderField: KucoinAPI.HeaderField.apiTimestamp)
    }
}
