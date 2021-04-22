import Foundation
import UIKit
import NVActivityIndicatorView

extension UIViewController{
    
    func configureNavBar(navBar: UINavigationController) {
        navBar.navigationBar.barTintColor = #colorLiteral(red: 0.05098039216, green: 0.5215686275, blue: 0.2862745098, alpha: 1)
        navBar.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navBar.navigationBar.barStyle = .black
        navBar.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Apple SD Gothic Neo", size: 20)!, NSAttributedString.Key.foregroundColor:UIColor.white]
        
    }
    func getTextfield(view: UIView) -> [UITextField] {
        var results = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                results += [textField]
            } else {
                results += getTextfield(view: subview)
            }
        }
        return results
    }
    
    func getTextView(view: UIView) -> [UITextView] {
        var results = [UITextView]()
        for subview in view.subviews as [UIView] {
            if let textView = subview as? UITextView {
                results += [textView]
            } else {
                results += getTextView(view: subview)
            }
        }
        return results
    }
    func loadingView(view: UIView) -> NVActivityIndicatorView{
        let loading = NVActivityIndicatorView(frame: .zero, type: .ballPulseSync, color: #colorLiteral(red: 0.1607843137, green: 0.7019607843, blue: 0.6039215686, alpha: 1), padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 40),
            loading.heightAnchor.constraint(equalToConstant: 40),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        return loading
    }
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}


