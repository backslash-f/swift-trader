//
//  KucoinOrderStatus.swift
//  
//
//  Created by Fernando Fernandes on 05.02.22.
//

import Foundation

public enum KucoinOrderStatus: String, Codable {
    case active
    case done
    case open
}
