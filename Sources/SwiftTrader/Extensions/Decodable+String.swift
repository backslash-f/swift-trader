//
//  Decodable+String.swift
//  
//
//  Created by Fernando Fernandes on 30.01.22.
//

import Foundation

public extension Decodable {
    
    func toString() -> String {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
           let dataString = String(data: data, encoding: .utf8) {
            return dataString
        } else {
            return ""
        }
    }
}
