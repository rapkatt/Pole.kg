//
//  MainViewController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 18/11/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import SideMenu
import PopupDialog
import HCSStarRatingView

class MainProfileController:UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, UITextViewDelegate{
    
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet weak var raitingView: HCSStarRatingView!
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var popupText: UITextView!
    @IBOutlet weak var popupButton: UIButton!
    
    var menu:SideMenuNavigationController?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var exitButton: UIBarButtonItem!
    var placeholderLabel : UILabel!
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var bookingHistory : [BookingHistoryModule] = []
    var indexSaver = 0
    var ads : MainViewModel?
    
    let myRefreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.allowsMultipleSelection = true
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        self.hideKeyboardWhenTappedAround()
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        let person = DataManager.sharedInstance.getCredentials().accessToken
        if person == ""{
            let vc = storyboard?.instantiateViewController(identifier: "registration") as? UINavigationController
            vc?.modalPresentationStyle = .fullScreen
            present(vc!, animated: true, completion: nil)
        }
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth, height: screenHeight/5)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        collectionView!.collectionViewLayout = layout
        collectionView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        collectionView.refreshControl = myRefreshControl
        ApiController.instance.bookingHistory(completion: bookingHistoryShow(info:))
        
        popupText.layer.borderWidth = 1
        popupText.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        popupText.layer.cornerRadius = 6
        popupText.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Описание"
        placeholderLabel.font = UIFont.systemFont(ofSize: (popupText.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        popupText.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (popupText.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !popupText.text.isEmpty
        
        blurView.bounds = self.view.bounds
        popupView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width*0.8, height: self.view.bounds.height*0.3)
        popupView.layer.cornerRadius = 5
        popupButton.buttonGreen()
    }
    @objc private func refresh(sender:UIRefreshControl){
        ApiController.instance.bookingHistory(completion: bookingHistoryShow(info:))
        sender.endRefreshing()
    }
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    
    @IBAction func exitButtonAction(_ sender: Any) {
        let title = ""
        let message = "Вы действительно хотите выйти?"
        let popup = PopupDialog(title: title, message: message)
        let first = DefaultButton(title: "Да", height: 60) {
            DataManager.sharedInstance.deleteUser()
            let vc = self.storyboard?.instantiateViewController(identifier: "test321") as? UITabBarController
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true, completion: nil)
            vc?.selectedIndex = 1
        }
        
        let cancel = CancelButton(title: "Нет") {
            print("")
        }
        popup.addButtons([first, cancel])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    func bookingHistoryShow(info:[BookingHistoryModule]){
        bookingHistory = []
        for i in info{
            if (i.status == "Открыто" || i.status == "Одобрено") && (i.is_finished == false && i.feedback_given == false){
                bookingHistory.append(i)
                collectionView.reloadData()
            }
            
        }
    }
    @IBAction func didTapMenu(){
        present(menu!,animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookingHistory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProfileCell
        if let url = URL( string:bookingHistory[indexPath.row].image )
        {
            DispatchQueue.global().async {
                if let data = try? Data( contentsOf:url)
                {
                    DispatchQueue.main.async {
                        cell.image.image = UIImage( data:data)
                    }
                }
            }
        }
        //cell.image.image = getImage(from: base64 )
        cell.name.text = bookingHistory[indexPath.row].field.name.description
        cell.date.text = bookingHistory[indexPath.row].booking_date
        cell.startTime.text = bookingHistory[indexPath.row].time_start
        cell.timeEnd.text = bookingHistory[indexPath.row].time_end
        cell.buttonClick.buttonBorderGreen()
        cell.cellDelegate = self
        cell.index = indexPath
        if bookingHistory[indexPath.row].is_finished == true{
            cell.buttonClick.setTitle("Отставить отзыв", for: .normal)
        }else{
            cell.buttonClick.setTitle("Отменить бронь", for: .normal)
        }
        
        cell.viewForShadow.layer.backgroundColor = UIColor.white.cgColor
        cell.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        cell.viewForShadow.layer.cornerRadius = 3
        cell.viewForShadow.layer.masksToBounds = false
        cell.viewForShadow.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cell.viewForShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.viewForShadow.layer.shadowOpacity = 0.8
        let first = UITapGestureRecognizer(target: self, action: #selector(handleSendData(sender:)))
        cell.viewForShadow.addGestureRecognizer(first)
        
        
        
        return cell
    }
    @objc func handleSendData(sender:UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.collectionView)
        let indexPath:NSIndexPath = self.collectionView.indexPathForItem(at: tapLocation)! as NSIndexPath
        let filedId = bookingHistory[indexPath.row].field.id.description
        ApiController.instance.getFieldById(id: filedId, completion: adsShow(info:))
       
        
    }
    func adsShow(info:MainViewModel){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let infoScreen = storyBoard.instantiateViewController(withIdentifier: "blablabal") as! InfoFieldOrReviewController
        infoScreen.data = info
       
        infoScreen.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(infoScreen, animated: true)
    }
    func animateScaleIn(desiredView: UIView) {
        let backgroundView = self.view!
        backgroundView.addSubview(desiredView)
        desiredView.center = backgroundView.center
        desiredView.isHidden = false
        
        desiredView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        desiredView.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
        }
    }
    
    func animateScaleOut(desiredView: UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            desiredView.alpha = 0
        }, completion: { (success: Bool) in
            desiredView.removeFromSuperview()
        })
        
        UIView.animate(withDuration: 0.2, animations: {
            
        }, completion: { _ in
            
        })
    }

    @IBAction func popupExitButtonAction(_ sender: Any) {
        animateScaleOut(desiredView: popupView)
        animateScaleOut(desiredView: blurView)
    }
    
    
    @IBAction func popupButtonAction(_ sender: Any) {
        let userId = bookingHistory[indexSaver].user.id
        let fieldId = bookingHistory[indexSaver].id
       // let test = bookingHistory[indexSaver].id
      //  print()
        print(fieldId)
        let textpopUp = popupText.text ?? ""
        let raiting = raitingView.value
        
        let data = RaitingModule(field: fieldId, user: userId, rate: Double(Int(raiting)), description: textpopUp)
        ApiController.instance.raitingSender(data: data, completion: successChangePopup(answer:))
        animateScaleOut(desiredView: popupView)
        animateScaleOut(desiredView: blurView)
    }
    func successChangePopup(answer: String) {
        if answer == "success"{
//            let id = bookingHistory[indexSaver].id.description
//            bookingHistory.remove(at: indexSaver)
//            ApiController.instance.deleteBookingById(id: id, completion: successDeletePopup(answer:))
            collectionView.reloadData()
        }else{
            print("tema")
        }
    }
    
}
extension MainProfileController{
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
extension MainProfileController:DeleteBooking{
    func onClickDelete(index: Int) {
        indexSaver = index
        if bookingHistory[index].is_finished == true {
            animateScaleIn(desiredView: blurView)
            animateScaleIn(desiredView: popupView)
        }else{
            let id = bookingHistory[index].id.description
            let fieldId = Int(bookingHistory[index].field.id)
            print(fieldId)
            bookingHistory.remove(at: index)
            let parameters = ChandgeStatusModule(field: fieldId, status:3)
            // ApiController.instance.deleteBookingById(id: id, completion: successDeletePopup(answer:))
            ApiController.instance.changeStatusBooking(id: id, parameters: parameters, completion: successDeletePopup(answer:))
            collectionView.reloadData()
        }
    }
    func successDeletePopup(answer: String) {
        if answer == "success"{
            print("success")
        }else{
            print("tema")
        }
    }
    
    
}
