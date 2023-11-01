//
//  HTTPHeader.swift
//  
//
//  Created by Fernando Fernandes on 10.02.22.
//

import Foundation

/// Holds HTTP header related constants.
public struct HTTPHeader {

    public struct Field {
        static let contentType      = "Content-Type"
        static let accept           = "Accept"
    }

    public struct Value {
        static let applicationJSON  = "application/json"
        static let urlEncoded       = "application/x-www-form-urlencoded"
    }
}
