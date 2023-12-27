import Foundation


struct ClientProcedureRequest: Codable {
    let clientId, procedureId, count: Int
}


struct ClientProcedureResponse: Codable {
    let client: ClientResponse
    let procedure: ProcedureResponse
    let count: Int
}
