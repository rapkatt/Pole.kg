//
//  ApiController.swift
//  NeobisTime
//
//  Created by Islam on 7/21/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import NVActivityIndicatorView

struct UrlPatterns {
    let auth = "auth/"
    let main = "main/"
    
    static let instance = UrlPatterns()
}

struct EndPoints {
    let userRegistration = "register/"
    let login = "token/"
    let field_booking = "field_booking/"
    let field = "field/"
    let news = "news/"
    let field_type = "field_type/"
    let field_review = "field_review/?field="
    static let instance = EndPoints()
}

class ApiController {
    
    func headerRequest() -> HTTPHeaders{
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer  \(DataManager.sharedInstance.getCredentials().accessToken)",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        return headers
    }
    
    func headerRequest2() -> HTTPHeaders{
        let headers2: HTTPHeaders = [
            "Authorization" : "Bearer  \(DataManager.sharedInstance.getCredentials().accessToken)",
            "Conctent-Type": "multipart/form-data"
        ]
        return headers2
    }
    
    
    
    static let instance = ApiController()
    func registerUser( user: RegistrationModel, completion: @escaping (String)-> ()) {
        
        let urlString = ApiAddress(endpoint: UrlPatterns.instance.auth + EndPoints.instance.userRegistration).getURLString()
        guard let url = URL(string: urlString) else{ return }
        let parametrs = user.convertToParameters()
        AF.request(url, method: .post, parameters: parametrs, encoding: JSONEncoding.default).responseJSON{ (response) in
            if(response.description.contains("Пользователь с таким Номер телефона уже существует.")){
                DispatchQueue.main.async {
                    completion("Пользователь с таким номером телефона уже существует")
                }
                return
            }
            if(response.response?.statusCode == 201){
                DispatchQueue.main.async {
                    completion("Регистрация прошла успешно")
                }
            }else if(response.response?.statusCode == 400){
                DispatchQueue.main.async {
                    completion("Пользователь с таким номером телефона уже существует")
                }
                return
            }else{
                DispatchQueue.main.async {
                    completion("Что-то пошло не так. Проверьте интернет соединение и попробуйте снова")
                }
            }
        }
    }
    
