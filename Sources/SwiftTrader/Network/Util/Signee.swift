//
//  NetworkRequestSignee.swift
//  
//
//  Created by Fernando Fernandes on 08.03.22.
//

import Crypto
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Holds generic algorithms to sign network requests (e.g.: `SHA256 HMAC`).
public struct NetworkRequestSignee {
    
    /// Creates a `SHA256 HMAC` signature and add it into the given header field.
    ///
    /// Using the given `secret`, the created signature covers the following strings:
    /// - Request timestamp (e.g. 1528394229375)
    /// - HTTP method in uppercase (e.g. GET or POST)
    /// - Request path, including leading slash and any URL parameters but not including the hostname (e.g. /account)
    /// - (POST only) Request body (JSON-encoded)
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` to be signed.
    ///   - secret: The API secret required to sign the request.
    ///   - isHexString: if `true`, then the generated String signature will be encoded using `Data.hexStringEncoded()`.
    ///   If `false` (the default), then `Data.base64EncodedString()` will be used instead.
    ///   - httpHeaderField: The name of the HTTP header field where the generated signature is to be added.
    static func createHMACSignature(for request: inout URLRequest,
                                    secret: String,
                                    isHexString: Bool = false,
                                    httpHeaderField: String) throws {
        let httpMethod = try extractHTTPMethod(from: request)
        let path = try extractPath(from: request)
        let body = try extractBody(from: request)
        let signature = try createHMACSignature(
            for: httpMethod,
               path: path,
               body: body,
               secret: secret,
               isHexString: isHexString
        )
        request.setValue(signature, forHTTPHeaderField: httpHeaderField)
    }
}

// MARK: - Private

private extension NetworkRequestSignee {
    
    static func extractHTTPMethod(from request: URLRequest) throws -> HTTPMethod {
        guard let httpMethodString = request.httpMethod else {
            throw NetworkRequestError.missingHTTPMethod
        }
        guard let httpMethod = HTTPMethod(rawValue: httpMethodString) else {
            throw NetworkRequestError.unsupportedHTTPMethod
        }
        return httpMethod
    }
    
    static func extractPath(from request: URLRequest) throws -> String {
        guard let url = request.url else {
            throw NetworkRequestError.missingURL(url: request.url)
        }
        guard !url.path.isEmpty else {
            throw NetworkRequestError.missingPath(url: url)
        }
        let finalPath: String
        if let query = url.query, !query.isEmpty {
            finalPath = "\(url.path)?\(query)"
        } else {
            finalPath = url.path
        }
        return finalPath
    }
    
    static func extractBody(from request: URLRequest) throws -> String {
        let body: String
        if let bodyData = request.httpBody,
           let bodyString = String(data: bodyData, encoding: .utf8) {
            body = bodyString
        } else {
            body = ""
        }
        return body
    }
    
    static func createHMACSignature(for method: HTTPMethod,
                                path: String,
                                body: String,
                                secret: String,
                                isHexString: Bool = false) throws -> String {
        guard let secretData = secret.data(using: .utf8) else {
            throw NetworkRequestError.stringToDataFailed(string: secret)
        }
        let key = SymmetricKey(data: secretData)
        let timestamp = Date().timestampMilliseconds
        let stringToSign = "\(timestamp)" + method.rawValue + path + body
        guard let stringToSignData = stringToSign.data(using: .utf8) else {
            throw NetworkRequestError.stringToDataFailed(string: stringToSign)
        }
        let signature = HMAC<SHA256>.authenticationCode(for: stringToSignData, using: key)
        return isHexString ? Data(signature).hexStringEncoded() : Data(signature).base64EncodedString()
    }
}

