//
//  OTMError.swift
//  On The Map
//
//  Created by Nils Riebeling on 21.11.19.
//  Copyright © 2019 Nils Riebeling. All rights reserved.
//

import Foundation



    
    enum OTMError: Error {
        case missingCredentials
        case incorrectUserCredentials
        case interfaceNotReachable
        case noTextfieldInput(field: String)
        case noInternetConnection
        case dataUpdateFailed
        case logoutFailed
        case locationNotFound(location: String)
        case locationAlreadySet(location: String)
        case geoCodingFailed
    }


extension OTMError: LocalizedError {
    
    var errorDescription: String? {
        
        switch self {
        case .missingCredentials: return NSLocalizedString("Please enter username and password", comment: "Blablabal")
        case .incorrectUserCredentials: return NSLocalizedString("Username or password wrong", comment: "")
        case .interfaceNotReachable: return NSLocalizedString("Connection lost, please try again", comment: "")
        case .noTextfieldInput(let field): return NSLocalizedString("Please enter missing \(field) ", comment: "")
        case .noInternetConnection: return NSLocalizedString("Please check your internet connection", comment: "")
        case .dataUpdateFailed: return NSLocalizedString("Data update failed, please try again", comment: "")
        case .logoutFailed: return NSLocalizedString("Logout failed, please try again", comment: "")
        case .locationNotFound(let location): return NSLocalizedString("Location \(location) not found, please check your input", comment: "")
        case .locationAlreadySet(let location): return NSLocalizedString("You have already set \(location) as your location. Would you like to update?", comment: "")
        case .geoCodingFailed: return NSLocalizedString("Geocoding not possible. Please try again later", comment: "")
            
        }
        
    }
}



