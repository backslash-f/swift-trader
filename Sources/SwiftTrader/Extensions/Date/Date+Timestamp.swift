//
//  Date+Timestamp.swift
//  
//
//  Created by Fernando Fernandes on 29.01.22.
//

import Foundation

public extension Date {
    
    var timestampMilliseconds: Int64 {
        Int64(timeIntervalSince1970 * 1000)
    }
}
