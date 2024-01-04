//
//  String+Masking.swift
//
//
//  Created by Fernando Fernandes on 03.01.24.
//

import Foundation

public extension String {

    /// Hides sensitive information.
    ///
    /// - Returns: `""` when `self` is empty or `"••••"` when `self` is not empty.
    func masked() -> String {
        isEmpty ? "" : "••••"
    }
}