    func loginUser(user: LoginModel,completion: @escaping (String)-> ()) {
        let urlString = ApiAddress(endpoint: UrlPatterns.instance.auth + EndPoints.instance.login).getURLString()
        guard let urlAuth = URL(string: urlString) else{ return }
        let parametrs = user.convertToParameters()
        AF.request(urlAuth, method: .post, parameters: parametrs, encoding: JSONEncoding.default).validate().responseDecodable(of: CredentialsToRequset.self){ (response) in
            guard let credentials = response.value else {
                
                if response.response?.statusCode == 401{
                    return DispatchQueue.main.async {
                        completion("Неправильные данные или заблокированный аккаунт")
                    }
                }else{
                    return DispatchQueue.main.async {
                        completion("Что-то пошло не так. Проверьте интернет соединение и попробуйте снова")
                    }
                }
            }
            if(response.response?.statusCode == 200){
                let credent = Credentials()
                credent.accessToken = credentials.token
                credent.phoneNumber = credentials.phone_number
                credent.type = credentials.type
                credent.full_name = credentials.full_name
                credent.credentialID = "Person"
                DataManager.sharedInstance.addCredentials(object: credent)
                return DispatchQueue.main.async {
                    completion("success")
                }
            }
        }
    }
    func booking(data:BookingModel,completion: @escaping (String)-> ()) {
        let url = ApiAddress(endpoint: UrlPatterns.instance.main + EndPoints.instance.field_booking).getURLString()
        let parameters = data.convertToParameters()
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headerRequest()).validate().responseJSON(){ (response) in
            if response.response?.statusCode == 201{
                return DispatchQueue.main.async {
                    completion("Бронь прошла успешно")
                }
            }else if response.response?.statusCode == 401 || response.response?.statusCode == 403{
                self.refreshToken(url1: url, method: .post, parameters1: parameters, encoding: JSONEncoding.default, headers: self.headerRequest()) { (response) in
                    if response.response?.statusCode == 201{
                        return DispatchQueue.main.async {
                            completion("success")
                        }
                    }
                }
            }
             else if response.response?.statusCode == 400{
                DispatchQueue.main.async {
                    completion("Выбранное время уже занято. Попробуйте ещё раз.")
                }
                return
            }else{
                return DispatchQueue.main.async {
                    completion("Что-то пошло не так. Проверьте интернет соединение и попробуйте снова")
                }
            }
            
        }
    }
    
    func adsShow(completion: @escaping ([MainViewModel])->()){
        let url = ApiAddress(endpoint: UrlPatterns.instance.main + EndPoints.instance.field).getURLString()
        AF.request(url,method: .get, parameters: [:], encoding: URLEncoding.queryString, headers: ["Content-Type" :"application/json"])
            .validate()
            .responseDecodable(of: [MainViewModel].self) { (response) in
                guard let data = response.value else { return }
                DispatchQueue.main.async {
                    completion(data)
                }
            }
    }
    
    func newsShow(completion: @escaping ([NewsModel])->()){
        let url = ApiAddress(endpoint: UrlPatterns.instance.main + EndPoints.instance.news).getURLString()
        AF.request(url,method: .get, parameters: [:], encoding: URLEncoding.queryString, headers: ["Content-Type" :"application/json"])
            .validate()
            .responseDecodable(of: [NewsModel].self) { (response) in
                guard let data = response.value else { return }
                DispatchQueue.main.async {
                    completion(data)
                }
            }
    }
    
    func category(completion: @escaping ([Category])->()){
        let url = ApiAddress(endpoint: UrlPatterns.instance.main + EndPoints.instance.field_type).getURLString()
        AF.request(url,method: .get, parameters: [:], encoding: URLEncoding.queryString, headers: ["Content-Type" :"application/json"])
            .validate()
            .responseDecodable(of: [Category].self) { (response) in
                guard let data = response.value else { return }
                DispatchQueue.main.async {
                    completion(data)
                }
            }
    }
    func filterShow(orderingType:String,min_price:Int,max_price:Int,min_players:Int,max_players:Int,category:String,has_parking:Any,date:String,time_start:String,time_end:String,is_indoor:Any,has_showers:Any,has_locker_rooms:Any,has_lights:Any,has_rostrum:Any,has_equipment:Any,completion: @escaping ([MainViewModel])->()){
        let url = "http://167.71.36.59:8000/api/main/field/?min_price=\(min_price)&max_price=\(max_price)&min_players=\(min_players)&max_players=\(max_players)&field_type=\(category)&has_parking=\(has_parking)&date=\(date)&time_start=\(time_start)&time_end=\(time_end)&is_indoor=\(is_indoor)&has_showers=\(has_showers)&has_locker_rooms=\(has_locker_rooms)&has_lights=\(has_lights)&has_rostrum=\(has_rostrum)&has_equipment=\(has_equipment)&ordering=\(orderingType)"
        print(url)
        AF.request(url,method: .get, parameters: [:], encoding: URLEncoding.queryString, headers: ["Content-Type" :"application/json"])
            .validate()
            .responseDecodable(of: [MainViewModel].self) { (response) in
                
                guard let data = response.value else { return }
                DispatchQueue.main.async {
                    completion(data)
                }
            }
    }
    
    func filterShowtest(min_price:Int,max_price:Int,min_players:Int,max_players:Int,category:String,completion: @escaping ([MainViewModel])->()){
        let url = "http://167.71.36.59:8000/api/main/field/?min_price=\(min_price)&max_price=\(max_price)&min_players=\(min_players)&max_players=\(max_players)&category=\(category)"
        AF.request(url,method: .get, parameters: [:], encoding: URLEncoding.queryString, headers: ["Content-Type" :"application/json"])
            .validate()
            .responseDecodable(of: [MainViewModel].self) { (response) in
                guard let data = response.value else { return }
                DispatchQueue.main.async {
                    completion(data)
                }
            }
    }
    func reviewShow(fieldId:String,completion: @escaping ([reviewModelRequest])->()){
        let url = ApiAddress(endpoint: UrlPatterns.instance.main + EndPoints.instance.field_review + fieldId).getURLString()
        print(url)
        AF.request(url,method: .get, parameters: [:], encoding: URLEncoding.queryString, headers: nil)
            .validate().responseDecodable(of: [reviewModelRequest].self) { (response) in
                guard let data = response.value else { return }
                DispatchQueue.main.async {
                    completion(data)
                }
            }
    }
    func addNewField(data:BookingModel,completion: @escaping (String)-> ()) {
        let url = ApiAddress(endpoint: UrlPatterns.instance.main + EndPoints.instance.field_booking).getURLString()
        let parameters = data.convertToParameters()
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headerRequest()).validate().responseJSON(){ (response) in
            if response.response?.statusCode == 201{
                return DispatchQueue.main.async {
                    completion("success")
                }
            }
            if response.response?.statusCode == 403 || response.response?.statusCode == 401{
                self.refreshToken(url1: url, method: .post, parameters1: parameters, encoding: JSONEncoding.default, headers: self.headerRequest()) { (response) in
                    if response.response?.statusCode == 201{
                        return DispatchQueue.main.async {
                            completion("success")
                        }
                    }
                }
            }
        }
    }
    func uploadImage(imagesData: [UIImage], data: NewFieldModule,completion: @escaping (idTaker)-> ()) {
        let url = "http://167.71.36.59:8000/api/main/field/create/"
        let parameters = data.convertToParameters()
        let timestamp = NSDate().timeIntervalSince1970
        AF.upload(multipartFormData: { multipartFormData in
            
            for imageData in imagesData {
                let image = imageData.jpegData(compressionQuality: 0.1)
                multipartFormData.append(image!, withName: "images", fileName: "Image_\(timestamp).jpeg", mimeType: "Image_\(timestamp)/jpeg")
            }
            for (key, value) in parameters {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Bool {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
            }
        },
        to: url, method: .post , headers: headerRequest2()).validate().responseDecodable(of: idTaker.self){ (response) in
            if response.response?.statusCode == 201 {
                guard let data = response.value else { return }
                return DispatchQueue.main.async {
                    completion(data)
                }
            }
        }
    }
    func addTime(data: ScheduleModel,completion: @escaping (String)-> ()) {
        let url = "http://167.71.36.59:8000/api/main/field/hours/"
        let array = data.working_hours.map { $0.dictionaryRepresentation }
        let parameters:[String:Any] = [
            "field":data.field,
            "working_hours": array
        ]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headerRequest()).validate().responseJSON{ (response) in
            if response.response?.statusCode == 201{
                return DispatchQueue.main.async {
                    completion("success")
                }
            }
            if response.response?.statusCode == 403 || response.response?.statusCode == 401{
                self.refreshToken(url1: url, method: .post, parameters1: parameters, encoding: JSONEncoding.default, headers: self.headerRequest()) { (response) in
                    if response.response?.statusCode == 201{
                        return DispatchQueue.main.async {
                            completion("success")
                        }
                    }
                }
            }
            
        }
    }
    
    func editTimePut(fieldid:String,data: ScheduleModel,completion: @escaping (String)-> ()) {
        let url = "http://167.71.36.59:8000/api/main/field/\(fieldid)/hours/"
        let array = data.working_hours.map { $0.dictionaryRepresentation }
        let parameters:[String:Any] = [
            "field":data.field,
            "working_hours": array
        ]
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default,headers: headerRequest()).validate().responseJSON{ (response) in
            if response.response?.statusCode == 200{
                return DispatchQueue.main.async {
                    completion("success")
                }
            }
            if response.response?.statusCode == 403 || response.response?.statusCode == 401{
                self.refreshToken(url1: url, method: .put, parameters1: parameters, encoding: JSONEncoding.default, headers: self.headerRequest()) { (response) in
                    if response.response?.statusCode == 200{
                        return DispatchQueue.main.async {
                            completion("success")
                        }
                    }
                }
            }
            
        }
    }
    
    func bookingHistory(completion: @escaping ([BookingHistoryModule])->()){
        let url = "http://167.71.36.59:8000/api/main/field_booking/"
        AF.request(url,method: .get, parameters: [:], encoding: URLEncoding.queryString, headers: headerRequest())
            .validate().responseJSON() { (response) in
                if response.response?.statusCode == 200{
                    if let data = response.data {
                        let user = try! JSONDecoder().decode([BookingHistoryModule].self, from: data)
                        return DispatchQueue.main.async {
                            completion(user)
                        }
                    }
                }
                if response.response?.statusCode == 403 || response.response?.statusCode == 401{
                    self.refreshToken(url1: url, method: .get, parameters1: [:], encoding: URLEncoding.queryString, headers: self.headerRequest()) { (response) in
                        if response.response?.statusCode == 200{
                            if let data = response.data {
                                let user = try! JSONDecoder().decode([BookingHistoryModule].self, from: data)
                                return DispatchQueue.main.async {
                                    completion(user)
                                }
                            }
                        }
                    }
                }
                
            }
    }
    func deleteBookingById(id:String,completion: @escaping (String)-> ()){
        let url = "http://167.71.36.59:8000/api/main/field_booking/\(id)/"
        AF.request(url,method: .delete, parameters: [:], encoding: URLEncoding.queryString, headers: headerRequest())
            .validate().responseJSON() { (response) in
                if response.response?.statusCode == 204{
                    return DispatchQueue.main.async {
                        completion("success")
                    }
                }
                if response.response?.statusCode == 403 || response.response?.statusCode == 401{
                    self.refreshToken(url1: url, method: .delete, parameters1: [:], encoding: URLEncoding.queryString, headers: self.headerRequest()) { (response) in
                        if response.response?.statusCode == 204{
                            return DispatchQueue.main.async {
                                completion("success")
                            }
                        }
                    }
                }
            }
    }
    func changeStatusBooking(id:String,parameters:ChandgeStatusModule,completion: @escaping (String)-> ()){
        let url = "http://167.71.36.59:8000/api/main/field_booking/\(id)/"
        let parameters = parameters.convertToParameters()
        AF.request(url,method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headerRequest())
            .validate().responseJSON() { (response) in
                if response.response?.statusCode == 200{
                    return DispatchQueue.main.async {
                        completion("success")
                    }
                }
                if response.response?.statusCode == 400{
                    return DispatchQueue.main.async {
                        completion("Выбранное поле ещё не одобрено администратором.")
                    }
                }
                if response.response?.statusCode == 403 || response.response?.statusCode == 401{
                    self.refreshToken(url1: url, method: .patch, parameters1: parameters, encoding: JSONEncoding.default, headers: self.headerRequest()) { (response) in
                        if response.response?.statusCode == 200{
                            return DispatchQueue.main.async {
                                completion("success")
                            }
                        }
                    }
                }
            }
    }
    
    
    func changeName(parameters:UserModel,completion: @escaping (String) -> ()){
        let url = "http://167.71.36.59:8000/api/auth/users/"
        let parameter = parameters.convertToParameters()
        AF.request(url,method: .patch, parameters: parameter, encoding: JSONEncoding.default, headers: headerRequest()).responseJSON() { (response) in
            if response.response?.statusCode == 200{
                return DispatchQueue.main.async {
                    let credent = Credentials()
                    credent.accessToken = DataManager.sharedInstance.getCredentials().accessToken
                    credent.phoneNumber = DataManager.sharedInstance.getCredentials().phoneNumber
                    credent.type = DataManager.sharedInstance.getCredentials().type
                    credent.full_name = parameters.full_name
                    credent.credentialID = "Person"
                    DataManager.sharedInstance.addCredentials(object: credent)
                    completion("success")
                }
            }
            if response.response?.statusCode == 403 || response.response?.statusCode == 401{
                self.refreshToken(url1: url, method: .patch, parameters1: parameter, encoding: JSONEncoding.default, headers: self.headerRequest()) { (response) in
                    if response.response?.statusCode == 200{
                        return DispatchQueue.main.async {
                            let credent = Credentials()
                            credent.accessToken = DataManager.sharedInstance.getCredentials().accessToken
                            credent.phoneNumber = DataManager.sharedInstance.getCredentials().phoneNumber
                            credent.type = DataManager.sharedInstance.getCredentials().type
                            credent.full_name = parameters.full_name
                            credent.credentialID = "Person"
                            DataManager.sharedInstance.addCredentials(object: credent)
                            completion("success")
                        }
                    }
                }
            }
            
        }
    }
    func myFieldShow(completion: @escaping ([MyFieldModule])->()){
        let url = "http://167.71.36.59:8000/api/main/user/fields/"
        AF.request(url,method: .get, parameters: [:], encoding: URLEncoding.queryString, headers:headerRequest()).validate().responseJSON { (response) in
            if response.response?.statusCode == 200 {
                if let data = response.data {
                    let user = try! JSONDecoder().decode([MyFieldModule].self, from: data)
                    completion(user)
                }
            }
            if response.response?.statusCode == 403 || response.response?.statusCode == 401 {
                self.refreshToken(url1: url, method: .get, parameters1: [:], encoding: URLEncoding.queryString, headers: self.headerRequest()) { (response) in
                    if let data = response.data {
                        let user = try! JSONDecoder().decode([MyFieldModule].self, from: data)
                        completion(user)
                    }
                    
                }
            }
        }
    }
    func deleteField(id:String,completion: @escaping (String)-> ()){
        let url = "http://167.71.36.59:8000/api/main/field/\(id)/"
        AF.request(url,method: .delete, parameters: [:], encoding: URLEncoding.queryString, headers:headerRequest())
            .validate().responseJSON() { (response) in
                if response.response?.statusCode == 204{
                    return DispatchQueue.main.async {
                        completion("success")
                    }
                }
                if response.response?.statusCode == 403 || response.response?.statusCode == 401{
                    self.refreshToken(url1: url, method: .delete, parameters1: [:], encoding: URLEncoding.queryString, headers: self.headerRequest()) { (response) in
                        if response.response?.statusCode == 204{
                            return DispatchQueue.main.async {
                                completion("success")
                            }
                        }
                    }
                }
            }
    }
    
    func fieldEdit(id:String,imagesData: [UIImage], data: MyFieldModule,completion: @escaping (idTaker)-> ()) {
        let url = "http://167.71.36.59:8000/api/main/field/\(id)/"
        let parameters = data.convertToParameters()
        let timestamp = NSDate().timeIntervalSince1970
        AF.upload(multipartFormData: { multipartFormData in
            
            for imageData in imagesData {
                let image = imageData.jpegData(compressionQuality: 0.1)
                multipartFormData.append(image!, withName: "images", fileName: "Image_\(timestamp).jpeg", mimeType: "Image_\(timestamp)/jpeg")
            }
            for (key, value) in parameters {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Bool {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
            }
        },
        to: url, method: .put , headers: headerRequest2()).validate().responseDecodable(of: idTaker.self){ (response) in
            if response.response?.statusCode == 200 {
                guard let data = response.value else { return }
                return DispatchQueue.main.async {
                    completion(data)
                }
            }
        }
    }
    func changeTimeForField(id:Int,data: ScheduleModel,completion: @escaping (String)-> ()) {
        let url = "http://167.71.36.59:8000/api/main/field/\(id)/hours/"
        let array = data.working_hours.map { $0.dictionaryRepresentation }
        let parameters:[String:Any] = [
            "field":data.field,
            "working_hours": array
        ]
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default,headers: headerRequest()).validate().responseJSON{ (response) in
            if response.response?.statusCode == 200{
                return DispatchQueue.main.async {
                    completion("success")
                }
            }
            if response.response?.statusCode == 403 || response.response?.statusCode == 401{
                self.refreshToken(url1: url, method: .put, parameters1: parameters, encoding: JSONEncoding.default, headers: self.headerRequest()) { (response) in
                    if response.response?.statusCode == 200{
                        return DispatchQueue.main.async {
                            completion("success")
                        }
                    }
                }
            }
        }
    }
    
    func requests(status:String,completion: @escaping ([RequestsModule])->()){
        let url = "http://167.71.36.59:8000/api/main/owner/requests/?status=\(status)"
        AF.request(url,method: .get, parameters: [:], encoding: URLEncoding.queryString, headers:headerRequest()).validate().responseDecodable(of: [RequestsModule].self) { (response) in
            if response.response?.statusCode == 200 {
                if let data = response.data {
                    let user = try! JSONDecoder().decode([RequestsModule].self, from: data)
                    completion(user)
                }
            }
            if response.response?.statusCode == 403 || response.response?.statusCode == 401 {
                self.refreshToken(url1: url, method: .get, parameters1: [:], encoding: URLEncoding.queryString, headers: self.headerRequest()) { (response) in
                    if let data = response.data {
                        let user = try! JSONDecoder().decode([RequestsModule].self, from: data)
                        completion(user)
                    }
                    
                }
            }
        }
    }
    func addUserToBlackList(data:BlackListModel,completion: @escaping (String)-> ()) {
        let url = "http://167.71.36.59:8000/api/main/blacklist/"
        let parameters = data.convertToParameters()
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headerRequest()).validate().responseDecodable(of: BlackListModel.self){ (response) in
            if response.response?.statusCode == 201 {
                if let data = response.data {
                    completion("success")
                }
            }
            if response.response?.statusCode == 403 || response.response?.statusCode == 401 {
                self.refreshToken(url1: url, method: .post, parameters1: parameters, encoding: JSONEncoding.default, headers: self.headerRequest()) { (response) in
                    if let data = response.data {
                        print(response.response?.statusCode)
                        completion("success")
                        }
                    }
            }
        }
    }
    
    
    func getBlackList(completion: @escaping ([BlackListModel2])->()){
        let url = "http://167.71.36.59:8000/api/main/blacklist/"
        AF.request(url,method: .get, parameters: [:], encoding: URLEncoding.queryString, headers:headerRequest()).validate().responseDecodable(of: [BlackListModel2].self) { (response) in
            if response.response?.statusCode == 200 {
                if let data = response.data {
                    let user = try! JSONDecoder().decode([BlackListModel2].self, from: data)
                    completion(user)
                }
            }
            if response.response?.statusCode == 403 || response.response?.statusCode == 401 {
                self.refreshToken(url1: url, method: .get, parameters1: [:], encoding: URLEncoding.queryString, headers: self.headerRequest()) { (response) in
                    if let data = response.data {
                        let user = try! JSONDecoder().decode([BlackListModel2].self, from: data)
                        completion(user)
                    }
                }
            }
        }
    }
    
    func deleteBlackList(id:String,completion: @escaping (String)-> ()){
        let url = "http://167.71.36.59:8000/api/main/blacklist/\(id)/"
        AF.request(url,method: .delete, parameters: [:], encoding: URLEncoding.queryString, headers:headerRequest())
            .validate().responseJSON() { (response) in
                if response.response?.statusCode == 204{
                    return DispatchQueue.main.async {
                        completion("success")
                    }
                }
                if response.response?.statusCode == 403 || response.response?.statusCode == 401 {
                    self.refreshToken(url1: url, method: .delete, parameters1: [:], encoding: URLEncoding.queryString, headers: self.headerRequest()) { (response) in
                        if response.response?.statusCode == 204 {
                            completion("success")
                            
                        }
                    }
                }
            }
    }
    
    
    func deleteAllRequest(id:String,completion: @escaping (String)-> ()){
        let url = "http://167.71.36.59:8000/api/main/owner/requests/\(id)/"
        AF.request(url,method: .delete, parameters: [:], encoding: URLEncoding.queryString, headers:headerRequest())
            .validate().responseJSON() { (response) in
                if response.response?.statusCode == 204{
                    return DispatchQueue.main.async {
                        completion("success")
                    }
                }
                if response.response?.statusCode == 403 || response.response?.statusCode == 401{
                    self.refreshToken(url1: url, method: .delete, parameters1: [:], encoding: URLEncoding.queryString, headers: self.headerRequest()) { (response) in
                        if response.response?.statusCode == 204{
                            return DispatchQueue.main.async {
                                completion("success")
                            }
                        }
                    }
                }
            }
    }
    func raitingSender(data:RaitingModule,completion: @escaping (String)-> ()) {
        let url = "http://167.71.36.59:8000/api/main/field_review/"
        let parameters = data.convertToParameters()
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headerRequest()).validate().responseJSON{ (response) in
            if response.response?.statusCode == 201 {
                completion("success")
            }
            if response.response?.statusCode == 403 || response.response?.statusCode == 401 {
                self.refreshToken(url1: url, method: .post, parameters1: parameters, encoding: JSONEncoding.default, headers: self.headerRequest()) { (response) in
                    completion("success")
                    
                }
            }
        }
    }
    
    func getFieldById(id:String,completion: @escaping (MainViewModel)->()){
        let url = "http://167.71.36.59:8000/api/main/field/\(id)/"
        AF.request(url,method: .get,headers: headerRequest())
            .validate().responseJSON(){ (response) in
                if response.response?.statusCode == 200{
                    if let data = response.data {
                        let user = try! JSONDecoder().decode(MainViewModel.self, from: data)
                        completion(user)
                    }
                }
            }
    }
    
    func refreshToken(url1:String,method:HTTPMethod,parameters1: [String:Any]?,encoding: ParameterEncoding,headers: HTTPHeaders, completion: @escaping( AFDataResponse<Any>)->()){
        let url = "http://167.71.36.59:8000/api/auth/refresh/"
        let parameters = ["token":DataManager.sharedInstance.getCredentials().accessToken]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseDecodable(of: refreshToken2.self){ (response) in
            let credent = Credentials()
            credent.accessToken = response.value!.token
            credent.phoneNumber = DataManager.sharedInstance.getCredentials().phoneNumber
            credent.type = DataManager.sharedInstance.getCredentials().type
            credent.full_name = DataManager.sharedInstance.getCredentials().full_name
            credent.credentialID = "Person"
            DataManager.sharedInstance.addCredentials(object: credent)
            let headers: HTTPHeaders = [
                "Authorization" : "Bearer  \(DataManager.sharedInstance.getCredentials().accessToken)",
                "Conctent-Type": "application/json"
            ]
            AF.request(url1, method: method, parameters: parameters1, encoding: encoding,headers: headers).validate().responseJSON(){ (response) in
                completion(response)
            }
        }
    }
}
