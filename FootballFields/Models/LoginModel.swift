import Foundation

class LoginModel: Codable {
    let phone: String

    func convertToParameters() -> [String : String] {
        return ["phone_number": phone]
    }
    
    init(phone: String) {
        self.phone = phone
    }
}
