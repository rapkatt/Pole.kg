//
//  MyFieldModule.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 8/12/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import Foundation

struct MyFieldModule:Codable {
    let id: Int
    let field_type,owner:Int
    let phone_number, price, description: String
    let name: String
    let location: String
    let number_of_players: Int
    let has_parking, is_indoor, has_showers, has_locker_rooms: Bool
    let has_lights, has_rostrum, has_equipment: Bool
    let minimum_size, maximum_size: Int
    var images: [Images]!
    var working_hours: [WorkingHour1]!
    let is_approved: Bool
    let disable_booking: Bool
    let is_hidden: Bool
    
    func convertToParameters() -> [String : Any] {
        return ["id": id, "field_type": field_type,"owner": owner,"phone_number":phone_number,"price":price,"description":description,"name":name,"location":location,"number_of_players":number_of_players,"has_parking":has_parking,"is_indoor":is_indoor,"has_showers":has_showers,"has_locker_rooms":has_locker_rooms,"has_lights":has_lights,"has_rostrum":has_rostrum,"has_equipment":has_equipment,"minimum_size":minimum_size,"maximum_size":maximum_size,"is_approved":is_approved,"disable_booking":disable_booking,"is_hidden":is_hidden]
    }
    init(id: Int,field_type:Int,owner:Int,phone_number:String,price:String,description:String,location:String,number_of_players:Int,has_parking:Bool,is_indoor:Bool,has_showers:Bool,has_locker_rooms:Bool,has_lights:Bool,has_rostrum:Bool,has_equipment:Bool,minimum_size:Int,maximum_size:Int,is_approved:Bool,name:String,disable_booking:Bool,is_hidden:Bool){
        self.id = id
        self.field_type = field_type
        self.owner = owner
        self.has_parking = has_parking
        self.phone_number = phone_number
        self.price = price
        self.description = description
        self.location = location
        self.number_of_players = number_of_players
        self.is_indoor = is_indoor
        self.has_showers = has_showers
        self.has_locker_rooms = has_locker_rooms
        self.has_lights = has_lights
        self.has_rostrum = has_rostrum
        self.has_equipment = has_equipment
        self.minimum_size = minimum_size
        self.maximum_size = maximum_size
        self.is_approved = is_approved
        self.name = name
        self.disable_booking = disable_booking
        self.is_hidden = is_hidden
    }
}

// MARK: - Image
struct Images:Codable {
    let id, field: Int
    let image: String
}

// MARK: - WorkingHour
struct WorkingHour1:Codable {
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
