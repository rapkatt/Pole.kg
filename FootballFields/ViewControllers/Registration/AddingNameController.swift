//
//  AddingNameController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 11/12/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import PopupDialog
import SwiftValidator

class AddingNameController:UIViewController{
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var nameValidation: UILabel!
    
    let userDefault = UserDefaults.standard
    
    let validator = Validator()
    let popupController = PopupController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registrationButton.buttonGray()
        configueValidation()
        nameText.addTarget(self, action: #selector(lenghtCheker(textField:)), for: UIControl.Event.editingChanged)
    }
    
    
    @objc func lenghtCheker(textField : UITextField){
        if nameText.text!.count >= 1 {
            nameText.layer.borderColor = UIColor.black.cgColor
            nameText.layer.borderWidth = 1.0
            nameText.borderStyle = .roundedRect
            nameText.layer.cornerRadius = 5.0
            registrationButton.buttonGreen()
        }else{
            registrationButton.buttonGray()
            nameText.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
            nameText.layer.borderWidth = 1.0
            nameText.borderStyle = .roundedRect
            nameText.layer.cornerRadius = 5.0
        }
        
    }
    @IBAction func registrationButtonAction(_ sender: Any) {
        validator.validate(self)
    }
    func configueValidation() {
        validator.styleTransformers(success:{ (validationRule) -> Void in
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            
            if let textField = validationRule.field as? UITextField {
                textField.layer.borderColor = UIColor.lightGray.cgColor
                textField.layer.borderWidth = 0.5
                textField.layer.cornerRadius = 5.0
            } else if let textField = validationRule.field as? UITextView {
                textField.layer.borderColor = UIColor.lightGray.cgColor
                textField.layer.borderWidth = 0.5
                textField.layer.cornerRadius = 5.0
            }
        }, error:{ (validationError) -> Void in
        })
        validator.registerField(nameText,errorLabel: nameValidation, rules: [RequiredRule()])  
    }
    func transferToMainPage(){
        let vc = storyboard?.instantiateViewController(identifier: "test321") as? UITabBarController
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true, completion: nil)
        vc?.selectedIndex = 1
    }
    func successRegistrationPopup(answer: String) {
        print("tema")
    }
}

extension AddingNameController: UITextFieldDelegate, ValidationDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func validationSuccessful() {
        guard let phone = userDefault.string(forKey: "phoneNumber") else { return }
        guard let typeOfUser = Int(userDefault.string(forKey: "typeOfUser")!) else { return }
        
        let user = RegistrationModel(name: nameText.text!, phone: phone, type: typeOfUser)
        let user2 = LoginModel(phone: phone)
        ApiController.instance.registerUser(user: user, completion: successRegistrationPopup(answer:))
        ApiController.instance.loginUser(user: user2, completion: moveToMain(answer:))
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? UITextField {
                print(error)
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
                field.borderStyle = .roundedRect
                field.layer.cornerRadius = 5.0
            }
            error.errorLabel?.text = "Заполните поле"
            error.errorLabel?.isHidden = false
            
        }
    }
    func moveToMain(answer: String) {
        if answer == "success" {
            transferToMainPage()
        }else{
            print("net")
        }
    }
    
}
