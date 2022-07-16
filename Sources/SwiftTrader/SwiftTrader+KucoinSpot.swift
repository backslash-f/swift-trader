//
//  SwiftTrader+KucoinSpot.swift
//  
//
//  Created by Fernando Fernandes on 16.07.22.
//

import Foundation

/// Interface to Kucoin APIs.
public extension SwiftTrader {
    
    // MARK: - List Accounts
    
    /// Get the list of accounts.
    ///
    /// There are three types of accounts: 1) main account 2) trade account 3) margin account.
    ///
    /// https://docs.kucoin.com/#list-accounts
    ///
    /// - Parameter currencySymbol: The `CurrencySymbol` of the account balance. The default is `.USDT`.
    /// - Returns: An instance of of `KucoinAccounts` or `SwiftTraderError`.
    func kucoinAccounts(currencySymbol: CurrencySymbol = .USDT) async throws -> Result<KucoinAccounts, SwiftTraderError> {
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        let request = KucoinAccountsRequest(
            currencySymbol: currencySymbol,
            kucoinAuth: auth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let accounts = model as? KucoinAccounts else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(accounts)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .kucoinAccounts)
            return .failure(swiftTraderError)
        }
    }
}
