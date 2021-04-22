//
//  AddNewFieldController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 11/15/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import SwiftValidator

class AddNewFieldController:UIViewController, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    private var selectedImages:[UIImage] = []
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    let validator = Validator()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var nameValidationLabel: UILabel!
    @IBOutlet weak var typeFiledValidationLabel: UILabel!
    @IBOutlet weak var imageValidationLabel: UILabel!
    @IBOutlet weak var priceValidationLabel: UILabel!
    
    @IBOutlet weak var locationValidationLabel: UILabel!
    @IBOutlet weak var maxPlayerValidationLabel: UILabel!
    @IBOutlet weak var widthValidationLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addNewField: UIButton!
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var nameOfField: UITextField!
    @IBOutlet weak var typeOfField: UITextField!
    @IBOutlet weak var descripeOfField: UITextView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var timeStart1: UITextField!
    @IBOutlet weak var timeEnd1: UITextField!
    @IBOutlet weak var monday: UITextField!
    @IBOutlet weak var maxPerson: UITextField!
    @IBOutlet weak var widthField: UITextField!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var pakingButtonYes: UIButton!
    @IBOutlet weak var roofFieldYes: UIButton!
    @IBOutlet weak var pakingButtonNo: UIButton!
    @IBOutlet weak var roofFieldNo: UIButton!
    @IBOutlet weak var shower: UIButton!
    @IBOutlet weak var razdevalka: UIButton!
    @IBOutlet weak var osvewenie: UIButton!
    @IBOutlet weak var trubuni: UIButton!
    @IBOutlet weak var inventar: UIButton!
    
    @IBOutlet weak var MnStart: UITextField!
    @IBOutlet weak var MnEnd: UITextField!
    @IBOutlet weak var TuStart: UITextField!
    @IBOutlet weak var TuEnd: UITextField!
    @IBOutlet weak var WnStart: UITextField!
    @IBOutlet weak var WnEnd: UITextField!
    @IBOutlet weak var ThStart: UITextField!
    @IBOutlet weak var ThEnd: UITextField!
    @IBOutlet weak var FrStart: UITextField!
    @IBOutlet weak var FrEnd: UITextField!
    @IBOutlet weak var SaStart: UITextField!
    @IBOutlet weak var SaEnd: UITextField!
    @IBOutlet weak var SnStart: UITextField!
    @IBOutlet weak var SnEnd: UITextField!
    var placeholderLabel : UILabel!
    
    var category: [Category] = []
    var focusedTextField: UITextField!
    var timePicker = UIDatePicker()
    
    var pickerView = UIPickerView()
    var categoryId:Int?
    var hasParking = false
    var hasRoof = false
    var hasShower = false
    var hasRazdevalka = false
    var hasOsvewenie = false
    var hasTrubuni = false
    var hasInventar = false
    var idBek:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        design()
        self.hideKeyboardWhenTappedAround()
        configueValidation()
        
        timePicker.datePickerMode = .time
        
        ApiController.instance.category(completion: categoryShow)
        pickerView.delegate = self
        pickerView.dataSource = self
        
        phoneNumber.text = DataManager.sharedInstance.getCredentials().phoneNumber
        typeOfField.inputView = pickerView
        nameOfField.addTarget(self, action: #selector(lenghtCheker(textField:)), for: UIControl.Event.editingChanged)
        typeOfField.addTarget(self, action: #selector(lenghtCheker2(textField:)), for: UIControl.Event.editingChanged)
        locationField.addTarget(self, action: #selector(lenghtCheker3(textField:)), for: UIControl.Event.editingChanged)
        maxPerson.addTarget(self, action: #selector(lenghtCheker4(textField:)), for: UIControl.Event.editingChanged)
        widthField.addTarget(self, action: #selector(lenghtCheker5(textField:)), for: UIControl.Event.editingChanged)
        heightField.addTarget(self, action: #selector(lenghtCheker6(textField:)), for: UIControl.Event.editingChanged)
        phoneNumber.addTarget(self, action: #selector(lenghtCheker7(textField:)), for: UIControl.Event.editingChanged)
        
        
        MnStart.addTarget(self, action: #selector(MnStart1), for: .allEvents)
        MnEnd.addTarget(self, action: #selector(MnEnd1), for: .allEvents)
        TuStart.addTarget(self, action: #selector(TuStart1), for: .allEvents)
        TuEnd.addTarget(self, action: #selector(TuEnd1), for: .allEvents)
        WnStart.addTarget(self, action: #selector(WnStart1), for: .allEvents)
        WnEnd.addTarget(self, action: #selector(WnEnd1), for: .allEvents)
        ThStart.addTarget(self, action: #selector(ThStart1), for: .allEvents)
        ThEnd.addTarget(self, action: #selector(ThEnd1), for: .allEvents)
        FrStart.addTarget(self, action: #selector(FrStart1), for: .allEvents)
        FrEnd.addTarget(self, action: #selector(FrEnd1), for: .allEvents)
        SaStart.addTarget(self, action: #selector(SaStart1), for: .allEvents)
        SaEnd.addTarget(self, action: #selector(SaEnd1), for: .allEvents)
        SnStart.addTarget(self, action: #selector(SnStart1), for: .allEvents)
        SnEnd.addTarget(self, action: #selector(SnEnd1), for: .allEvents)
        
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        button.setImage(UIImage(named: "Phone"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 18, bottom: 5, right: 5)
        phoneNumber.leftView = button
        phoneNumber.leftViewMode = .always

    }
    @objc func lenghtCheker(textField : UITextField){
        if nameOfField.text?.count == 0 {
            nameOfField.borderChangeGray()
        }else{
            nameOfField.borderChangerBlack()
        }
    }
    @objc func lenghtCheker2(textField : UITextField){
        if typeOfField.text?.count == 0 {
            typeOfField.borderChangeGray()
        }else{
            typeOfField.borderChangerBlack()
        }
    }
    @objc func lenghtCheker3(textField : UITextField){
        if locationField.text?.count == 0 {
            locationField.borderChangeGray()
        }else{
            locationField.borderChangerBlack()
        }
    }
    @objc func lenghtCheker4(textField : UITextField){
        if maxPerson.text?.count == 0 {
            maxPerson.borderChangeGray()
        }else{
            maxPerson.borderChangerBlack()
        }
    }
    @objc func lenghtCheker5(textField : UITextField){
        if widthField.text?.count == 0 {
            widthField.borderChangeGray()
        }else{
            widthField.borderChangerBlack()
        }
    }
    @objc func lenghtCheker6(textField : UITextField){
        if heightField.text?.count == 0 {
            heightField.borderChangeGray()
        }else{
            heightField.borderChangerBlack()
        }
    }
    @objc func lenghtCheker7(textField : UITextField){
        if phoneNumber.text?.count == 0 {
            phoneNumber.borderChangeGray()
        }else{
            phoneNumber.borderChangerBlack()
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    func categoryShow(info:[Category]){
        for i in info{
            category.append(i)
        }
    }
    func design(){
        textView.layer.borderWidth = 1
        textView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        textView.layer.cornerRadius = 6
        textView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Описание"
        placeholderLabel.font = UIFont.systemFont(ofSize: (textView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textView.text.isEmpty
        addImageButton.buttonBorderGreen()
        cancelButton.buttonBorderGreen()
        addNewField.buttonGreen()
    }
    @IBAction func parkingAction(_ sender: UIButton) {
        if sender.tag == 1{
            pakingButtonYes.isSelected = true
            pakingButtonNo.isSelected = false
            hasParking = true
        }else if sender.tag == 2{
            pakingButtonYes.isSelected = false
            pakingButtonNo.isSelected = true
            hasParking = false
        }
    }
    @IBAction func roofField(_ sender: UIButton) {
        if sender.tag == 1{
            roofFieldYes.isSelected = true
            roofFieldNo.isSelected = false
            hasRoof = true
        }else if sender.tag == 2{
            roofFieldYes.isSelected = false
            roofFieldNo.isSelected = true
            hasRoof = false
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
    
    @IBAction func lockerRoom(_ sender: UIButton) {
        if (sender.isSelected == true){
            razdevalka.isSelected = false
            hasRazdevalka = false
        }else{
            razdevalka.isSelected = true
            hasRazdevalka = true
        }
    }
    
    @IBAction func lightAction(_ sender: UIButton) {
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
    
    @IBAction func addPhotoAction(_ sender: Any) {
        let imagePicker = ImagePickerController()
        
        presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: { (assets) in
            // User finished selection assets.
            
            self.selectedImages = []
            let options: PHImageRequestOptions = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            for asset in assets {
                PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options){ (image,info) in
                    self.selectedImages.append(image!)
                    self.collectionView.reloadData()
                    
                }
            }
        })
    }
    
    @IBAction func addFieldAction(_ sender: Any) {
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
        validator.registerField(nameOfField,errorLabel: nameValidationLabel, rules: [RequiredRule()])
        validator.registerField(typeOfField, errorLabel: typeFiledValidationLabel , rules: [RequiredRule()])
        validator.registerField(priceTextField, errorLabel: priceValidationLabel , rules: [RequiredRule()])
        validator.registerField(locationField, errorLabel: locationValidationLabel , rules: [RequiredRule()])
        validator.registerField(maxPerson, errorLabel: maxPlayerValidationLabel , rules: [RequiredRule()])
        validator.registerField(widthField, errorLabel: widthValidationLabel , rules: [RequiredRule()])
        validator.registerField(heightField, errorLabel: widthValidationLabel , rules: [RequiredRule()])
    }
    func takeId(info:idTaker){
        idBek = Int(info.id.description)
        timeAdd(id:idBek!)
    }
    func timeAdd(id:Int){
        var test = ["Mn":[MnStart?.text,MnEnd?.text],"Tu":[TuStart?.text,TuEnd?.text],"Wd":[WnStart?.text,WnEnd?.text],"Th":[ThStart?.text,ThEnd?.text],"Fr":[FrStart?.text,FrEnd?.text],"Sa":[SaStart?.text,SaEnd?.text],"Sn":[SnStart?.text,SnEnd?.text]]
        var test1:[TimeHoursModel] = []
        
        for (names,dates) in test{
            if dates[0] == "" || dates[1] == ""{
                test.removeValue(forKey: names)
            }else{
                let time = TimeHoursModel(day: names, start: dates[0]!, end: dates[1]!)
                test1.append(time)
            }
        }
        let info = ScheduleModel(field: id, working_hours: test1)
        ApiController.instance.addTime(data: info, completion: test123)
    }
    func test123(answer: String){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "profileID") as! MainProfileController
        profile.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(profile, animated: true)
    }
    
    @IBAction func cancelAddField(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "test321") as? UITabBarController
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
        vc?.selectedIndex = 1
    }
}
extension AddNewFieldController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(selectedImages.count)
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddFieldImage
        print(selectedImages)
        let data: UIImage = selectedImages[indexPath.item]
        cell.image.image = data
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        return CGSize(width: screenWidth - 10, height: 240)
    }
    
}

extension AddNewFieldController:UIPickerViewDataSource, UIPickerViewDelegate{
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
        typeOfField.text = category[row].name
        categoryId = category[row].id
        typeOfField.resignFirstResponder()
    }
    
}
extension UITextField{
    func borderChangerBlack(){
        if self.text!.count > 0{
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 1.0
            self.borderStyle = .roundedRect
            self.layer.cornerRadius = 5.0
        }
    }
    func borderChangeGray(){
        self.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        self.layer.borderWidth = 1.0
        self.borderStyle = .roundedRect
        self.layer.cornerRadius = 5.0
    }
    @objc func lenghtCheker(textField : UITextField){
        if self.text?.count == 0 {
            self.borderChangeGray()
        }else{
            self.borderChangerBlack()
        }
        
    }
}
extension AddNewFieldController: UITextFieldDelegate, ValidationDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func validationSuccessful() {
        let filedName = nameOfField.text
        let maxNumber = Int(maxPerson.text!)
        let minSize = Int(widthField.text!)
        let maxSize = Int(heightField.text!)
        let textDescription = descripeOfField.text ?? "пусто"
        let locationText = locationField.text!
        let info = NewFieldModule(field_type: categoryId!, name: filedName!, price: priceTextField.text!, is_approved: false, number_of_players: maxNumber!, has_parking: hasParking, is_indoor: hasRoof, has_showers: hasShower, has_locker_rooms: hasRazdevalka, has_lights: hasOsvewenie, has_rostrum: hasTrubuni, has_equipment: hasInventar, minimum_size: minSize!, maximum_size: maxSize!,description: textDescription,location: locationText,phone_number:phoneNumber.text!)
        if selectedImages.count == 0{
            selectedImages.append(UIImage(named: "noPhoto")!)
        }
        ApiController.instance.uploadImage(imagesData:selectedImages , data: info,completion: takeId(info:))
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "profileID") as! MainProfileController
        profile.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(profile, animated: true)
        
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
extension AddNewFieldController{
    
    
    
    @objc func MnStart1(textField: UITextField) {
        test(textFieldName: MnStart)
    }
    @objc func MnEnd1(textField: UITextField) {
        test(textFieldName: MnEnd)
    }
    @objc func TuStart1(textField: UITextField) {
        test(textFieldName: TuStart)
    }
    @objc func TuEnd1(textField: UITextField) {
        test(textFieldName: TuEnd)
    }
    @objc func WnStart1(textField: UITextField) {
        test(textFieldName: WnStart)
    }
    @objc func WnEnd1(textField: UITextField) {
        test(textFieldName: WnEnd)
    }
    @objc func ThStart1(textField: UITextField) {
        test(textFieldName: ThStart)
    }
    @objc func ThEnd1(textField: UITextField) {
        test(textFieldName: ThEnd)
    }
    @objc func FrStart1(textField: UITextField) {
        test(textFieldName: FrStart)
    }
    @objc func FrEnd1(textField: UITextField) {
        test(textFieldName: FrEnd)
    }
    @objc func SaStart1(textField: UITextField) {
        test(textFieldName: SaStart)
    }
    @objc func SaEnd1(textField: UITextField) {
        test(textFieldName: SaEnd)
    }
    @objc func SnStart1(textField: UITextField) {
        test(textFieldName: SnStart)
    }
    @objc func SnEnd1(textField: UITextField) {
        test(textFieldName: SnEnd)
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
        self.view.endEditing(true)
    }
}
