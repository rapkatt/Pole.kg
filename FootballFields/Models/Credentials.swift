import Foundation
import RealmSwift

class Credentials: Object {
    @objc dynamic var credentialID = UUID().uuidString
    @objc dynamic var accessToken: String = ""
    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var full_name: String = ""
    @objc dynamic var type: Int = 0
    
    override static func primaryKey() -> String? {
      return "credentialID"
    }
}
