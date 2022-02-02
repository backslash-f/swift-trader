//
//  KucoinAPI+Signature.swift
//  
//
//  Created by Fernando Fernandes on 29.01.22.
//

import Crypto
import Foundation

/// Holds logic to sign requests against Kucoin APIs.
public extension KucoinAPI {
    
    /// Creates and returns the signature for the `KC-API-SIGN` header field.
    ///
    /// https://docs.kucoin.com/futures/#authentication
    /// - Parameters:
    ///   - method: `HTTPMethod`. E.g.: `GET`, `POST.`
    ///   - path: Endpoint path including query parameters, if any. E.g.: *"/api/v1/account-overview?currency=USDT"*
    ///   - secret: The API secret.
    /// - Returns: `Base64` encoded signature.
    static func createSignature(for method: HTTPMethod, path: String, secret: String) throws -> String {
        guard let secretData = secret.data(using: .utf8) else {
            throw KucoinAPIError.stringToDataFailed(string: secret)
        }
        let key = SymmetricKey(data: secretData)
        let timestamp = Date().timestampMilliseconds
        let stringToSign = "\(timestamp)" + HTTPMethod.GET.rawValue + path
        guard let stringToSignData = stringToSign.data(using: .utf8) else {
            throw KucoinAPIError.stringToDataFailed(string: stringToSign)
        }
        let signature = HMAC<SHA256>.authenticationCode(for: stringToSignData, using: key)
        let base64signature = Data(signature).base64EncodedString()
        return base64signature
    }
}
