//
//  HeaderCollectionReusableView.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 11/1/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "HeaderCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Площадки"
        label.font = UIFont(name: "Helvetica", size: 34)
        label.textColor = #colorLiteral(red: 0.05098039216, green: 0.5215686275, blue: 0.2862745098, alpha: 1)
        return label
    }()
    
    public func configure(){
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
        
}
