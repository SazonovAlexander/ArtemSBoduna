import Foundation


final class ProcedureRoomService {
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    
    func fetchAllProcedureRoom(page: Int, count: Int, completion: @escaping (Result<[ProcedureRoomResponse], Error>) -> Void) {
        lastTask?.cancel()
        let request = allProcedureRoomRequest(page: page, count: count)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<[ProcedureRoomResponse], Error>) in
            switch result {
            case .success(let rooms):
                completion(.success(rooms))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
    
    func updateProcedureRoom(ProcedureRoomId: Int, ProcedureRoom: ProcedureRoomRequest, completion: @escaping (Result<ProcedureRoomResponse, Error>) -> Void) {
        lastTask?.cancel()
        let request = updateProcedureRoomRequest(ProcedureRoomId: ProcedureRoomId, ProcedureRoom: ProcedureRoom)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<ProcedureRoomResponse, Error>) in
            switch result {
            case .success(let ProcedureRooms):
                completion(.success(ProcedureRooms))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
    
    func addProcedureRoom(ProcedureRoom: ProcedureRoomRequest, completion: @escaping (Result<ProcedureRoomResponse, Error>) -> Void) {
        lastTask?.cancel()
        let request = addProcedureRoomRequest(ProcedureRoom: ProcedureRoom)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<ProcedureRoomResponse, Error>) in
            switch result {
            case .success(let ProcedureRoom):
                completion(.success(ProcedureRoom))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
    
    func deleteProcedureRoom(ProcedureRoomId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        lastTask?.cancel()
        let request = deleteProcedureRoomRequest(ProcedureRoomId: ProcedureRoomId)
        let task = urlSession.completeTask(for: request, completion: { (result: Result<Bool, Error>) in
            switch result {
            case .success(let complete):
                completion(.success(complete))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
    
}


private extension ProcedureRoomService {
    
    func allProcedureRoomRequest(page: Int, count: Int) -> URLRequest {
        var path = "/procedureRooms?page=\(page)&size=\(count)"
        let request = URLRequest.makeHTTPRequest(
            path: path,
            httpMethod: "GET",
            baseURL: DefaultBaseURL
        )
        return request
    }
    
    func updateProcedureRoomRequest(ProcedureRoomId: Int ,ProcedureRoom: ProcedureRoomRequest) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/procedureRooms/\(ProcedureRoomId)",
            httpMethod: "PUT",
            baseURL: DefaultBaseURL
        )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let jsonData = try? JSONEncoder().encode(ProcedureRoom) {
            request.httpBody = jsonData
        }
        return request
    }
    
    func addProcedureRoomRequest(ProcedureRoom: ProcedureRoomRequest) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/procedureRooms",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let jsonData = try? JSONEncoder().encode(ProcedureRoom) {
            request.httpBody = jsonData
        }
        return request
    }
    
    func deleteProcedureRoomRequest(ProcedureRoomId: Int) -> URLRequest {
        let request = URLRequest.makeHTTPRequest(
            path: "/procedureRooms/\(ProcedureRoomId)",
            httpMethod: "DELETE",
            baseURL: DefaultBaseURL
        )
        return request
    }
    

}
