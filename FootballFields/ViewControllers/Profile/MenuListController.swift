//
//  MenuListController.swift
//  FootballFields
//
//  Created by Baudunov Rapkat on 26/11/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit

class MenuListController:UITableViewController{
    var items:[String]?
    var user = ["Личные данные", "История Бронирований"]
    var owner = ["Личные данные", "История Бронирований","Запросы","Мои площадки","Добавить площадку","Черный список"]
    var typeOfUser = DataManager.sharedInstance.getCredentials().type
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        print(typeOfUser)
        if typeOfUser == 2 {
            items = user
        }else if typeOfUser == 1{
            items = owner
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items!.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = items![indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pageName = items?[indexPath.row]
        if pageName == "Личные данные"{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let changePersonalData = storyBoard.instantiateViewController(withIdentifier: "changePersonalData") as! ChangePersonalDataController
            changePersonalData.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(changePersonalData, animated: true)
        }else if pageName == "История Бронирований"{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "profileID") as! MainProfileController
            profile.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(profile, animated: true)
        }else if pageName == "Черный список"{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "blackList") as! BlackListController
            profile.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(profile, animated: true)
        }else if pageName == "Мои площадки"{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "myFieldView") as! MyFieldController
            profile.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(profile, animated: true)
        }else if pageName == "Запросы"{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "requestsController") as! ProfileRequestController
            profile.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(profile, animated: true)
        }else if pageName == "Добавить площадку"{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "addNewFieldId") as! AddNewFieldController
            profile.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(profile, animated: true)
        }
    }
}


