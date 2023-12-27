import Foundation

struct ClientRequest: Codable {
    let fullName, phoneNumber, address: String
    let livingRoomID: Int


}

struct ClientResponse: Codable {
    let id: Int
    let fullName, phoneNumber, address: String
    let summa: Int
    let livingRoom: LivingRoomResponse
}

