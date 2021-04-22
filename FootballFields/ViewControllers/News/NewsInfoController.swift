//
//  NewsInfoCotroller.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 11/5/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import ImageSlideshow

class NewsInfoController:UIViewController{
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var titleInfo: UILabel!
    @IBOutlet weak var dateInfo: UILabel!
    @IBOutlet weak var timeInfo: UILabel!
    @IBOutlet weak var infoAboutField: UITextView!
    
    var data:NewsModel?
    var imageSource: [ImageSource] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleInfo.text = data?.title?.description
        dateInfo.text = data?.date
        timeInfo.text = data?.time
        infoAboutField.text = data?.body?.description
        imageCollect()
        
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        
        slideshow.pageIndicator = pageControl
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.delegate = self
      //  let testImage = data?.preview
      //  imageSource.append(ImageSource(image: getImage(from: data?.preview ))
        slideshow.setImageInputs(imageSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        slideshow.addGestureRecognizer(recognizer)
    }
    func imageCollect(){
      //  var i = 0
      //  while i < data!.images.count {
        let testImage = data!.preview
        imageSource.append(ImageSource(image: getImage(from: testImage!)!))
          //  i += 1
      //  }
        
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
}
extension NewsInfoController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
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
