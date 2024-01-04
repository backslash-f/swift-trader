//
//  KucoinAuthorizing.swift
//  
//
//  Created by Fernando Fernandes on 03.01.24.
//

import Foundation

public protocol KucoinAuthorizing: Codable {
    var apiKey: String { get }
    var apiSecret: String { get }
    var apiPassphrase: String { get }
}
