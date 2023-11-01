//
//  SwiftTraderLogger.swift
//  
//
//  Created by Fernando Fernandes on 11.02.22.
//

import Foundation
import Logging

/// Logs information via Apple's `swift-log` package.
public struct SwiftTraderLogger {

    // MARK: - Private Properties

    private let logger: Logger

    // MARK: - Lifecycle

    public init(label: String = "com.backslash-f.swift-trader") {
        self.logger = Logger(label: label)
    }
}

// MARK: - Interface

public extension SwiftTraderLogger {

    func log(_ message: Logger.Message) {
        logger.log(level: .debug, message)
    }
}
