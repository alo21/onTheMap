//
//  File.swift
//  onTheMap
//
//  Created by Alessandro Losavio on 07/03/2019.
//  Copyright © 2019 Losavio. All rights reserved.
//

import Foundation

struct StudentInformationSend: Codable {
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: Date?
    let updatedAt: Date?
}
