//
//  NetworkRequestProtocol.swift
//  
//
//  Created by Fernando Fernandes on 28.01.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

public typealias NetworkRequestResult = Result<Decodable, NetworkRequestError>

/// Represents a generic network request composed by basic functions that make a network request possible.
public protocol NetworkRequest {
    associatedtype DecodableModel: Decodable
    var logger: SwiftTraderLogger { get }
    var session: URLSession { get }
    var request: URLRequest { get throws }
    var settings: NetworkRequestSettings { get }
    func execute(attemptNumber: Int) async -> NetworkRequestResult
    func decode(_ data: Data) throws -> DecodableModel
}
