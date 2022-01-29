//
//  NetworkRequestProtocol+Execution.swift
//  
//
//  Created by Fernando Fernandes on 29.01.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Holds the default implementation of actual request executions, as defined in `NetworkRequest.execute(_:)`.
///
/// Supports multiplatforms such as macOS, iOS and Linux / Heroku.
public extension NetworkRequest {
    
    // MARK: - Default Execution
    
    /// Executes the given request asynchronously (`async/await`) and returns the result.
    ///
    /// - Parameter request: `URLRequest` containing the target `URL`.
    /// - Returns: `NetworkRequestResult`.
    func execute() async -> NetworkRequestResult {
#if os(macOS) || os(iOS)
        do {
            let (data, response) = try await session.data(for: request)
            return handleResult(data: data, response: response)
        } catch {
            return handleResult(data: nil, response: nil, error: error)
        }
#elseif canImport(FoundationNetworking)
        // `async/await` isn't fully ported to Linux; use "withCheckedContinuation(function:_:)" instead.
        let (data, response, error) = await  withCheckedContinuation { continuation in
            session.dataTask(with: request) { data, response, error in
                continuation.resume(returning: (data, response, error))
            }.resume()
            return handleResult(data: data, response: response, error: error)
        }
#endif
    }
}
