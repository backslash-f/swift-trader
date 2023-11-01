//
//  NetworkRequestProtocol+Logging.swift
//  
//
//  Created by Fernando Fernandes on 04.02.22.
//

import Foundation
import Logging

/// Holds the default logging implementation.
public extension NetworkRequest {

    func log(message: Logger.Message) {
        guard settings.isLoggingEnable else {
            return
        }
        logger.log(level: settings.logLevel, message)
    }
}
