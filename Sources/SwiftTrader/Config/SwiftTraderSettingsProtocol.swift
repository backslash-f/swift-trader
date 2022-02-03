//
//  SwiftTraderSettingsProtocol.swift
//  
//
//  Created by Fernando Fernandes on 03.02.22.
//

import Foundation

/// Conform to this protocol to provide/tweak default package settings.
public protocol SwiftTraderSettings {
    var networkRequestSettings: NetworkRequestSettings { get }
}

/// The default conformance/values of the `SwiftTraderSettings` protocol.
public struct DefaultSwiftTraderSettings: SwiftTraderSettings {
    
    // MARK: - Properties
    
    public var networkRequestSettings: NetworkRequestSettings
    
    // MARK: - Lifecycle
    
    public init(networkRequestSettings: NetworkRequestSettings = DefaultNetworkRequestSettings()) {
        self.networkRequestSettings = networkRequestSettings
    }
}
