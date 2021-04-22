//
//  ChangePersonalDataController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 26/11/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import SwiftValidator

class ChangePersonalDataController:UIViewController{
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var validationLabel: UILabel!
    
    let validator = Validator()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configueValidation()
        button.buttonGray()
        name.text = DataManager.sharedInstance.getCredentials().full_name
        name.addTarget(self, action: #selector(lenghtCheker(textField:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func lenghtCheker(textField : UITextField){
        if name.text!.count > 0 {
            name.layer.borderColor = UIColor.black.cgColor
            name.layer.borderWidth = 1.0
            name.borderStyle = .roundedRect
            name.layer.cornerRadius = 5.0
            button.buttonGreen()
            
        }else{
            button.buttonGray()
            name.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
            name.layer.borderWidth = 1.0
            name.borderStyle = .roundedRect
            name.layer.cornerRadius = 5.0
        }
        
    }
    @IBAction func changeNameAction(_ sender: Any) {
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
        validator.registerField(name, errorLabel: validationLabel , rules: [RequiredRule()])
    }
    
    func successChangePopup(answer: String) {
        if answer == "success"{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "profileID") as! MainProfileController
            profile.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(profile, animated: true)
        }else{
            print("tema")
        }
    }
}
extension ChangePersonalDataController: UITextFieldDelegate, ValidationDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func validationSuccessful() {
        let data = UserModel(full_name: name.text!)
        ApiController.instance.changeName(parameters: data, completion: successChangePopup(answer:))
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
            error.errorLabel?.text = "Поле не должно быть пустым"
            error.errorLabel?.isHidden = false
        }
    }
    
}
