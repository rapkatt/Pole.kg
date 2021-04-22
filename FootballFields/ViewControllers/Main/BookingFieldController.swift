//
//  BookingFieldController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 17/11/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import Firebase
import SwiftValidator
import PopupDialog

class BookingFieldController:UIViewController{
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var dataPicker: UITextField!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var orderingButton: UIButton!
    @IBOutlet weak var nameValidator: UILabel!
    @IBOutlet weak var numberValidator: UILabel!
    @IBOutlet weak var dataValidator: UILabel!
    @IBOutlet weak var startTimeValidator: UILabel!
    @IBOutlet weak var endTimeValidator: UILabel!
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    let validator = Validator()
    var focusedTextField: UITextField!
    
    var dateOfBooking = ""
    var timeStartBooking = ""
    var timeEndBooking = ""
    var data:MainViewModel?
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        
       // test(textFieldName: endTime)
        configueValidation()
        let phoneNumberToShow = DataManager.sharedInstance.getCredentials().phoneNumber
        name.text = DataManager.sharedInstance.getCredentials().full_name
        phoneNumber.text = String(phoneNumberToShow.suffix(9))
        
        datePicker.datePickerMode = .date
        timePicker.datePickerMode = .time
        
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        button.setImage(UIImage(named: "Phone"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 18, bottom: 5, right: 5)
        phoneNumber.leftView = button
        phoneNumber.leftViewMode = .always
        orderingButton.buttonGreen()
        
        startTime.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
        endTime.addTarget(self, action: #selector(myTargetFunction2), for: .touchDown)
        
        
    }
    @objc func myTargetFunction(textField: UITextField) {
        test(textFieldName: startTime)
    }
    @objc func myTargetFunction2(textField: UITextField) {
        test(textFieldName: endTime)
    }
    @IBAction func bookingAction(_ sender: Any) {
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
        validator.registerField(name,errorLabel: nameValidator, rules: [RequiredRule()])
        validator.registerField(phoneNumber, errorLabel: numberValidator , rules: [RequiredRule(), ExactLengthRule(length: 9, message: "В поле номер телефона должно быть 9 символов")])
        validator.registerField(dataPicker, errorLabel: dataValidator , rules: [RequiredRule()])
        validator.registerField(startTime, errorLabel: startTimeValidator , rules: [RequiredRule()])
        validator.registerField(endTime, errorLabel: endTimeValidator , rules: [RequiredRule()])
        
    }
    
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePress))
        toolbar.setItems([doneBtn], animated: true)
        
        dataPicker.inputAccessoryView = toolbar
        dataPicker.inputView = datePicker
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        else if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
    }
    
    @objc func donePress(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dataPicker.text = formatter.string(from: datePicker.date)
        dateOfBooking = formatter.string(from: datePicker.date).description
        
        self.view.endEditing(true)
    }
    @objc func test(textFieldName:UITextField){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        focusedTextField = textFieldName
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(timeStartTest))
        toolbar.setItems([doneBtn], animated: true)

        textFieldName.inputAccessoryView = toolbar
        textFieldName.inputView = timePicker

        if #available(iOS 14.0, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }
        else if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }
    }
    @objc func timeStartTest(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        focusedTextField.text = formatter.string(from: timePicker.date)
        timeStartBooking = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }

}
extension BookingFieldController: UITextFieldDelegate, ValidationDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func validationSuccessful() {
        orderingButton.buttonGreen()
        let token = DataManager.sharedInstance.getCredentials().accessToken
        if token != ""{
            let id = data!.id!
            let data = BookingModel(field: id, booking_date: dateOfBooking, time_start: startTime.text!, time_end: endTime.text!, status: 1)
            ApiController.instance.booking(data: data, completion: cheker2(info:))
        }else{
            let title = "THIS IS THE DIALOG TITLE"
            let message = "This is the message section of the popup dialog default view"
            let popup = PopupDialog(title: title, message: message)
            let first = DefaultButton(title: "Авторизация", height: 60) {
                let vc = self.storyboard?.instantiateViewController(identifier: "login")
                vc?.modalPresentationStyle = .fullScreen
                self.present(vc!, animated: true, completion: nil)
            }

            let second = DefaultButton(title: "Регистрация", height: 60) {
                let vc = self.storyboard?.instantiateViewController(identifier: "register")
                vc?.modalPresentationStyle = .overFullScreen
                self.present(vc!, animated: true, completion: nil)
            }
            let third = DefaultButton(title: "Выйти на главный экран", height: 60) {
                let vc = self.storyboard?.instantiateViewController(identifier: "test321") as? UITabBarController
                vc?.modalPresentationStyle = .fullScreen
                self.present(vc!, animated: true, completion: nil)
                vc?.selectedIndex = 1
            }
            popup.addButtons([first, second, third])

            // Present dialog
            self.present(popup, animated: true, completion: nil)
            
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
            if error.errorMessage == "error.errorMessage"{
                error.errorLabel?.text = "Не должно быть пустым"
            }else if error.errorMessage == "В поле номер телефона должно быть 9 символов"{
                error.errorLabel?.text = "В поле номер телефона должно быть 9 символов"
            }else{
                error.errorLabel?.text = "Не должно быть пустым"
            }
            error.errorLabel?.isHidden = false
        }
    }
    func cheker2(info:String){
        if info == "Бронь прошла успешно"{
            let title = info.description
            let message = ""
            let popup = PopupDialog(title: title, message: message)
            let button = DefaultButton(title: "Выйти на главный экран", height: 60) {
                let vc = self.storyboard?.instantiateViewController(identifier: "test321") as? UITabBarController
                vc?.modalPresentationStyle = .fullScreen
                self.present(vc!, animated: true, completion: nil)
                vc?.selectedIndex = 1
            }
            popup.addButtons([button])

            // Present dialog
            self.present(popup, animated: true, completion: nil)
        }else{
            let title = info.description
            let message = ""
            let popup = PopupDialog(title: title, message: message)
            let button = DefaultButton(title: "OK", height: 60) {}
            popup.addButtons([button])

            // Present dialog
            self.present(popup, animated: true, completion: nil)
        }
    }
   
}

