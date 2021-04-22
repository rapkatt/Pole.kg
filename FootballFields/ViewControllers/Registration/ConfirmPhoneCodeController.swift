//
//  ConfirmPhoneCodeController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 11/11/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SwiftValidator
import PopupDialog

class ConfirmPhoneCodeController:UIViewController{
    
    @IBOutlet weak var otpOu: UITextField!
    @IBOutlet weak var sendCode: UIButton!
    @IBOutlet weak var validationLabel: UILabel!
    
    let userDefault = UserDefaults.standard
    
    let validator = Validator()
    let popupController = PopupController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configueValidation()
        sendCode.buttonGray()
        otpOu.addTarget(self, action: #selector(lenghtCheker(textField:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func lenghtCheker(textField : UITextField){
        if otpOu.text?.count == 6 {
            otpOu.layer.borderColor = UIColor.black.cgColor
            otpOu.layer.borderWidth = 1.0
            otpOu.borderStyle = .roundedRect
            otpOu.layer.cornerRadius = 5.0
            sendCode.buttonGreen()
           
        }else{
            sendCode.buttonGray()
            otpOu.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
            otpOu.layer.borderWidth = 1.0
            otpOu.borderStyle = .roundedRect
            otpOu.layer.cornerRadius = 5.0
        }
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
        
        validator.registerField(otpOu, errorLabel: validationLabel , rules: [RequiredRule(), ExactLengthRule(length: 6, message: "В поле номер телефона должно быть 6 символов")])
    }
    
    @IBAction func sendCodeAction(_ sender: Any) {
        validator.validate(self)
    }
    
}

extension ConfirmPhoneCodeController: UITextFieldDelegate, ValidationDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func validationSuccessful() {
        guard let otpNumner = otpOu.text else { return }
        guard let verificationId = userDefault.string(forKey: "verificationId") else { return }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: otpNumner)
        Auth.auth().signIn(with: credential, completion: { [weak self](authDataResult, error) in
            if error != nil {
                self?.validationLabel.text = "Неверный код"
                self?.validationLabel.isHidden = false
            }
            
            guard let safeAuthDataResult = authDataResult else { return }
            let userId = safeAuthDataResult.user.uid
            let usersRef = Database.database().reference().child("users").child(userId)
            usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if !snapshot.exists() {
                    Database.database().reference().child("users").child(userId).setValue(["username": userId])
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "addName") as! AddingNameController
                    newViewController.modalPresentationStyle = .fullScreen
                    self?.navigationController?.pushViewController(newViewController, animated: true)
                } else {
                    let popup = self!.popupController.createAlertPopup(title: "Пользователь с таким номером уже зарегистрирован", message: "", btnTxt: "Ок")
                    self!.present(popup, animated: true, completion: nil)
                }
            })
        })
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
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.isHidden = false
            
        }
    }
    
}
