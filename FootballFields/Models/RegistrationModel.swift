import Foundation

class RegistrationModel: Codable {
    let name: String
    let phone: String
    let type: Int

    func convertToParameters() -> [String : Any] {
        return ["full_name": name, "phone_number": phone,"type": type]
    }
    
    init(name: String, phone: String,type: Int) {
        self.name = name
        self.phone = phone
        self.type = type
    }
}
