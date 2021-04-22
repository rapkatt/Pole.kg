import PopupDialog
import UIKit

class PopupController {
    
    func createAlertPopup(title: String, message: String, btnTxt: String) -> PopupDialog {
        let title = title
        let message = message
        let popup = PopupDialog(title: title, message: message)
        let buttonOne = CancelButton(title: btnTxt) {
            print("Ok")
        }
        popup.addButtons([buttonOne])
        return popup
    }
    
    func createAlertPopupWithBtn(title: String, message: String, btn: CancelButton) -> PopupDialog {
        let title = title
        let message = message
        let popup = PopupDialog(title: title, message: message)
        popup.addButtons([btn])
        return popup
    }
    
//    func createAlertPopupWithTwoBtn(title: String, message: String,btn1: ,btn: CancelButton) -> PopupDialog {
//        let title = title
//        let message = message
//        let popup = PopupDialog(title: title, message: message)
//        popup.addButtons([btn])
//        return popup
//    }
    
}
