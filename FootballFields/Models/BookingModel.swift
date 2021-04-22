//
//  BookingModel.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 25/11/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import Foundation

class BookingModel: Codable {
    let field: Int
    let booking_date: String
    let time_start: String
    let time_end:String
    let status:Int
    var detail:String!

    func convertToParameters() -> [String : Any] {
        return ["field": field, "booking_date": booking_date,"time_start": time_start,"time_end":time_end,"status":status]
    }
    init(field: Int, booking_date: String,time_start:String,time_end:String,status:Int) {
        self.field = field
        self.booking_date = booking_date
        self.time_start = time_start
        self.time_end = time_end
        self.status = status
    }
}
