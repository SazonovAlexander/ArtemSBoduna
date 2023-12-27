import Foundation


struct LivingRoomResponse: Codable {
    let id, number, price: Int
    let status: Bool
}

struct LivingRoomRequest: Codable {
    let number, price: Int
    let status: Bool
}
