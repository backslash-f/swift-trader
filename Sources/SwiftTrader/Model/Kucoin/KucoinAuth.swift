//
//  KucoinAuth.swift
//
//
//  Created by Fernando Fernandes on 29.01.22.
//

import Foundation

/// Holds data required to authenticate requests against Kucoin APIs.
public struct KucoinAuth {

    // MARK: - Properties

    public let apiKey: String
    public let apiSecret: String
    public let apiPassphrase: String

    // MARK: - Lifecycle

    public init(apiKey: String, apiSecret: String, apiPassphrase: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        self.apiPassphrase = apiPassphrase
    }
}
