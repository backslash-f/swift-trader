//
//  KucoinFuturesPositionListResource.swift
//
//
//  Created by Fernando Fernandes on 04.02.22.
//

import Foundation

/// The **resource** for requesting the list of current positions.
///
/// https://docs.kucoin.com/futures/#get-position-list
public struct KucoinFuturesPositionListResource: NetworkResource {

    // MARK: - Properties

    public var url: URL {
        get throws {
            let baseURLString = try KucoinAPI.Futures.baseURL()
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            urlComponents.path = KucoinAPI.Futures.Path.positions
            guard let url = urlComponents.url else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            return url
        }
    }
}
