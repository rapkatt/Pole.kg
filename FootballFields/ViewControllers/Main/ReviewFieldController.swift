//
//  ReviewFieldController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 18/11/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import HCSStarRatingView

class ReviewFieldController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data:MainViewModel?
    var review:[reviewModelRequest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        collectionView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
      //  print(data?.id)
        ApiController.instance.reviewShow(fieldId: data!.id!.description, completion: reviewShow(info:))
    }
    func reviewShow(info:[reviewModelRequest]){
        for i in info{
            review.append(i)
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return review.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ReviewModel
        cell.textLabel.text = review[indexPath.row].description
        cell.raiting.value = CGFloat(review[indexPath.row].rate ?? 0.0)
        cell.raiting.tintColor = #colorLiteral(red: 1, green: 0.7647058824, blue: 0.1607843137, alpha: 1)
        cell.raiting.isUserInteractionEnabled = false
        cell.date.text = review[indexPath.row].review_date
        cell.name.text = review[indexPath.row].full_name
        
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        
        cell.viewForShadow.layer.backgroundColor = UIColor.white.cgColor
        cell.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        cell.viewForShadow.layer.cornerRadius = 3
        cell.viewForShadow.layer.masksToBounds = false
        cell.viewForShadow.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cell.viewForShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.viewForShadow.layer.shadowOpacity = 0.8
        return cell
    }
    
}

