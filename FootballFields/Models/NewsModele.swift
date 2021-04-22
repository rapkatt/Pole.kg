//
//  NewsModele.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 11/5/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import Foundation

struct NewsModel:Codable {
    let id: Int?
    let title, body: String?
    let date,time:String?
    let preview: String?
    let images: [Image2]
}
struct Image2:Codable {
    let id: Int
    let image: String
}
