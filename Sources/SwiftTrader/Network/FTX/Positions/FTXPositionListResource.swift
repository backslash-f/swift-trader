//
//  FTXPositionListResource.swift
//
//
//  Created by Fernando Fernandes on 07.03.22.
//

import Foundation

/// The **resource** for requesting the list of current positions.
///
/// https://docs.ftx.com/#get-positions
public struct FTXPositionListResource: NetworkResource {
    
    // MARK: - Properties
    
    public var url: URL {
        get throws {
            let baseURLString = FTXAPI.BaseURL.production
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            urlComponents.path = FTXAPI.Path.positions
            guard let url = urlComponents.url else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            return url
        }
    }
}
