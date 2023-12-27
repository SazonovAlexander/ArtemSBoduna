import Foundation


final class LivingRoomService {
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    
    func fetchAllLivingRoom(page: Int, count: Int, param: String, completion: @escaping (Result<[LivingRoomResponse], Error>) -> Void) {
        lastTask?.cancel()
        let request = allLivingRoomRequest(page: page, count: count, fullName: param)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<[LivingRoomResponse], Error>) in
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
    
    func updateLivingRoom(livingRoomId: Int, livingRoom: LivingRoomRequest, completion: @escaping (Result<LivingRoomResponse, Error>) -> Void) {
        lastTask?.cancel()
        let request = updateLivingRoomRequest(livingRoomId: livingRoomId, livingRoom: livingRoom)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<LivingRoomResponse, Error>) in
            switch result {
            case .success(let livingRooms):
                completion(.success(livingRooms))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
    
    func addLivingRoom(livingRoom: LivingRoomRequest, completion: @escaping (Result<LivingRoomResponse, Error>) -> Void) {
        lastTask?.cancel()
        let request = addLivingRoomRequest(livingRoom: livingRoom)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<LivingRoomResponse, Error>) in
            switch result {
            case .success(let livingRoom):
                completion(.success(livingRoom))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
    
    func deleteLivingRoom(livingRoomId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        lastTask?.cancel()
        let request = deleteLivingRoomRequest(livingRoomId: livingRoomId)
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

private extension LivingRoomService {
    
    func allLivingRoomRequest(page: Int, count: Int, fullName: String) -> URLRequest {
        var path = "/livingRooms"
        if fullName != "" {
            path += "/find?param=\(fullName)&"
        }
        else {
            path += "?"
        }
        path += "page=\(page)&size=\(count)"
        let request = URLRequest.makeHTTPRequest(
            path: path,
            httpMethod: "GET",
            baseURL: DefaultBaseURL
        )
        return request
    }
    
    func updateLivingRoomRequest(livingRoomId: Int ,livingRoom: LivingRoomRequest) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/livingRooms/\(livingRoomId)",
            httpMethod: "PUT",
            baseURL: DefaultBaseURL
        )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let jsonData = try? JSONEncoder().encode(livingRoom) {
            request.httpBody = jsonData
        }
        return request
    }
    
    func addLivingRoomRequest(livingRoom: LivingRoomRequest) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/livingRooms",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let jsonData = try? JSONEncoder().encode(livingRoom) {
            request.httpBody = jsonData
        }
        return request
    }
    
    func deleteLivingRoomRequest(livingRoomId: Int) -> URLRequest {
        let request = URLRequest.makeHTTPRequest(
            path: "/livingRooms/\(livingRoomId)",
            httpMethod: "DELETE",
            baseURL: DefaultBaseURL
        )
        return request
    }
    

}

