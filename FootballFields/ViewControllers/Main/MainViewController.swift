//
//  MainViewController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 10/28/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import SVProgressHUD

class MainViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterButton: UIButton!
    
    let myRefreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    
    let viewControllerCellId = "MainViewCell"
    var ads : [MainViewModel] = []
    var arrayOfImages:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllerDesign()
        filterButton.layer.cornerRadius = 25
        filterButton.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.5215686275, blue: 0.2862745098, alpha: 1)
        
        let nib = UINib(nibName: viewControllerCellId, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: viewControllerCellId)
        collectionView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        collectionView.refreshControl = myRefreshControl
        ApiController.instance.adsShow(completion: adsShow(info:))
    }
    @objc private func refresh(sender:UIRefreshControl){
        ApiController.instance.adsShow(completion: adsShow(info:))
        sender.endRefreshing()
    }
    
    func adsShow(info:[MainViewModel]){
        ads = []
        for i in info{
            if i.is_approved == true {
            ads.append(i)
            collectionView.reloadData()
            }
        }
       // SVProgressHUD.dismiss()
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
        cell.nameOfFields.text = ads[indexPath.row].name?.description
        cell.locationFields.text = ads[indexPath.row].location?.description
        let info = Float(ads[indexPath.row].price?.description ?? "0.0")
        cell.priceFields.text = info!.clean + " сом"
        cell.textFields.text = ads[indexPath.row].description?.description
        cell.raiting.allowsHalfStars = true
        cell.raiting.value = CGFloat(ads[indexPath.row].rating ?? 0.0)
        cell.raiting.isUserInteractionEnabled = false
        cell.raiting.tintColor = #colorLiteral(red: 1, green: 0.7647058824, blue: 0.1607843137, alpha: 1)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // SVProgressHUD.show()
       // SVProgressHUD.setDefaultMaskType(.clear)
        let data = ads[indexPath.row]
        performSegue(withIdentifier: "infoTransfer", sender: data)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // SVProgressHUD.dismiss()
        if segue.identifier == "infoTransfer"{
            let destVC = segue.destination as! InfoFieldOrReviewController
            destVC.data = (sender as! MainViewModel)
        }
    }
}
extension MainViewController{
    
    func viewControllerDesign(){
        var screenSize: CGRect!
        var screenWidth: CGFloat!
        var screenHeight: CGFloat!
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth, height: screenHeight/5)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        collectionView!.collectionViewLayout = layout
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
