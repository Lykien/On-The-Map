//
//  StudentLocation.swift
//  On The Map
//
//  Created by Nils Riebeling on 01.11.19.
//  Copyright © 2019 Nils Riebeling. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let objectId: String?
    let uniqueKey: String //Udacity account id
    let firstName: String
    let lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    let createdAt: String?
    let updatedAt: String?
//    let ACL: ACL
}



