//
//  InfoFieldController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 16/11/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import ImageSlideshow
import PopupDialog
import HCSStarRatingView

class InfoFieldController:UIViewController, ImageSlideshowDelegate{
    
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageRaiting: UIImageView!
    @IBOutlet weak var MondayStart: UILabel!
    @IBOutlet weak var MondayEnd: UILabel!
    @IBOutlet weak var TuesdayStart: UILabel!
    @IBOutlet weak var TuesdayEnd: UILabel!
    @IBOutlet weak var WednesdayStart: UILabel!
    @IBOutlet weak var WednesdayEnd: UILabel!
    @IBOutlet weak var ThursdayStart: UILabel!
    @IBOutlet weak var ThursdayEnd: UILabel!
    @IBOutlet weak var FridayStart: UILabel!
    @IBOutlet weak var FridayEnd: UILabel!
    @IBOutlet weak var SaturdayStart: UILabel!
    @IBOutlet weak var SaturdayEnd: UILabel!
    @IBOutlet weak var SundayStart: UILabel!
    @IBOutlet weak var SundayEnd: UILabel!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var numberOfPeople: UILabel!
    @IBOutlet weak var raitingView: HCSStarRatingView!
    
    @IBOutlet weak var SizeOfField: UILabel!
    @IBOutlet weak var parking: UILabel!
    @IBOutlet weak var indoor: UILabel!
    @IBOutlet weak var shower: UILabel!
    @IBOutlet weak var lockerRoom: UILabel!
    @IBOutlet weak var lights: UILabel!
    @IBOutlet weak var rostrum: UILabel!
    @IBOutlet weak var equipment: UILabel!
    
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var labelText: UILabel!
    
    
    @IBOutlet weak var mondayRest: UIStackView!
    @IBOutlet weak var thuesdayRest: UIStackView!
    @IBOutlet weak var wensdayRest: UIStackView!
    @IBOutlet weak var thursdayRest: UIStackView!
    @IBOutlet weak var fridayRest: UIStackView!
    @IBOutlet weak var saturdayRest: UIStackView!
    @IBOutlet weak var sundayRest: UIStackView!
    
    @IBOutlet weak var mondayStackView: UIStackView!
    @IBOutlet weak var thuesdayStackView: UIStackView!
    @IBOutlet weak var wensdayStackView: UIStackView!
    @IBOutlet weak var thursdayStackView: UIStackView!
    @IBOutlet weak var fridayStackView: UIStackView!
    @IBOutlet weak var saturdayStackView: UIStackView!
    @IBOutlet weak var sundayStackView: UIStackView!
    
    @IBOutlet weak var raspisanieImage: UIImageView!
    
    @IBOutlet weak var dopHarakteristikiImage: UIImageView!
    @IBOutlet weak var raspisnie: UIStackView!
    @IBOutlet weak var dopHarakteristiki: UIStackView!
    @IBOutlet weak var booking: UIButton!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    var data:MainViewModel?
    var imageSource: [ImageSource] = []
    var cheker = true
    var cheker2 = true
    
