//
//  LoginPost.swift
//  onTheMap
//
//  Created by Alessandro Losavio on 10/03/2019.
//  Copyright © 2019 Losavio. All rights reserved.
//

import Foundation

struct LoginPost: Codable {
    let udacity: PersonalInfo
}

struct PersonalInfo: Codable {
    let username: String
    let password: String
}
