//
//  FTXPositionListRequest.swift
//  
//
//  Created by Fernando Fernandes on 07.03.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// A **request** for the list of positions.
///
/// https://docs.ftx.com/#get-positions
public struct FTXPositionListRequest: NetworkRequest {
    
    // MARK: - Properties
    
    public typealias DecodableModel = FTXPositionList
    
    public var logger: Logger {
        NetworkRequestLogger().default
    }
    
    public var session: URLSession
    
    public var request: URLRequest {
        get throws {
            let positionListResource = FTXPositionListResource()
            var urlRequest = URLRequest(url: try positionListResource.url)
            urlRequest.httpMethod = HTTPMethod.GET.rawValue
            try FTXAPI.setRequestHeaderFields(request: &urlRequest, ftxAuth: ftxAuth)
            return urlRequest
        }
    }
    
    public var settings: NetworkRequestSettings
    
    // MARK: Private
    
    private let ftxAuth: FTXAuth
    
    // MARK: - Lifecycle
    
    /// Creates a new `FTXPositionListRequest` instance.
    ///
    /// - Parameters:
    ///   - session: `URLSession`, default is `.shared`.
    ///   - ftxAuth: FTX authentication data.
    ///   - settings: `NetworkRequestSettings`.
    public init(session: URLSession = .shared,
                ftxAuth: FTXAuth,
                settings: NetworkRequestSettings) {
        self.session = session
        self.ftxAuth = ftxAuth
        self.settings = settings
    }
}

// MARK: - Network Request Protocol

public extension FTXPositionListRequest {
    
    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(FTXPositionList.self, from: data)
    }
}
