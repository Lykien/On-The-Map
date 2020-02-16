//
//  GetSessionRequest.swift
//  On The Map
//
//  Created by Nils Riebeling on 07.11.19.
//  Copyright © 2019 Nils Riebeling. All rights reserved.
//

import Foundation


struct UserSessionRequest: Codable {
    let udacity: Credentials
}

struct Credentials: Codable{
    let username: String
    let password: String
}
