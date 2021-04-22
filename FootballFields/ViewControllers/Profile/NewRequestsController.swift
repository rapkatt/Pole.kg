//
//  NewRequestsController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 29/11/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import HCSStarRatingView
import PopupDialog

class NewRequestsController:UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var popupRaitingView: UIView!
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var blackList: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteAllRequestButton: UIButton!
    
    
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var indexSaver:Int?
    var addBlackList = ""
    var delete = ""
    var deleteAll = ""
    
    let myRefreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    var openRequestes : [RequestsModule] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth, height: 316)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        collectionView!.collectionViewLayout = layout
        collectionView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        blurView.bounds = self.view.bounds
        popupView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width*0.8, height: self.view.bounds.height*0.3)
        popupView.layer.cornerRadius = 5
        collectionView.refreshControl = myRefreshControl
        ApiController.instance.requests(status: "1", completion: dataColector(info:))
        
    }
    @objc private func refresh(sender:UIRefreshControl){
        
        ApiController.instance.requests(status: "1", completion: dataColector(info:))
        sender.endRefreshing()
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
            //            desiredView.transform = CGAffineTransform.identity
        }
    }
    
    /// Animates a view to scale out remove from the display
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
    func dataColector(info:[RequestsModule]){
        openRequestes = []
        for i in info{
            openRequestes.append(i)
            collectionView.reloadData()
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return openRequestes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewRequestCell
        cell.name.text = openRequestes[indexPath.row].user.full_name
        cell.phoneNumber.text = openRequestes[indexPath.row].user.phone_number
        cell.fieldName.text = openRequestes[indexPath.row].field.name
        cell.date.text = openRequestes[indexPath.row].booking_date
        cell.timeStart.text = openRequestes[indexPath.row].time_start
        cell.timeEnd.text = openRequestes[indexPath.row].time_end
        
        cell.cellDelegate = self
        cell.index = indexPath
        
        cell.acceptBtn.buttonGreen()
        cell.cancelBtn.buttonBorderGreen()
        
        cell.viewForShadow.layer.backgroundColor = UIColor.white.cgColor
        cell.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        cell.viewForShadow.layer.cornerRadius = 3
        cell.viewForShadow.layer.masksToBounds = false
        cell.viewForShadow.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cell.viewForShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.viewForShadow.layer.shadowOpacity = 0.8
        
        
        return cell
    }
    @IBAction func rejectButtonAction(_ sender: Any) {
        let bookingId = openRequestes[indexSaver!].id.description
        let fieldId = openRequestes[indexSaver!].field.id
        let userId = openRequestes[indexSaver!].user.id
        openRequestes.remove(at: indexSaver!)
        if addBlackList == "1"{
            let data = BlackListModel(field: fieldId, user_id: userId)
            ApiController.instance.addUserToBlackList(data: data, completion: successChangePopup(answer:))
        }
        if delete == "1"{
            ApiController.instance.deleteBookingById(id: bookingId, completion: successChangePopup(answer:))
        }
        if deleteAll == "1"{
            ApiController.instance.deleteAllRequest(id: String(userId), completion: successChangePopup(answer:))
        }
        collectionView.reloadData()
        
        animateScaleOut(desiredView: popupView)
        animateScaleOut(desiredView: blurView)
    }
    
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        animateScaleOut(desiredView: popupView)
        animateScaleOut(desiredView: blurView)
    }
    @IBAction func blackListAddAction(_ sender: UIButton) {
        if (sender.isSelected == true){
            blackList.isSelected = false
            addBlackList = "0"
        }else{
            blackList.isSelected = true
            addBlackList = "1"
            print(addBlackList)
        }
    }
    @IBAction func requestDelete(_ sender: UIButton) {
        if (sender.isSelected == true){
            deleteButton.isSelected = false
            delete = "0"
            print(delete)
        }else{
            deleteButton.isSelected = true
            delete = "1"
            print(delete)
        }
    }
    @IBAction func deleteAllRequest(_ sender: UIButton) {
        if (sender.isSelected == true){
            deleteAllRequestButton.isSelected = false
            deleteAll = "0"
            print(deleteAll)
        }else{
            deleteAllRequestButton.isSelected = true
            deleteAll = "1"
            print(deleteAll)
        }
    }
    
    func successChangePopup(answer: String) {
        if answer == "success"{
            print("success")
        }else{
            print("tema")
        }
    }
}
extension NewRequestsController:NewCellProtocol{
    func onClicAccept(index: Int) {
        let bookingId = openRequestes[index].id.description
        let fieldId = openRequestes[index].field.id
        let data = ChandgeStatusModule(field: fieldId, status: 2)
        indexSaver = index
        ApiController.instance.changeStatusBooking(id: bookingId, parameters: data, completion: successAcceptPopup(answer:))
        
    }
    func successAcceptPopup(answer: String) {
        if answer == "success"{
            openRequestes.remove(at: indexSaver!)
            collectionView.reloadData()
        }else{
            let title = "Выбранное поле ещё не одобрено администратором."
            let message = ""
            let popup = PopupDialog(title: title, message: message)
            
            let first = DefaultButton(title: "ОК", height: 60) {
            }
            popup.addButtons([first])

            // Present dialog
            self.present(popup, animated: true, completion: nil)
        }
    }
    
    func onClickReject(index: Int) {
        indexSaver = index
        
        animateScaleIn(desiredView: blurView)
        animateScaleIn(desiredView: popupView)
        
        
    }
    
    
}
