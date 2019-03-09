//
//  SuccessLoginResponse.swift
//  onTheMap
//
//  Created by Alessandro Losavio on 09/03/2019.
//  Copyright © 2019 Losavio. All rights reserved.
//

import Foundation


struct SuccessLoginResult: Codable{
    let account: Account
    let session: Session
}


struct Account: Codable {
    let key: String
    let registered: Bool
}

struct Session: Codable {
    let expiration: String
    let id: String
}
