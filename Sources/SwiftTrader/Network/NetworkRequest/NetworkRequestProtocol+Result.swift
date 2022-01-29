//
//  NetworkRequestProtocol+Result.swift
//  
//
//  Created by Fernando Fernandes on 29.01.22.
//

import Foundation

/// Holds logic to parse and return results of type `NetworkRequestResult`.
public extension NetworkRequest {
    
    func handleResult(data: Data?, response: URLResponse?, error: Error? = nil) -> NetworkRequestResult {
        if let error = error {
            return .failure(.requestFailed(error: error))
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.invalidResponse)
        }
        guard let data = data else {
            return .failure(.invalidData)
        }
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 200:
            do {
                let model = try decode(data)
                return .success(model)
            } catch {
                return .failure(.couldNotDecodeModelFromData(error: error))
            }
        default:
            let localizedErrorMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            return .failure(.statusCodeNotOK(statusCode: statusCode, localizedErrorMessage: localizedErrorMessage))
        }
    }
}
