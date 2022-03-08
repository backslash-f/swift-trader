//
//  SwiftTrader+FTX.swift
//
//
//  Created by Fernando Fernandes on 07.03.22.
//

import Foundation

/// Interface to FTX APIs.
public extension SwiftTrader {
    
    // MARK: Positions
    
    /// Lists open positions.
    ///
    /// https://docs.ftx.com/#get-positions
    ///
    /// - Returns: An instance of `FTXPositionList` or `SwiftTraderError`.
    func ftxPositions() async throws -> Result<FTXPositionList, SwiftTraderError> {
        guard let auth = ftxAuth else {
            return .failure(.ftxMissingAuthentication)
        }
        let request = FTXPositionListRequest(
            ftxAuth: auth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let positionList = model as? FTXPositionList else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(positionList)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .ftxPositions)
            return .failure(swiftTraderError)
        }
    }
}
