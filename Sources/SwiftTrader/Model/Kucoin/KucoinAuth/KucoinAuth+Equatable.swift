//
//  KucoinAuth+Equatable.swift
//
//
//  Created by Fernando Fernandes on 03.01.24.
//

import Foundation

extension KucoinAuth: Equatable {

    public static func == (lhs: KucoinAuth, rhs: KucoinAuth) -> Bool {
        lhs.spot.apiKey == rhs.spot.apiKey &&
        lhs.spot.apiSecret == rhs.spot.apiSecret &&
        lhs.spot.apiPassphrase == rhs.spot.apiPassphrase &&
        lhs.futures.apiKey == rhs.futures.apiKey  &&
        lhs.futures.apiSecret == rhs.futures.apiSecret  &&
        lhs.futures.apiPassphrase == rhs.futures.apiPassphrase
    }
}
