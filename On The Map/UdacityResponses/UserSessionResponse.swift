//
//  UserSessionResponse.swift
//  On The Map
//
//  Created by Nils Riebeling on 07.11.19.
//  Copyright © 2019 Nils Riebeling. All rights reserved.
//

import Foundation

struct UserSessionResponse: Codable {
    let account: Account
    let session: Session
}

