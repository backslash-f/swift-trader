//
//  Environment.swift
//  
//
//  Created by Fernando Fernandes on 09.02.22.
//

import Foundation

/// Defines the target exchange environment, such as `production` or `sandbox`.
public enum ExchangeEnvironment: String {
    case production
    case sandbox
}

// MARK: - Interface

public extension ExchangeEnvironment {

    /// An `ENVIRONMENT` variable can be set in the run schema in Xcode to easily switch between them.
    /// This functions returns it or `nil` if it's absent.
    static func environmentFromXcode() -> ExchangeEnvironment? {
#if os(macOS) || os(iOS)
        guard let environmentValue = ProcessInfo.processInfo.environment["ENVIRONMENT"],
              let environment = ExchangeEnvironment(rawValue: environmentValue) else {
                  return nil
              }
        return environment
#else
        return nil
#endif
    }
}
