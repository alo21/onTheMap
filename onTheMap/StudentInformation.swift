//
//  Student.swift
//  onTheMap
//
//  Created by Alessandro Losavio on 03/03/2019.
//  Copyright © 2019 Losavio. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    let objectId: String
    let uniqueKey: String
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String
    let updatedAt: String
}
