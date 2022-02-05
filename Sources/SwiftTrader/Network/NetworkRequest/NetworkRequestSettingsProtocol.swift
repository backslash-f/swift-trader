//
//  NetworkRequestSettings.swift
//  
//
//  Created by Fernando Fernandes on 04.02.22.
//

import Foundation
import Logging

/// Conform to this protocol to provide/tweak default `NetworkRequest` settings.
public protocol NetworkRequestSettings {
    
    /// `true` to enable logging of network requests.
    var isLoggingEnable: Bool { get }
    
    /// The log level.
    var logLevel: Logger.Level { get }
    
    /// The number of retries of failed `NetworkRequest`s.
    var numberOfRetries: Int { get }

    /// How many seconds to wait between each `NetworkRequestSettings.getter:numberOfRetries`.
    var delayBetweenRetries: UInt64 { get }
}

/// The default conformance/values of the `NetworkRequestSettings` protocol.
public struct DefaultNetworkRequestSettings: NetworkRequestSettings {
    
    // MARK: - Properties
    
    public var logLevel: Logger.Level = .debug
    public var isLoggingEnable: Bool = true
    public var numberOfRetries: Int = 2
    public var delayBetweenRetries: UInt64 = 1
    
    // MARK: - Lifecycle
    
    public init() {}
}
