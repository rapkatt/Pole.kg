import Foundation
import UIKit

extension UIButton {
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        layer.masksToBounds = true
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.setBackgroundImage(colorImage, for: forState)
    }
    
    func buttonBorderGreen(){
        self.layer.cornerRadius = 5
        self.layer.borderColor = #colorLiteral(red: 0.05098039216, green: 0.5215686275, blue: 0.2862745098, alpha: 1)
        self.layer.borderWidth = 1.0
        self.setTitleColor(#colorLiteral(red: 0.05098039216, green: 0.5215686275, blue: 0.2862745098, alpha: 1), for: .normal)
        self.setBackgroundColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), forState: .normal)
        
    }
    func buttonGray(){
        self.layer.cornerRadius = 5
        self.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.setBackgroundColor(color: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), forState: .normal)
    }
    func buttonGreen(){
        self.layer.cornerRadius = 5
        self.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.setBackgroundColor(color: #colorLiteral(red: 0.05098039216, green: 0.5215686275, blue: 0.2862745098, alpha: 1), forState: .normal)
    }
    func buttonBlack(){
        self.layer.cornerRadius = 5
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.borderWidth = 2.0
        self.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        self.setBackgroundColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), forState: .normal)
    }
}


