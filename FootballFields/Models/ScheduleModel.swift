//
//  ScheduleModel.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 5/12/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import Foundation


class ScheduleModel:Codable {
    let field: Int
    var working_hours: [TimeHoursModel] = []
    
    func convertToParameters() -> [String : Any] {
        return ["field": field, "working_hours": [working_hours]]
    }
    init(field: Int, working_hours: [TimeHoursModel]){
        self.field = field
        self.working_hours = working_hours
    }
}

class TimeHoursModel:Codable {
    let day, start, end: String
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "day" : day,
            "start" : start,
            "end": end
        ]
    }
    
    init(day: String,start: String,end: String){
        self.day = day
        self.start = start
        self.end = end
    }
}

