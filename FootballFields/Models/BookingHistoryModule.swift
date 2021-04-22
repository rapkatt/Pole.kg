//
//  BookingHistoryModule.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 7/12/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import Foundation

struct BookingHistoryModule:Codable {
    let id: Int
    let field: Field1
    let image: String
    let user: User1
    let booking_date, time_start, time_end, status: String
    let created_at: String
    let is_finished:Bool
    let feedback_given:Bool
}

