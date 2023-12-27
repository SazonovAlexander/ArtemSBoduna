import Foundation


struct ProcedureResponse: Codable {
    let id: Int
    let name: String
    let price: Int
    let staff: StaffResponse
    let procedureRoom: ProcedureRoomResponse
}




struct ProcedureRequest: Codable {
    let name: String
    let price, staffId, procedureRoomId: Int

}
