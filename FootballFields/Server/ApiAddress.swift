//
//  ApiAddress.swift
//  NeobisTime
//
//  Created by Islam on 7/21/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import Foundation
import Alamofire

struct ApiAddress {
    var scheme = "http"
    var domain = "167.71.36.59:8000/api"
    var endpoint: String = ""
    var param: String = ""
    
    init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    init(endpoint: String, param: [String: Any]?) {
        self.endpoint = endpoint
    }
    
    func getURLString() -> String {
        return "\(scheme)://\(domain)/\(endpoint)\(param)"
    }
    
    func getURL() -> URL? {
        return URL(string: getURLString())
    }
}
