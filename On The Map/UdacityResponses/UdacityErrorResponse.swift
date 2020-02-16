//
//  UdacityErrorResponse.swift
//  On The Map
//
//  Created by Nils Riebeling on 14.11.19.
//  Copyright © 2019 Nils Riebeling. All rights reserved.
//

import Foundation


struct UdacityErrorResponse: Codable {
    let code: Int
    let error: String
}
