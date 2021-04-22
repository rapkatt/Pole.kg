//
//  BlackListModel.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 15/12/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import Foundation

struct BlackListModel:Codable{
    let field,user_id:Int
    var user:String!
    
    func convertToParameters() -> [String : Any] {
        return ["field": field,"user_id":user_id]
    }
    init(field: Int,user_id: Int){
        self.field = field
        self.user_id = user_id
        
    }
}
