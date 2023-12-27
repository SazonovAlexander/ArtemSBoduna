import Foundation


struct StaffResponse: Codable {
    let id: Int
    let fullName, phoneNumber: String
    let summa: Int
}

struct StaffRequest: Codable {
    let fullName, phoneNumber: String
}
