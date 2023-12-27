import Foundation


struct ProcedureRoomResponse: Codable {
    let id: Int
    let number: Int
}

struct ProcedureRoomRequest: Codable {
    let number: Int
}
