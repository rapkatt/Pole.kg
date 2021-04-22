//
//  MainViewCell.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 10/28/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import HCSStarRatingView

class MainViewCell: UICollectionViewCell {

    @IBOutlet weak var imageOfFields: UIImageView!
    @IBOutlet weak var nameOfFields: UILabel!
    @IBOutlet weak var locationFields: UILabel!
    @IBOutlet weak var priceFields: UILabel!
    @IBOutlet weak var textFields: UILabel!
    @IBOutlet weak var viewOfShadow: UIView!
    @IBOutlet weak var raiting: HCSStarRatingView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewOfShadow.layer.backgroundColor = UIColor.white.cgColor
        self.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.viewOfShadow.layer.cornerRadius = 3
        self.viewOfShadow.layer.masksToBounds = false
        self.viewOfShadow.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.viewOfShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.viewOfShadow.layer.shadowOpacity = 0.8
        
        nameOfFields.layer.shadowOpacity = 0.5
        nameOfFields.layer.shadowRadius = 0.5
        nameOfFields.layer.shadowColor = UIColor.black.cgColor
        nameOfFields.layer.shadowOffset = CGSize(width: 0.0, height: -0.5)
    }
  
    
}
