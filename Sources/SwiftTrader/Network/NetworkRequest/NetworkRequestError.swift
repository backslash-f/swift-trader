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
    
    /// Could not cast response to `HTTPURLResponse`.
    case invalidResponse
    
    /// Could not instantiate a valid `URLRequest` (e.g.: `NetworkRequest.getter:request`).
    case invalidRequest(error: Error)
    
    /// Could not instantiate a `URLComponents` struct using the given `String` URL.
    case invalidURLString(urlString: String)
    
    /// The request has failed; the `Error` parameter indicates why.
    case requestFailed(error: Error)
    
    /// The response status code is something other than `200`.
    ///
    /// The underlying error may be verified by reading the `Data` argument.
    case statusCodeNotOK(statusCode: Int, localizedErrorMessage: String, data: Data)
}
