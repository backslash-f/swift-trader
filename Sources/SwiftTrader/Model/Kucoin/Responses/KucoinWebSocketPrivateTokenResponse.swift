//
//  KucoinWebSocketPrivateTokenResponse.swift
//
//
//  Created by Fernando Fernandes on 26.12.23.
//

import Foundation

public struct KucoinWebSocketPrivateTokenResponse: Codable {
    let code: String
    let data: KucoinDataClass
}

public struct KucoinDataClass: Codable {
    let token: String
    let instanceServers: [KucoinInstanceServer]
}

public struct KucoinInstanceServer: Codable {
    let endpoint: String
    let encrypt: Bool
    let instanceServerProtocol: String
    let pingInterval: Int
    let pingTimeout: Int

    enum CodingKeys: String, CodingKey {
        case endpoint
        case encrypt
        case instanceServerProtocol = "protocol"
        case pingInterval
        case pingTimeout
    }
}
