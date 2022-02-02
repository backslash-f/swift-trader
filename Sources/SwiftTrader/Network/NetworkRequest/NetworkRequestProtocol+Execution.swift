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
    func execute(attemptNumber: Int = 1) async -> NetworkRequestResult {
        let req: URLRequest
        do {
            req = try request
        } catch {
            return .failure(.invalidRequest(error: error))
        }
#if os(macOS) || os(iOS)
        let result = await runOnApplePlatforms(request: req)
        switch result {
        case .success:
            return result
        case .failure:
            if attemptNumber <= numberOfRetries {
#warning("TODO: [CONFIG] Wait time between attempts")
                // Delay the task by 2 seconds:
                try? await Task.sleep(nanoseconds: 2_000_000_000)
#warning("TODO: logger / enable, disable via config, default is ON")
                print("Retrying... \(attemptNumber) of \(numberOfRetries)")
                fflush(stdout)
                return await execute(attemptNumber: attemptNumber + 1)
            } else {
                return result
            }
        }
#elseif canImport(FoundationNetworking)
        return await runOnLinux(request: req)
#endif
    }
}

// MARK: - Private

private extension NetworkRequest {
    
#if os(macOS) || os(iOS)
    /// macOS and iOS.
    func runOnApplePlatforms(request: URLRequest) async -> NetworkRequestResult {
        do {
            let (data, response) = try await session.data(for: request)
            return handleResult(data: data, response: response)
        } catch {
            return .failure(.requestFailed(error: error))
        }
    }
#endif
    
    /// `async/await` isn't fully ported to Linux; use "withCheckedContinuation(function:_:)" instead.
    func runOnLinux(request: URLRequest) async -> NetworkRequestResult {
        let (data, response, error) = await withCheckedContinuation { continuation in
            session.dataTask(with: request) { data, response, error in
                continuation.resume(returning: (data, response, error))
            }.resume()
        }
        return handleResult(data: data, response: response, error: error)
    }
}
