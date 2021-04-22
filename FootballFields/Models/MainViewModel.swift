//
//  MainViewModel.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 11/2/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import Foundation

struct MainViewModel:Codable {
    
    let id, field_type, owner: Int?
    let name, price,description,location: String?
    let is_approved: Bool?
    let number_of_players: Int?
    let has_parking, is_indoor, has_showers, has_locker_rooms: Bool?
    let has_lights, has_rostrum, has_equipment: Bool?
    let minimum_size, maximum_size: Int?
    let phone_number:String?
    let images: [Image]?
    let rating: Float?
    let number_of_bookings: Int?
    let working_hours: [WorkingHour]?
    let disable_booking: Bool?
    let is_hidden: Bool?
    
}
struct Image:Codable {
    let id, field: Int?
    let image: String?
}

// MARK: - WorkingHour
struct WorkingHour:Codable {
    let id: Int?
    let day, start, end: String?
}


struct Category:Codable {
    let id: Int?
    let name: String?
}

struct reviewModelRequest:Codable {
    let id, field: Int?
    let rate:Float?
    let full_name:String?
    let description, review_date: String?
    let user: Int?
}
