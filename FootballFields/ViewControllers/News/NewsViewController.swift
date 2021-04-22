//
//  NewsViewController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 11/4/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit

class NewsViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    let myRefreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var news : [NewsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth, height: screenHeight/5)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        collectionview!.collectionViewLayout = layout
        collectionview.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        collectionview.refreshControl = myRefreshControl
        ApiController.instance.newsShow(completion: adsShow(info:))
        
    }
    @objc private func refresh(sender:UIRefreshControl){
        ApiController.instance.newsShow(completion: adsShow(info:))
        sender.endRefreshing()
    }
    
    func adsShow(info:[NewsModel]){
        news = []
        for i in info{
            news.append(i)
            collectionview.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewsCell
        cell.contectText.text = news[indexPath.row].title?.description
        if let url = URL( string:news[indexPath.row].preview!)
        {
            DispatchQueue.global().async {
              if let data = try? Data( contentsOf:url)
              {
                DispatchQueue.main.async {
                  cell.imageOfNews.image = UIImage( data:data)
                }
              }
           }
        }
        cell.dateText.text = news[indexPath.row].date
        cell.timeText.text = news[indexPath.row].time
        
        cell.viewForShadow.layer.backgroundColor = UIColor.white.cgColor
        cell.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        cell.viewForShadow.layer.cornerRadius = 3
        cell.viewForShadow.layer.masksToBounds = false
        cell.viewForShadow.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cell.viewForShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.viewForShadow.layer.shadowOpacity = 0.8
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = news[indexPath.row]
        performSegue(withIdentifier: "newsDataSender", sender: data)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newsDataSender"{
            let destVC = segue.destination as! NewsInfoController
            destVC.data = (sender as! NewsModel)
        }
    }
    func base64ToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: imageData)
    }
    
    func imageToBase64(_ image: UIImage) -> String? {
        return image.jpegData(compressionQuality: 1)?.base64EncodedString()
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

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
