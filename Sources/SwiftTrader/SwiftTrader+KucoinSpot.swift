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
    /// - Returns: An instance of `KucoinSpotListAccounts` or `SwiftTraderError`.
    func kucoinSpotListAccounts(currencySymbol: CurrencySymbol = .USDT) async throws -> Result<KucoinSpotListAccountsResponse, SwiftTraderError> {
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        let request = KucoinListAccountsRequest(
            currencySymbol: currencySymbol,
            kucoinAuth: auth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let accounts = model as? KucoinSpotListAccountsResponse else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(accounts)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .kucoinSpotListAccounts)
            return .failure(swiftTraderError)
        }
    }
    
    // MARK: - Account
    
    /// Information for a single account.
    ///
    /// https://docs.kucoin.com/#get-an-account
    ///
    /// - Parameter accountID: The ID of the account.
    /// - Returns: An instance of of `KucoinSpotGetAccount` or `SwiftTraderError`.
    func kucoinSpotGetAccount(accountID: String) async throws -> Result<KucoinSpotGetAccountResponse, SwiftTraderError> {
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        let request = KucoinGetAccountRequest(
            accountID: accountID,
            kucoinAuth: auth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let accounts = model as? KucoinSpotGetAccountResponse else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(accounts)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .kucoinSpotGetAccount)
            return .failure(swiftTraderError)
        }
    }
    
    // MARK: - Transferable
    
    /// Returns the transferable balance of a specified account.
    ///
    /// https://docs.kucoin.com/#get-the-transferable
    ///
    /// - Returns: An instance of of `KucoinSpotGetTransferableResponse` or `SwiftTraderError`.
    func kucoinSpotGetTransferable() async throws -> Result<KucoinSpotGetTransferableResponse, SwiftTraderError> {
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        let request = KucoinGetTransferableRequest(
            kucoinAuth: auth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let transferable = model as? KucoinSpotGetTransferableResponse else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(transferable)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .kucoinSpotGetTransferable)
            return .failure(swiftTraderError)
        }
    }
}
