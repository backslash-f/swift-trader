//
//  SwiftTraderLogger.swift
//  
//
//  Created by Fernando Fernandes on 03.02.22.
//

import Foundation
import Logging

/// Logs information via Apple's `swift-log` package.
public struct SwiftTraderLogger {
    
    // MARK: Properties
    
    var isLoggingEnabled: Bool
    
    // MARK: - Private Properties
    
    private let logger: Logger
    
    // MARK: - Lifecycle
    
    public init(label: String, isLoggingEnabled: Bool) {
        self.logger = Logger(label: label)
        self.isLoggingEnabled = isLoggingEnabled
    }
}

// MARK: - Interface

public extension SwiftTraderLogger {
    
    /// Logs the given message using the `.debug` level by default.
    func log(level: Logger.Level = .debug, message: @autoclosure () -> Logger.Message) {
        guard isLoggingEnabled else {
            return
        }
        logger.log(level: level, message())
    }
}
