//
//  ReviewModel.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 18/11/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import HCSStarRatingView

class ReviewModel:UICollectionViewCell{
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var viewForShadow: UIView!
    
    @IBOutlet weak var raiting: HCSStarRatingView!
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)

        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame

        return layoutAttributes
    }
}
