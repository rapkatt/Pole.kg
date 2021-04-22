//
//  RequestsModule.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 12/12/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import Foundation

struct RequestsModule:Codable {
    let id: Int
    let field: Field1
    let image: String
    let user: User1
    let booking_date, time_start, time_end, status: String
    let created_at: String
    let is_finished:Bool?
}

// MARK: - Field
struct Field1:Codable {
    let id: Int
    let name: String
}

// MARK: - User
struct User1:Codable {
    let id: Int
    let full_name, phone_number: String
}

