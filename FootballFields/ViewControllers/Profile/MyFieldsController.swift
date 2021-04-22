//
//  MyFieldsController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 28/11/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import PopupDialog

class MyFieldController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var myFieldArray : [MyFieldModule] = []
    
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
        layout.itemSize = CGSize(width: screenWidth, height: screenHeight/7)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        collectionView!.collectionViewLayout = layout
        collectionView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        collectionView.refreshControl = myRefreshControl
        ApiController.instance.myFieldShow(completion: myFiledShow(info:))
    }
    @objc private func refresh(sender:UIRefreshControl){
        
        ApiController.instance.myFieldShow(completion: myFiledShow(info:))
        sender.endRefreshing()
    }
    
    func myFiledShow(info:[MyFieldModule]){
        myFieldArray = []
        for i in info{
            myFieldArray.append(i)
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myFieldArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyFieldCell
        if let url = URL( string:myFieldArray[indexPath.row].images[0].image )
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
        
        cell.name.text = myFieldArray[indexPath.row].name
        let status:String?
        if myFieldArray[indexPath.row].is_approved == true{
            status = "активна"
        }else{
            status = "скрыта"
        }
        cell.status.text = status
        
        cell.cellDelegate = self
        cell.index = indexPath
        
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
extension MyFieldController:CollectionViewNew{
    func onClickEdit(index: Int) {
        let info = myFieldArray[index]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "editFieldId") as! EditProfileController
        profile.data = info
        profile.categoryId = info.field_type
        profile.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(profile, animated: true)
        
    }
    
    
    func onClickDelete(index: Int) {
        let title = ""
        let message = "Вы действительно хотите удалить данную площадку?"
        let popup = PopupDialog(title: title, message: message)
        let first = DefaultButton(title: "Да", height: 60) {
            let id = self.myFieldArray[index].id.description
            self.myFieldArray.remove(at: index)
            
            ApiController.instance.deleteField(id: id, completion: self.successDeletePopup(answer:))
            self.collectionView.reloadData()
        }
        
        let cancel = CancelButton(title: "Нет") {
            print("")
        }
        popup.addButtons([first, cancel])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
        
    }
    func successDeletePopup(answer: String) {
        if answer == "success"{
            print("success")
        }else{
            print("tema")
        }
    }
    
    
}
extension MyFieldController{
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
