//
//  KucoinWebSocketPrivateTokenResponse.swift
//
//
//  Created by Fernando Fernandes on 26.12.23.
//

import Foundation

public struct KucoinWebSocketPrivateTokenResponse: Codable {
    public let code: String
    public let data: KucoinDataClass
}

public struct KucoinDataClass: Codable {
    public let token: String
    public let instanceServers: [KucoinInstanceServer]
}

public struct KucoinInstanceServer: Codable {
    public let endpoint: String
    public let encrypt: Bool
    public let instanceServerProtocol: String
    public let pingInterval: Int
    public let pingTimeout: Int

    enum CodingKeys: String, CodingKey {
        case endpoint
        case encrypt
        case instanceServerProtocol = "protocol"
        case pingInterval
        case pingTimeout
    }
}
