//
//  NewRequestCell.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 29/11/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
protocol NewCellProtocol {
    func onClicAccept(index:Int)
    func onClickReject(index:Int)
}

class NewRequestCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var timeStart: UILabel!
    @IBOutlet weak var timeEnd: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var viewForShadow: UIView!
    
    var cellDelegate: NewCellProtocol?
    var index: IndexPath?
    
    
    
    @IBAction func AcceptBtnAction(_ sender: Any) {
        cellDelegate?.onClicAccept(index: index!.row)
        
    }
    @IBAction func CancelBtnAction(_ sender: Any) {
        cellDelegate?.onClickReject(index: index!.row)
        
    }
}
