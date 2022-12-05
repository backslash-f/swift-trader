//
//  NetworkRequestError.swift
//  
//
//  Created by Fernando Fernandes on 28.01.22.
//

import Foundation

/// Encapsulates errors that may happen during network requests.
public enum NetworkRequestError: Error {
    
    /// `Data` could not be parsed to an expected`Decodable` object.
    case couldNotDecodeModelFromData(error: Error)
    
    /// Data from response is `nil`.
    case invalidData
    
    /// Could not return a `Data` representation of the given String (e.g. via `.data(using: .utf8)`).
    case invalidDataFromString(string: String)
    
    /// Could not cast response to `HTTPURLResponse`.
    case invalidResponse
    
    /// Could not instantiate a valid `URLRequest` (e.g.: `NetworkRequest.getter:request`).
    case invalidRequest(error: Error)
    
    /// `JSONSerialization` could not produce a valid `JSON` from given parameters.
    ///
    /// E.g.: a `JSON` object could not be created from an instance of `KucoinFuturesOrderParameters`.
    case invalidJSONParameters(error: Error)
    
    /// Could not instantiate a `URLComponents` struct using the given `String` URL.
    case invalidURLString(urlString: String)
    
    /// The request has failed; the `Error` parameter indicates why.
    case requestFailed(error: Error)
    
    /// The response status code is something other than `200`.
    ///
    /// The underlying error may be verified by reading the `Data` argument.
    case statusCodeNotOK(statusCode: Int, localizedErrorMessage: String, data: Data)
    
    // MARK: - Request Creation Related
    
    /// The HTTP method (e.g.: `GET` / `POST`) is absent.
    case missingHTTPMethod
    
    /// The `URLRequest`'s `path` (e.g.: `/api/v1/account-overview`) is absent.
    case missingPath(url: URL)
    
    /// The `URLRequest`'s `URL` (e.g.: `https://api-futures.kucoin.com`) is absent.
    case missingURL(url: URL?)
    
    /// "someString".data(using: .utf8) failed.
    case stringToDataFailed(string: String)
    
    /// The HTTP method (e.g.: `GET` / `POST`) is unsupported.
    case unsupportedHTTPMethod
}
