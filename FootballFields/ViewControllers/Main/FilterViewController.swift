//
//  FilterViewController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 11/3/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit

class FilterViewController:UIViewController {
    
    @IBOutlet weak var mostPopularBtn: UIButton!
    @IBOutlet weak var bestReviewBtn: UIButton!
    @IBOutlet weak var pakingButton: UIButton!
    @IBOutlet weak var categoryShow: UITextField!
    @IBOutlet weak var dayText: UITextField!
    
    @IBOutlet weak var minPrice: UITextField!
    @IBOutlet weak var maxPrice: UITextField!
    @IBOutlet weak var minPeople: UITextField!
    @IBOutlet weak var maxPeople: UITextField!
    @IBOutlet weak var timeStart: UITextField!
    @IBOutlet weak var timeEnd: UITextField!
    
    @IBOutlet weak var yesOutlet: UIButton!
    @IBOutlet weak var noOutlet: UIButton!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var shower: UIButton!
    @IBOutlet weak var razdevalka: UIButton!
    @IBOutlet weak var osvewenie: UIButton!
    @IBOutlet weak var trubuni: UIButton!
    @IBOutlet weak var inventar: UIButton!
    
    var category: [Category] = []
    
    var categoryForSend:String?
    var min_price,max_price: String?
    var min_players,max_players: Int?
    var hasParking:Bool?
    var hasShower:Bool?
    var hasRazdevalka:Bool?
    var hasOsvewenie:Bool?
    var hasTrubuni:Bool?
    var hasInventar:Bool?
    var typeofField:Bool?
    var date: String?
    var ordering:String?
    
    var pickerView = UIPickerView()
    var datePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        acceptButton.layer.cornerRadius = 6
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        datePicker.datePickerMode = .date
        categoryShow.inputView = pickerView
        
        ApiController.instance.category(completion: categoryShow)
    }
    
    func categoryShow(info:[Category]){
        for i in info{
            category.append(i)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePress))
        toolbar.setItems([doneBtn], animated: true)
        
        dayText.inputAccessoryView = toolbar
        dayText.inputView = datePicker
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
        dayText.text = formatter.string(from: datePicker.date)
        date = formatter.string(from: datePicker.date).description
        
        self.view.endEditing(true)
    }
    
    @IBAction func raitingRadioBtn(_ sender: UIButton) {
        if sender.tag == 1{
            mostPopularBtn.isSelected = true
            bestReviewBtn.isSelected = false
            ordering = "-number_of_bookings"
        }else if sender.tag == 2{
            
            mostPopularBtn.isSelected = false
            bestReviewBtn.isSelected = true
            ordering = "-rating"
        }
    }
    
    @IBAction func typeOfFieldAction(_ sender: UIButton) {
        if sender.tag == 3{
            yesOutlet.isSelected = true
            noOutlet.isSelected = false
            typeofField = true
        }else if sender.tag == 4{
            yesOutlet.isSelected = false
            noOutlet.isSelected = true
            typeofField = false
        }
    }
    
    @IBAction func parkingButtonAction(_ sender: UIButton) {
        if (sender.isSelected == true){
            pakingButton.isSelected = false
            hasParking = false
        }else{
            pakingButton.isSelected = true
            hasParking = true
        }
    }
    @IBAction func showerAction(_ sender: UIButton) {
        if (sender.isSelected == true){
            shower.isSelected = false
            hasShower = false
        }else{
            shower.isSelected = true
            hasShower = true
        }
    }
    
    @IBAction func razdevalkaAction(_ sender: UIButton) {
        if (sender.isSelected == true){
            razdevalka.isSelected = false
            hasRazdevalka = false
        }else{
            razdevalka.isSelected = true
            hasRazdevalka = true
        }
    }
    @IBAction func osvewenieAction(_ sender: UIButton) {
        if (sender.isSelected == true){
            osvewenie.isSelected = false
            hasOsvewenie = false
        }else{
            osvewenie.isSelected = true
            hasOsvewenie = true
        }
    }
    @IBAction func tribuniAction(_ sender: UIButton) {
        if (sender.isSelected == true){
            trubuni.isSelected = false
            hasTrubuni = false
        }else{
            trubuni.isSelected = true
            hasTrubuni = true
        }
    }
    @IBAction func inventarAction(_ sender: UIButton) {
        if (sender.isSelected == true){
            inventar.isSelected = false
            hasInventar = false
        }else{
            inventar.isSelected = true
            hasInventar = true
        }
    }
    @IBAction func cleanAll(_ sender: Any) {
        categoryShow.text = ""
        minPrice.text = ""
        maxPrice.text = ""
        minPeople.text = ""
        maxPeople.text = ""
        timeStart.text = ""
        timeEnd.text = ""
        dayText.text = ""
        shower.isSelected = false
        acceptButton.isSelected = false
        razdevalka.isSelected = false
        osvewenie.isSelected = false
        trubuni.isSelected = false
        inventar.isSelected = false
        pakingButton.isSelected = false
        mostPopularBtn.isSelected = false
        bestReviewBtn.isSelected = false
        yesOutlet.isSelected = false
        noOutlet.isSelected = false
    }
    @IBAction func InfoSendAction(_ sender: Any) {
        
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoSender"{
            let destVC = segue.destination as! FiltrationResultController
            destVC.categoryForSend2 = categoryForSend
            destVC.min_price2 = Int(minPrice.text ?? "0")
            destVC.max_price2 = Int(maxPrice.text ?? "100000")
            destVC.min_players2 = Int(minPeople.text ?? "0")
            destVC.max_players2 = Int(maxPeople.text ?? "1000")
            destVC.time_start2 = timeStart.text
            destVC.time_end2 = timeEnd.text
            destVC.hasParking2 = hasParking
            destVC.date2 = date
            destVC.hasIndoor = typeofField
            destVC.hasShower2 = hasShower
            destVC.hasRazdevalka2 = hasRazdevalka
            destVC.hasOsvewenie2 = hasOsvewenie
            destVC.hasTrubuni2 = hasTrubuni
            destVC.hasInventar2 = hasInventar
            destVC.ordering2 = ordering
        }
    }
    
}

extension FilterViewController:UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryShow.text = category[row].name
        categoryForSend = category[row].id?.description
        categoryShow.resignFirstResponder()
    }
    
}

