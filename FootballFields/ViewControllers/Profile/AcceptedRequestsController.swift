//
//  AcceptedRequestsController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 29/11/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit

class AcceptedRequestsController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var acceptedRequestes : [RequestsModule] = []
    
    let myRefreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth, height: 175)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        collectionView!.collectionViewLayout = layout
        collectionView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        collectionView.refreshControl = myRefreshControl
        ApiController.instance.requests(status: "2", completion: dataColector(info:))
    }
    
    @objc private func refresh(sender:UIRefreshControl){
        
        ApiController.instance.requests(status: "2", completion: dataColector(info:))
        sender.endRefreshing()
    }
    
    func dataColector(info:[RequestsModule]){
        acceptedRequestes = []
        for i in info{
            acceptedRequestes.append(i)
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return acceptedRequestes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AcceptedCell
        cell.name.text = acceptedRequestes[indexPath.row].user.full_name
        cell.phoneNumber.text = acceptedRequestes[indexPath.row].user.phone_number
        cell.fieldName.text = acceptedRequestes[indexPath.row].field.name
        cell.date.text = acceptedRequestes[indexPath.row].booking_date
        cell.timeStart.text = acceptedRequestes[indexPath.row].time_start
        cell.timeEnd.text = acceptedRequestes[indexPath.row].time_end
        
        cell.viewForShadow.layer.backgroundColor = UIColor.white.cgColor
        cell.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        cell.viewForShadow.layer.cornerRadius = 3
        cell.viewForShadow.layer.masksToBounds = false
        cell.viewForShadow.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cell.viewForShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.viewForShadow.layer.shadowOpacity = 0.8
        
        return cell
    }
}

