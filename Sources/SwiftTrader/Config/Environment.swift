//
//  Environment.swift
//  
//
//  Created by Fernando Fernandes on 09.02.22.
//

import Foundation

/// Defines the target exchange environment, such as `production` or `sandbox`.
public enum Environment: String {
    case production
    case productionFutures
    case sandbox
    case sandboxFutures
}

// MARK: - Interface

public extension Environment {
    
    /// An `ENVIRONMENT` variable can be set in the run schema in Xcode to easily switch between them.
    /// This functions returns it or `nil` if it's absent.
    static func environmentFromXcode() -> Environment? {
#if os(macOS) || os(iOS)
        guard let environmentValue = ProcessInfo.processInfo.environment["ENVIRONMENT"],
              let environment = Environment(rawValue: environmentValue) else {
                  return nil
              }
        return environment
#else
        return nil
#endif
    }
}
