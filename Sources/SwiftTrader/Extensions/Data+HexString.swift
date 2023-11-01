//
//  Data+HexString.swift
//  
//
//  Created by Fernando Fernandes on 07.03.22.
//

import Foundation

public extension Data {

    private static let hexAlphabet = Array("0123456789abcdef".unicodeScalars)

    /// Converts `self` to HEX String.
    ///
    /// https://stackoverflow.com/a/47476781/584548
    func hexStringEncoded() -> String {
        String(reduce(into: "".unicodeScalars) { result, value in
            result.append(Self.hexAlphabet[Int(value / 0x10)])
            result.append(Self.hexAlphabet[Int(value % 0x10)])
        })
    }
}
