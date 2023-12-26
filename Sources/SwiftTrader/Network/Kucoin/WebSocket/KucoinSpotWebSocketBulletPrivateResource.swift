//
//  KucoinSpotWebSocketBulletPrivateResource.swift
//
//
//  Created by Fernando Fernandes on 22.12.23.
//

import Foundation

/// The **resource** to obtain an authorized token for subscribing to private channels and messages via WebSocket.
///
/// https://bit.ly/kucoinPrivateConnectToken
public struct KucoinSpotWebSocketBulletPrivateResource: NetworkResource {

    // MARK: - Properties

    public var url: URL {
        get throws {
            let baseURLString = try KucoinAPI.Spot.baseURL()
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            urlComponents.path = KucoinAPI.Spot.Path.bulletPrivate
            guard let url = urlComponents.url else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            return url
        }
    }
}
