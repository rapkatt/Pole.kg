//
//  ChandgeStatusModule.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 8/12/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import Foundation

struct ChandgeStatusModule {
    let field: Int
    let status: Int
    
    func convertToParameters() -> [String : Any] {
        return ["field": field,"status":status]
    }
    init(field: Int,status: Int){
        self.field = field
        self.status = status
        
    }
}
