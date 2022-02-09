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
    /// From Kucoin documentation *"Use API-Secret to encrypt the prehash string
    /// {timestamp+method+endpoint+body} with sha256 HMAC. The request body
    /// is a JSON string and need to be the same with the parameters passed by the API.
    /// After that, use base64-encode to encrypt the result..."*
    ///
    /// https://docs.kucoin.com/futures/#authentication
    /// - Parameters:
    ///   - method: `HTTPMethod`. E.g.: `GET`, `POST.`
    ///   - path: Endpoint path including query parameters, if any. E.g.: *"/api/v1/account-overview?currency=USDT"*
    ///   - body: The request body as a `JSON` `String`. For `GET`, `DELETE` requests, the body is "".
    ///   - secret: The API secret.
    /// - Returns: `Base64` encoded signature.
    static func createSignature(for method: HTTPMethod, path: String, body: String, secret: String) throws -> String {
        guard let secretData = secret.data(using: .utf8) else {
            throw KucoinAPIError.stringToDataFailed(string: secret)
        }
        let key = SymmetricKey(data: secretData)
        let timestamp = Date().timestampMilliseconds
        let stringToSign = "\(timestamp)" + method.rawValue + path + body
        guard let stringToSignData = stringToSign.data(using: .utf8) else {
            throw KucoinAPIError.stringToDataFailed(string: stringToSign)
        }
        let signature = HMAC<SHA256>.authenticationCode(for: stringToSignData, using: key)
        let base64signature = Data(signature).base64EncodedString()
        return base64signature
    }
}
