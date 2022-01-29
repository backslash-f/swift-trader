//
//  File.swift
//  
//
//  Created by Fernando Fernandes on 29.01.22.
//

import Foundation

#if canImport(CryptoKit)
import CryptoKit
#elseif canImport(Vapor)
// [Server-side Support] Vapor includes SwiftCrypto, which is a Linux-compatible port of Apple's CryptoKit library.
// https://docs.vapor.codes/4.0/crypto/
import Vapor
#endif

/// Encapsulates errors that can happen while generating the signature that Kucoin APIs require.
public enum KucoinSignatureError: Error {
    case unableToExtractDataFromString(string: String)
}

public extension KucoinAPI {
    
#warning("TODO: I need this from urlrequest - /api/v1/account-overview?currency=USDT")
    
    /// Creates and returns the signature for the `KC-API-SIGN` header field.
    ///
    /// https://docs.kucoin.com/futures/#authentication
    /// - Parameters:
    ///   - method: `HTTPMethod`. E.g.: `GET`, `POST.`
    ///   - path: Endpoint path including query parameters. E.g.: *"/api/v1/account-overview?currency=USDT"*
    ///   - secret: The API secret.
    /// - Returns: `Base64` encoded signature.
    static func createSignature(for method: HTTPMethod, path: String, secret: String) throws -> String {
        guard let secretData = secret.data(using: .utf8) else {
            throw KucoinSignatureError.unableToExtractDataFromString(string: secret)
        }
        let key = SymmetricKey(data: secretData)
        let timestamp = Date().timestampMilliseconds
        let stringToSign = "\(timestamp)" + HTTPMethod.GET.rawValue + path
        guard let stringToSignData = stringToSign.data(using: .utf8) else {
            throw KucoinSignatureError.unableToExtractDataFromString(string: stringToSign)
        }
        let signature = HMAC<SHA256>.authenticationCode(for: stringToSignData, using: key)
        let base64signature = Data(signature).base64EncodedString()
        return base64signature
    }
}
