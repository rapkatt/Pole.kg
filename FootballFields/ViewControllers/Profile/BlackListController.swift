//
//  BlackListController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 26/11/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit
import PopupDialog

class BlackListController:UIViewController,UITableViewDelegate,UITableViewDataSource{
 
    @IBOutlet weak var tableView: UITableView!
    var blackList : [BlackListModel2] = []
    
    let myRefreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = myRefreshControl
        ApiController.instance.getBlackList(completion: blackListShow(info:))
    }
    @objc private func refresh(sender:UIRefreshControl){
       
        ApiController.instance.getBlackList(completion: blackListShow(info:))
        sender.endRefreshing()
    }
    
    func blackListShow(info:[BlackListModel2]){
        blackList = []
        for i in info{
            blackList.append(i)
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(blackList)
        return blackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BlackLIstCell
        cell.name.text = blackList[indexPath.row].user
        
        cell.cellDelegate = self
        cell.index = indexPath
        
        cell.unBlockButton.buttonBlack()
        return cell
    }
}
extension BlackListController:DeleteFromBlackList{
    func onClickDelete(index: Int) {
        let name = blackList[index].user.description
        let id = blackList[index].id.description
        let title = "Разблокировать \(name)?"
        let message = "Пользователь сможет отправлять запросы на бронирование ваших площадок"

        // Create the dialog
        let popup = PopupDialog(title: title, message: message)

        // Create buttons
        let buttonOne = CancelButton(title: "Отменить") {
            print("You canceled the car dialog.")
        }

        let buttonTwo = DefaultButton(title: "Разблокировать", height: 60) {
            self.blackList.remove(at: index)
            ApiController.instance.deleteBlackList(id: id, completion: self.successChangePopup(answer:))
            self.tableView.reloadData()
        }
        popup.addButtons([buttonOne, buttonTwo])

        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    func successChangePopup(answer: String) {
        if answer == "success"{
            print("success")
        }else{
            print("tema")
        }
    }
}
