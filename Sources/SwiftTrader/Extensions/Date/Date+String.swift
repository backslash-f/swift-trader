//
//  File.swift
//  
//
//  Created by Fernando Fernandes on 05.02.22.
//

import Foundation

public extension Date {

    /// E.g.: *"Saturday, 5. February 2022 at 22:32:16"*.
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .medium
        return formatter.string(from: self)
    }
}
