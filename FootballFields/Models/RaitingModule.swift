//
//  RaitingModule.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 26/12/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import Foundation

struct RaitingModule:Codable {
    let field:Int
    let user:Int
    let rate:Double
    let description:String
    
    func convertToParameters() -> [String : Any] {
        return ["field": field,"user":user,"rate":rate,"description":description]
    }
    
    init(field: Int,user:Int,rate:Double,description:String){
        self.field = field
        self.user = user
        self.rate = rate
        self.description = description
    }
}
