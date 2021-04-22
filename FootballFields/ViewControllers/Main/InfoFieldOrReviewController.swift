//
//  test.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 17/11/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit

class InfoFieldOrReviewController:UIViewController{
    
    @IBOutlet weak var first: UIView!
    @IBOutlet weak var second: UIView!
    
    var data:MainViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        first.alpha = 1
        second.alpha = 0
    }
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            first.alpha = 1
            second.alpha = 0
        }else{
            first.alpha = 0
            second.alpha = 1
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "first"{
            let destVC = segue.destination as! InfoFieldController
            destVC.data = data
        }
        if segue.identifier == "second"{
            let destVC = segue.destination as! ReviewFieldController
            destVC.data = data
        }
    }
}

