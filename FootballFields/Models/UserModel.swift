//
//  UserModel.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 7/12/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import Foundation

struct UserModel {
    let full_name: String
    
    func convertToParameters() -> [String : Any] {
        return ["full_name": full_name]
    }
    init(full_name: String){
        self.full_name = full_name
        
    }
}
