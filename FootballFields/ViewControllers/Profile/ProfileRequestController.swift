//
//  ProfileRequestController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 29/11/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit

class ProfileRequestController:UIViewController{
    
    @IBOutlet weak var NewRequests: UIView!
    @IBOutlet weak var AcceptedRequests: UIView!
    @IBOutlet weak var ClosedRequests: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NewRequests.alpha = 1
        AcceptedRequests.alpha = 0
        ClosedRequests.alpha = 0
    }
    @IBAction func SegmentController(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            NewRequests.alpha = 1
            AcceptedRequests.alpha = 0
            ClosedRequests.alpha = 0
        }else if sender.selectedSegmentIndex == 1{
            NewRequests.alpha = 0
            AcceptedRequests.alpha = 1
            ClosedRequests.alpha = 0
        }else{
            NewRequests.alpha = 0
            AcceptedRequests.alpha = 0
            ClosedRequests.alpha = 1
        }
    }
}
