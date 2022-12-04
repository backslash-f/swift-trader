//
//  FTXAPI+Header.swift
//  
//
//  Created by Fernando Fernandes on 07.03.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Holds logic to set values for default HTTP header fields common to all FTX APIs requests.
extension FTXAPI {
    
    /// Sets values for default header fields in the given `URLRequest`
    ///
    /// Default header fields include `FTX-KEY`, `FTX-TS`, `FTX-SIGN`, etc.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` where the header field values are to be set.
    ///   - ftxAuth: `FTXAuth` that holds FTX authentication data.
    static func setRequestHeaderFields(request: inout URLRequest, ftxAuth: FTXAuth) throws {
        setAPIKey(request: &request, ftxAuth: ftxAuth)
        try setAPISignature(request: &request, ftxAuth: ftxAuth)
        setAPITimestamp(request: &request, ftxAuth: ftxAuth)
    }
}

// MARK: - Private

private extension FTXAPI {
    
    /// "FTX-KEY"
    static func setAPIKey(request: inout URLRequest, ftxAuth: FTXAuth) {
        request.setValue(ftxAuth.apiKey, forHTTPHeaderField: FTXAPI.HeaderField.apiKey)
    }
    
    /// "FTX-SIGN"
    static func setAPISignature(request: inout URLRequest, ftxAuth: FTXAuth) throws {
        try NetworkRequestSignee.createHMACSignature(
            for: &request,
               secret: ftxAuth.apiSecret,
               isHexString: true,
               httpHeaderField: FTXAPI.HeaderField.apiSign
        )
    }
    
    /// "FTX-TS"
    static func setAPITimestamp(request: inout URLRequest, ftxAuth: FTXAuth) {
        request.setValue("\(Date().timestampMilliseconds)", forHTTPHeaderField: FTXAPI.HeaderField.apiTimestamp)
    }
}
