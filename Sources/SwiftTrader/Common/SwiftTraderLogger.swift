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
    
    func log(level: Logger.Level = .info, message: @autoclosure () -> Logger.Message, isFlush: Bool) {
        guard isLoggingEnabled else {
            return
        }
        logger.log(level: level, message())
        
        // [Server-side support] (Vapor)
        // Refer to https://github.com/vapor/vapor/issues/796
        if isFlush {
            fflush(stdout)
        }
    }
}
