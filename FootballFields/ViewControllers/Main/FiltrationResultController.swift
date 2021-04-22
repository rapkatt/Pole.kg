//
//  FiltrationResultController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 11/14/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit

class FiltrationResultController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    let viewControllerCellId = "MainViewCell"
    var ads : [MainViewModel] = []
    var categoryForSend2:String?
    var min_price2,max_price2: Int?
    var min_players2,max_players2: Int?
    var hasParking2: Bool?
    var ordering2: String?
    var date2: String?
    var time_start2:String?
    var time_end2:String?
    var hasShower2: Bool?
    var hasIndoor:Bool?
    var hasRazdevalka2: Bool?
    var hasOsvewenie2: Bool?
    var hasTrubuni2: Bool?
    var hasInventar2: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth, height: screenHeight/5)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        collectionView!.collectionViewLayout = layout
        
        let nib = UINib(nibName: viewControllerCellId, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: viewControllerCellId)
        collectionView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        ApiController.instance.filterShow(orderingType: ordering2 ?? "", min_price: min_price2 ?? 0, max_price: max_price2 ?? 100000, min_players: min_players2 ?? 0, max_players: max_players2 ?? 1000, category: categoryForSend2 ?? "", has_parking: hasParking2 ?? "", date: date2 ?? "", time_start: time_start2 ?? "", time_end: time_end2 ?? "", is_indoor: hasIndoor ?? "", has_showers: hasShower2 ?? "", has_locker_rooms: hasRazdevalka2 ?? "", has_lights: hasOsvewenie2 ?? "", has_rostrum: hasTrubuni2 ?? "", has_equipment: hasInventar2 ?? "", completion: adsShow(info:))
        
    }
    
    func adsShow(info:[MainViewModel]){
        for i in info{
            if i.is_approved == true {
            ads.append(i)
            collectionView.reloadData()
            }
        }
        if ads.count == 0{
            emptyView(status: false)
        }else{
        emptyView(status: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return ads.count
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemDimension:CGFloat = self.view.frame.size.width
        
        return CGSize(width: itemDimension - 20, height: 298)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset:CGFloat = 10
        
        return UIEdgeInsets(top: 10, left: inset, bottom: 10, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewControllerCellId, for: indexPath) as! MainViewCell
        if let url = URL( string:ads[indexPath.row].images?[0].image ?? "ball")
        {
            DispatchQueue.global().async {
                if let data = try? Data( contentsOf:url)
                {
                    DispatchQueue.main.async {
                        cell.imageOfFields.image = UIImage( data:data)
                    }
                }
            }
        }
        cell.nameOfFields.text = ads[indexPath.row].name
        cell.locationFields.text = ads[indexPath.row].location
        let info = Float(ads[indexPath.row].price?.description ?? "0.0")
        cell.priceFields.text = info!.clean + " сом"
        cell.textFields.text = ads[indexPath.row].description?.description
        cell.raiting.value = CGFloat(ads[indexPath.row].rating ?? 0.0)
        cell.raiting.tintColor = #colorLiteral(red: 1, green: 0.7647058824, blue: 0.1607843137, alpha: 1)
        
        cell.viewOfShadow.layer.backgroundColor = UIColor.white.cgColor
        cell.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        cell.viewOfShadow.layer.cornerRadius = 3
        cell.viewOfShadow.layer.masksToBounds = false
        cell.viewOfShadow.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cell.viewOfShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.viewOfShadow.layer.shadowOpacity = 0.8
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = ads[indexPath.row]
        performSegue(withIdentifier: "filterdata", sender: data)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filterdata"{
            let destVC = segue.destination as! InfoFieldOrReviewController
            destVC.data = (sender as! MainViewModel)
        }
    }
}
extension FiltrationResultController{
    func emptyView(status:Bool){
        let title = UILabel()
        title.text = "Нет результатов"
        title.numberOfLines = 0
        title.textAlignment = .center
        title.sizeToFit()
        title.center = self.view.center
        title.isHidden = status
        self.view.addSubview(title)
      //  collectionView.reloadData()
    }
}
