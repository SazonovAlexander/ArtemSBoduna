import Foundation


struct ClientProcedureRequest: Codable {
    let clientID, procedureID, count: Int
}


struct ClientProcedureResponse: Codable {
    let client: ClientResponse
    let procedure: ProcedureResponse
    let count: Int
}
