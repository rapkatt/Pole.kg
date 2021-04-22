//
//  UiView+.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 11/3/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit

extension UIView{
    
    func viewDesign(){
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 0.4
        self.layer.borderColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    }
    
    func constraintWith(identifier: String) -> NSLayoutConstraint?{
        return self.constraints.first(where: {$0.identifier == identifier})
    }
    
}
