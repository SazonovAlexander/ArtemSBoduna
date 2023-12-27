import Foundation


struct StaffResponse: Codable {
    let id: Int
    let fullName, phoneNumber: String
}

struct StaffRequest: Codable {
    let fullName, phoneNumber: String
}
