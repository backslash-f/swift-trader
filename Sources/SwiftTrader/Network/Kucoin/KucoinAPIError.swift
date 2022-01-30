//
//  KucoinAPIError.swift
//  
//
//  Created by Fernando Fernandes on 30.01.22.
//

import Foundation

/// Encapsulates Kucoin API related errors.
public enum KucoinAPIError: Error {
    
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
