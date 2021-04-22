//
//  EditProfileController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 9/12/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

class EditProfileController:UIViewController, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    private var selectedImages:[UIImage] = []
    var imagesShow:[Images] = []
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addNewField: UIButton!
    
    @IBOutlet weak var nameOfField: UITextField!
    @IBOutlet weak var typeOfField: UITextField!
    @IBOutlet weak var descripeOfField: UITextView!
    @IBOutlet weak var locationField: UITextField!
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
    @IBOutlet weak var disableBooking: UIButton!
    @IBOutlet weak var hiddenField: UIButton!
    
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
    var focusedTextField: UITextField!
    var timePicker = UIDatePicker()
    
    var category: [Category] = []
    var pickerView = UIPickerView()
    var data:MyFieldModule?
    var categoryId:Int?
    var hasParking:Bool?
    var hasRoof:Bool?
    var hasShower:Bool?
    var hasRazdevalka:Bool?
    var hasOsvewenie:Bool?
    var hasTrubuni:Bool?
    var hasInventar:Bool?
    var disableBooking1:Bool?
    var hiddenField1:Bool?
    var idBek:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        ApiController.instance.category(completion: categoryShow)
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        typeOfField.inputView = pickerView
        timePicker.datePickerMode = .time
        
        for i in data!.images{
            let data = getImage(from: i.image)
            selectedImages.append(data!)
        }
        
        nameOfField.text = data?.name
        typeOfField.text = data?.field_type.description
        widthField.text = data?.minimum_size.description
        heightField.text = data?.maximum_size.description
        locationField.text = data?.location.description
        descripeOfField.text = data?.description.description
        maxPerson.text = data?.number_of_players.description
        hasParking = data?.has_parking
        hasRoof = data?.is_indoor
        hasShower = data?.has_showers
        hasRazdevalka = data?.has_locker_rooms
        hasOsvewenie = data?.has_lights
        hasTrubuni = data?.has_rostrum
        hasInventar = data?.has_equipment
        disableBooking1 = data?.disable_booking
        hiddenField1 = data?.is_hidden
        phoneNumber.text = DataManager.sharedInstance.getCredentials().phoneNumber
        
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

        for day in data!.working_hours{
            if day.day == "Понедельник"{
                MnStart.text = day.start
                MnEnd.text = day.end
            }
            if day.day == "Вторник"{
                TuStart.text = day.start
                TuEnd.text = day.end
            }
            if day.day == "Среда"{
                WnStart.text = day.start
                WnEnd.text = day.end
            }
            if day.day == "Четверг"{
                ThStart.text = day.start
                ThEnd.text = day.end
            }
            if day.day == "Пятница"{
                FrStart.text = day.start
                FrEnd.text = day.end
            }
            if day.day == "Суббота"{
                SaStart.text = day.start
                SaEnd.text = day.end
            }
            if day.day == "Воскресенье"{
                SnStart.text = day.start
                SnEnd.text = day.end
            }
            
        }
        if data?.has_parking == true {
            pakingButtonYes.isSelected = true
        }else{
            pakingButtonNo.isSelected = false
        }
        if data?.is_indoor == true {
            roofFieldYes.isSelected = true
        }else{
            roofFieldNo.isSelected = false
        }
        if data?.has_showers == true {
            shower.isSelected = true
        }else{
            shower.isSelected = false
        }
        if data?.has_locker_rooms == true {
            razdevalka.isSelected = true
        }else{
            razdevalka.isSelected = false
        }
        if data?.has_lights == true {
            osvewenie.isSelected = true
        }else{
            osvewenie.isSelected = false
        }
        if data?.has_rostrum == true {
            trubuni.isSelected = true
        }else{
            trubuni.isSelected = false
        }
        if data?.has_equipment == true {
            inventar.isSelected = true
        }else{
            inventar.isSelected = false
        }
        if data?.disable_booking == true{
            disableBooking.isSelected = true
        }else{
            disableBooking.isSelected = false
        }
        
        
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        button.setImage(UIImage(named: "Phone"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 18, bottom: 5, right: 5)
        phoneNumber.leftView = button
        phoneNumber.leftViewMode = .always
        
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
    func categoryShow(info:[Category]){
        for i in info{
            category.append(i)
        }
        typeOfField.text = category[categoryId! - 1].name
        
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
    @IBAction func disableBooking(_ sender:UIButton){
        if (sender.isSelected == true){
            disableBooking.isSelected = false
            disableBooking1 = false
        }else{
            disableBooking.isSelected = true
            disableBooking1 = true
        }
    }
    @IBAction func hiddenField(_ sender:UIButton){
        if (sender.isSelected == true){
            hiddenField.isSelected = false
            hiddenField1 = false
        }else{
            hiddenField.isSelected = true
            hiddenField1 = true
        }
    }

    @IBAction func addImage(_ sender: Any) {
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
                    print(self.selectedImages.count)
                    self.collectionView.reloadData()
                    
                }
            }
        })
    }
    
    @IBAction func addChanges(_ sender: Any) {
        let id = data?.id.description
        let images = selectedImages
        let data = MyFieldModule(id: self.data!.id, field_type: categoryId!, owner: self.data!.owner, phone_number: "+996555444333", price: self.data?.price ?? "0", description: textView.text ?? "нет текста", location: locationField.text ?? "локация не указана", number_of_players: Int(maxPerson.text ?? "100")! , has_parking: hasParking!, is_indoor: hasRoof!, has_showers: hasShower!, has_locker_rooms: hasRazdevalka!, has_lights: hasOsvewenie!, has_rostrum: hasTrubuni!, has_equipment: hasInventar!, minimum_size: Int(widthField.text ?? "0")!, maximum_size:Int(heightField.text ?? "0")!,is_approved: false, name: (nameOfField.text  ?? self.data?.name)!,disable_booking:disableBooking1!,is_hidden:hiddenField1!)
        ApiController.instance.fieldEdit(id: id!, imagesData: images, data: data, completion: takeId(info:))
       
    }
    func takeId(info:idTaker){
        idBek = Int(info.id.description)
       // print(idBek)
        timeAdd(id:idBek!)
    }
    func timeAdd(id:Int){
        var test = ["Mn":[MnStart.text,MnEnd.text],"Tu":[TuStart.text,TuEnd.text],"Wd":[WnStart.text,WnEnd.text],"Th":[ThStart.text,ThEnd.text],"Fr":[FrStart.text,FrEnd.text],"Sa":[SaStart.text,SaEnd.text],"Sn":[SnStart.text,SnEnd.text]]
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
       // print(info)
        ApiController.instance.editTimePut(fieldid: id.description, data: info, completion: test123)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "profileID") as! MainProfileController
        profile.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(profile, animated: true)
    }
    func test123(answer: String){
        print("success")
    }
}
extension EditProfileController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
extension EditProfileController:UIPickerViewDataSource,UIPickerViewDelegate{
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
extension EditProfileController{
    func getImage(from string: String) -> UIImage? {
        guard let url = URL(string: string)
        else {
            return nil
        }
        
        var image: UIImage? = nil
        do {
            let data = try Data(contentsOf: url, options: [])
            image = UIImage(data: data)
        }
        catch {
            print(error.localizedDescription)
        }
        
        return image
    }
}
extension EditProfileController{

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
