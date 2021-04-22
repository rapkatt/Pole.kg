//
//  ProfileModule.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 19/11/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
protocol DeleteBooking {
    func onClickDelete(index:Int)
}

class ProfileCell:UICollectionViewCell{
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var timeEnd: UILabel!
    @IBOutlet weak var viewForShadow: UIView!
    @IBOutlet weak var buttonClick: UIButton!
    
    var cellDelegate: DeleteBooking?
    var index: IndexPath?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func delteBookingById(_ sender: Any) {
        cellDelegate?.onClickDelete(index: index!.row)
    }
    
}
