//
//  RegistrationViewController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 11/10/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit

class RegistrationViewController:UIViewController{
    
    @IBOutlet weak var clientButton: UIButton!
    @IBOutlet weak var ownerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        clientButton.buttonBorderGreen()
        ownerButton.buttonBorderGreen()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "clientInfo"{
            let destVC = segue.destination as! PhoneNumberController
            destVC.infoOfType = 2
        }
        if segue.identifier == "ownerInfo"{
            let destVC = segue.destination as! PhoneNumberController
            destVC.infoOfType = 1
        }
    }
}
