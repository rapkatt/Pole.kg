//
//  MyFieldCell.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 28/11/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
protocol CollectionViewNew {
    func onClickEdit(index:Int)
    func onClickDelete(index:Int)
}

class MyFieldCell: UICollectionViewCell {
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var viewForShadow: UIView!
    
    var cellDelegate: CollectionViewNew?
    var index: IndexPath?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func editAction(_ sender: Any) {
        cellDelegate?.onClickEdit(index: index!.row)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        cellDelegate?.onClickDelete(index: index!.row)
    }
}
