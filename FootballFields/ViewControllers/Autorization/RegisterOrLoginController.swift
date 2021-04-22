//
//  RegisterOrLoginController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 11/12/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit

class RegisterOrLoginController:UIViewController{
    
    @IBOutlet weak var registration: UIButton!
    @IBOutlet weak var login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        registration.buttonBorderGreen()
        login.buttonGreen()
    }
    
    @IBAction func goToMainScreen(_ sender: Any) {
        openViewController()
    }
    func openViewController(){
        let vc = storyboard?.instantiateViewController(identifier: "test321") as? UITabBarController
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true, completion: nil)
        vc?.selectedIndex = 1
    }
}
