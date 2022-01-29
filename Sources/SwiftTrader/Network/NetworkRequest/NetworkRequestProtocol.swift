//
//  NetworkRequestProtocol.swift
//  
//
//  Created by Fernando Fernandes on 28.01.22.
//

import Foundation

public typealias NetworkRequestResult = Result<Decodable?, NetworkRequestError>

/// Represents a generic network request composed by basic functions that make a network request possible.
public protocol NetworkRequest {
    associatedtype DecodableModel: Decodable
    var session: URLSession { get }
    var request: URLRequest { get throws }
    func execute() async -> NetworkRequestResult
    func decode(_ data: Data) throws -> DecodableModel
}
