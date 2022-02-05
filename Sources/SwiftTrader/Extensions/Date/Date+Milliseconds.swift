//
//  Date+Milliseconds.swift
//  
//
//  Created by Fernando Fernandes on 05.02.22.
//

import Foundation

public extension Date {
    
    // MARK: - Properties
    
    var millisecondsSince1970: Int64 {
        Int64((timeIntervalSince1970 * 1000).rounded())
    }
    
    // MARK: - Lifecycle

    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
