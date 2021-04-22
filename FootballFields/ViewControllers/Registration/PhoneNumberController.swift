//
//  LoginViewController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 11/10/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import Firebase
import SwiftValidator
import PopupDialog

class PhoneNumberController:UIViewController{
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var sendCode: UIButton!
    
    @IBOutlet weak var validationLabel: UILabel!
    
    let userDefault = UserDefaults.standard
    
    var infoOfType:Int?
    
    let validator = Validator()
    let popupController = PopupController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configueValidation()
        
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        button.setImage(UIImage(named: "Phone"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 18, bottom: 5, right: 5)
        phoneNumber.leftView = button
        phoneNumber.leftViewMode = .always
        
        sendCode.buttonGray()
        phoneNumber.addTarget(self, action: #selector(lenghtCheker(textField:)), for: UIControl.Event.editingChanged)
    }
    @objc func lenghtCheker(textField : UITextField){
        if phoneNumber.text?.count == 9 {
            phoneNumber.layer.borderColor = UIColor.black.cgColor
            phoneNumber.layer.borderWidth = 1.0
            phoneNumber.borderStyle = .roundedRect
            phoneNumber.layer.cornerRadius = 5.0
            sendCode.buttonGreen()
            
        }else{
            sendCode.buttonGray()
            phoneNumber.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
            phoneNumber.layer.borderWidth = 1.0
            phoneNumber.borderStyle = .roundedRect
            phoneNumber.layer.cornerRadius = 5.0
        }
        
    }
    
    @IBAction func sendCode(_ sender: Any) {
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
        validator.registerField(phoneNumber, errorLabel: validationLabel , rules: [RequiredRule(), ExactLengthRule(length: 9, message: "В поле номер телефона должно быть 9 символов")])
    }
}

extension PhoneNumberController: UITextFieldDelegate, ValidationDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func validationSuccessful() {
        let phoneNumber = "+996" + self.phoneNumber.text!
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [self] (verificationId, error) in
            if error == nil{
                guard let verifyId = verificationId else{ return }
                self.userDefault.set(verifyId, forKey: "verificationId")
                self.userDefault.set(phoneNumber,forKey: "phoneNumber")
                self.userDefault.set(self.infoOfType,forKey: "typeOfUser")
                self.userDefault.synchronize()
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "confirmCode") as! ConfirmPhoneCodeController
                newViewController.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else{
                print("error",error?.localizedDescription as Any)
            }
        }
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        print("not valid")
        for (field, error) in errors {
            if let field = field as? UITextField {
                print(error)
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
                field.borderStyle = .roundedRect
                field.layer.cornerRadius = 5.0
            }
            error.errorLabel?.text = error.errorMessage 
            error.errorLabel?.isHidden = false
        }
    }
    
}
