//
//  BlackListCell.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 26/11/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
protocol DeleteFromBlackList {
    func onClickDelete(index:Int)
}

class BlackLIstCell:UITableViewCell{
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var unBlockButton: UIButton!
    
    var cellDelegate: DeleteFromBlackList?
    var index: IndexPath?
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func deleteFromBlackList(_ sender: Any) {
        cellDelegate?.onClickDelete(index: index!.row)
    }
}
