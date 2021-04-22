//
//  NewFieldModule.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 1/12/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import Foundation

class NewFieldModule: Codable {
    
    let field_type:Int
    let name:String
    let price:String
    let is_approved:Bool
    let number_of_players:Int
    let has_parking:Bool
    let is_indoor:Bool
    let has_showers:Bool
    let has_locker_rooms:Bool
    let has_lights:Bool
    let has_rostrum:Bool
    let has_equipment:Bool
    let minimum_size:Int
    let maximum_size:Int
    let location:String
    let description:String
    let phone_number:String
    
    func convertToParameters() -> [String : Any] {
        return ["field_type": field_type, "name": name,"price": price,"is_approved":is_approved,"number_of_players":number_of_players,"has_parking": has_parking, "is_indoor": is_indoor,"has_showers": has_showers,"has_locker_rooms":has_locker_rooms,"has_lights":has_lights,"has_rostrum": has_rostrum, "has_equipment": has_equipment,"minimum_size": minimum_size,"maximum_size":maximum_size,"location":location,"description":description,"phone_number":phone_number]
    }
    init(field_type: Int, name: String,price:String,is_approved:Bool,number_of_players:Int,has_parking: Bool, is_indoor: Bool,has_showers:Bool,has_locker_rooms:Bool,has_lights:Bool,has_rostrum: Bool, has_equipment: Bool,minimum_size:Int,maximum_size:Int,description:String,location:String,phone_number:String) {
        self.field_type = field_type
        self.name = name
        self.price = price
        self.is_approved = is_approved
        self.number_of_players = number_of_players
        self.has_parking = has_parking
        self.is_indoor = is_indoor
        self.has_showers = has_showers
        self.has_locker_rooms = has_locker_rooms
        self.has_lights = has_lights
        self.has_rostrum = has_rostrum
        self.has_equipment = has_equipment
        self.minimum_size = minimum_size
        self.maximum_size = maximum_size
        self.description = description
        self.location = location
        self.phone_number = phone_number
    }
}
class idTaker:Codable{
    let id:Int
}
