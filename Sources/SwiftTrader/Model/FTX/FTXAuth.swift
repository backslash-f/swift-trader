//
//  FTXAuth.swift
//  
//
//  Created by Fernando Fernandes on 07.03.22.
//

import Foundation

/// Holds data required to authenticate requests against FTX APIs.
public struct FTXAuth {

    // MARK: - Properties

    public let apiKey: String
    public let apiSecret: String

    // MARK: - Lifecycle

    public init(apiKey: String, apiSecret: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
    }
}
