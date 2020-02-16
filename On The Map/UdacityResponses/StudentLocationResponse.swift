//
//  StudentLocationResponse.swift
//  On The Map
//
//  Created by Nils Riebeling on 01.11.19.
//  Copyright © 2019 Nils Riebeling. All rights reserved.
//

import Foundation

struct StudentLocationResponse: Codable {
    let results: [StudentLocation]
}
