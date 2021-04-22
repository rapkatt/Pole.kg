//
//  refreshToken.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 26/12/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import Foundation

struct refreshToken:Codable {
    let token:String
    
    func convertToParameters() -> [String : Any] {
        return ["token": token]
    }
    init(token: String){
        self.token = token
        
    }
}
struct refreshToken2:Codable {
    let token:String
}
