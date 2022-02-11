//
//  NetworkRequestLogger.swift
//  
//
//  Created by Fernando Fernandes on 04.02.22.
//

import Foundation
import Logging

/// Logs information via Apple's `swift-log` package.
public struct NetworkRequestLogger {
    
    // MARK: - Properties
    
    public let `default`: Logger
    
    // MARK: - Lifecycle
    
    public init(label: String = "com.backslash-f.swift-trader.network") {
        self.default = Logger(label: label)
    }
}
