import Foundation
import RealmSwift

class DataManager {
    var   database:Realm
    static let  sharedInstance = DataManager()
    
    init() {
        database = try! Realm()
    }
    
    func getCredentials() ->  Credentials{
        let results: Credentials = database.object(ofType: Credentials.self, forPrimaryKey: "Person") ?? Credentials()
        return results
    }
    
    func deleteUser(){
        let user = getCredentials()
        try! database.write {
            database.delete(user)
        }
    }
    func addCredentials(object: Credentials)   {
        try! database.write {
            database.add(object, update: .all)
        }
    }
}