    func imageCollect(){
        var i = 0
        while i < data!.images!.count {
            let testImage = data!.images![i].image
            imageSource.append(ImageSource(image: getImage(from: testImage!)!))
            i += 1
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        booking.buttonGreen()
        imageCollect()
        imageShow()
        dataShow()
        
        let first = UITapGestureRecognizer(target: self, action: #selector(handleSendData))
        firstView.addGestureRecognizer(first)
        let second = UITapGestureRecognizer(target: self, action: #selector(handleSendData2))
        secondView.addGestureRecognizer(second)
    }
    
    @objc func handleSendData() {
        if cheker == true{
            let raspisanie = raspisnie.constraintWith(identifier: "raspisanie")
            raspisanie?.constant = 170
            raspisanieImage.image = UIImage(named: "arrow3")
            cheker = false
        }else{
            let raspisanie = raspisnie.constraintWith(identifier: "raspisanie")
            raspisanie?.constant = 0
            raspisanieImage.image = UIImage(named: "arrow2")
            cheker = true
        }
    }
    
    @objc func handleSendData2() {
        if cheker2 == true{
            let dopHarakteristik = dopHarakteristiki.constraintWith(identifier: "dopHarakteristiki")
            dopHarakteristik?.constant = 185
            dopHarakteristikiImage.image = UIImage(named: "arrow3")
            cheker2 = false
        }else{
            let dopHarakteristik = dopHarakteristiki.constraintWith(identifier: "dopHarakteristiki")
            dopHarakteristik?.constant = 0
            dopHarakteristikiImage.image = UIImage(named: "arrow2")
            cheker2 = true
        }
    }
    
    @IBAction func goToBooking(_ sender: Any) {
        if DataManager.sharedInstance.getCredentials().accessToken != ""{
            let info = data
            performSegue(withIdentifier: "infoSender1", sender: info)
        }else{
            let title = "Чтоб забронировать данное поле авторизуйтесь или зарегистрируйтесь"
            let message = ""
            let popup = PopupDialog(title: title, message: message)
            
            let first = DefaultButton(title: "Авторизация", height: 60) {
                let vc = self.storyboard?.instantiateViewController(identifier: "login") as! LoginNumberController
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }

            let second = DefaultButton(title: "Регистрация", height: 60) {
                let vc = self.storyboard?.instantiateViewController(identifier: "register") as! RegistrationViewController
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
       
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                let destVC = segue.destination as! BookingFieldController
                destVC.data = (sender as! MainViewModel)
    }
    
    @IBAction func callToNumberAction(_ sender: UIButton) {
        let number1 = data?.phone_number?.description ?? "+996550555444333"
        guard let number = URL(string: "tel://" + number1) else { return }
        UIApplication.shared.open(number)
        
    }
}
extension InfoFieldController{
    func imageShow(){
        slideShow.slideshowInterval = 5.0
        slideShow.pageIndicatorPosition = .init(horizontal: .center)
        slideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        slideShow.pageIndicator = pageControl
        slideShow.activityIndicator = DefaultActivityIndicator()
        slideShow.delegate = self
        slideShow.setImageInputs(imageSource)
    }
    
    func dataShow(){
        nameLabel.text = data?.name
        if data?.disable_booking == true{
            booking.isHidden = true
        }
        labelText.text = data?.description
        phoneNumber.text = data?.phone_number
        raitingView.value = CGFloat(data?.rating ?? 0.0)
        raitingView.tintColor = #colorLiteral(red: 1, green: 0.7647058824, blue: 0.1607843137, alpha: 1)
        raitingView.isUserInteractionEnabled = false
        mondayStackView.isHidden = true
        thuesdayStackView.isHidden = true
        wensdayStackView.isHidden = true
        thursdayStackView.isHidden = true
        fridayStackView.isHidden = true
        saturdayStackView.isHidden = true
        sundayStackView.isHidden = true

        for i in 0..<(data?.working_hours?.count ?? 6)  {
            if data?.working_hours![i].day == "Понедельник" {
                MondayStart.text = data?.working_hours?[i].start?.description
                MondayEnd.text = data?.working_hours?[i].end?.description
                mondayStackView.isHidden = false
                mondayRest.isHidden = true
            }
            if data?.working_hours![i].day == "Вторник" {
                TuesdayStart.text = data?.working_hours?[i].start?.description
                TuesdayEnd.text = data?.working_hours?[i].end?.description
                thuesdayStackView.isHidden = false
                thuesdayRest.isHidden = true
            }
            if data?.working_hours![i].day == "Среда" {
                WednesdayStart.text = data?.working_hours?[i].start?.description
                WednesdayEnd.text = data?.working_hours?[i].end?.description
                wensdayRest.isHidden = true
                wensdayStackView.isHidden = false
            }
            if data?.working_hours![i].day == "Четверг" {
                ThursdayStart.text = data?.working_hours?[i].start?.description
                ThursdayEnd.text = data?.working_hours?[i].end?.description
                thursdayRest.isHidden = true
                thursdayStackView.isHidden = false
            }
            if data?.working_hours![i].day == "Пятница" {
                FridayStart.text = data?.working_hours?[i].start?.description
                FridayEnd.text = data?.working_hours?[i].end?.description
                fridayRest.isHidden = true
                fridayStackView.isHidden = false
            }
            if data?.working_hours![i].day == "Суббота" {
                SaturdayStart.text = data?.working_hours?[i].start?.description
                SaturdayEnd.text = data?.working_hours?[i].end?.description
                saturdayRest.isHidden = true
                saturdayStackView.isHidden = false
            }
            if data?.working_hours![i].day == "Воскресенье" {
                SundayStart.text = data?.working_hours?[i].start?.description
                SundayEnd.text = data?.working_hours?[i].end?.description
                sundayRest.isHidden = true
                sundayStackView.isHidden = false
            }
        }
        let info = Float(data?.price ?? "0.0")
        price.text = info!.clean + " сом"
        location.text = data?.location?.description
        numberOfPeople.text = data?.number_of_players?.description

        
        
        
        if data?.has_parking == true {
            parking.text = "есть"
        }else{
            parking.text = "нет"
        }
        if data?.is_indoor == true {
            indoor.text = "есть"
        }else{
            indoor.text = "нет"
        }
        if data?.has_showers == true {
            shower.text = "есть"
        }else{
            shower.text = "нет"
        }
        if data?.has_locker_rooms == true {
            lockerRoom.text = "есть"
        }else{
            lockerRoom.text = "нет"
        }
        if data?.has_lights == true {
            lights.text = "есть"
        }else{
            lights.text = "нет"
        }
        if data?.has_rostrum == true {
            rostrum.text = "есть"
        }else{
            rostrum.text = "нет"
        }
        if data?.has_equipment == true {
            equipment.text = "есть"
        }else{
            equipment.text = "нет"
        }
        
        SizeOfField.text = data!.minimum_size!.description + "x" + data!.maximum_size!.description
    }
    
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
extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
