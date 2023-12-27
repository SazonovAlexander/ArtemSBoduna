import Foundation

    
final class ProcedureService {
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    
    func fetchAllProcedure(page: Int, count: Int, param: String, completion: @escaping (Result<[ProcedureResponse], Error>) -> Void) {
        lastTask?.cancel()
        let request = allProcedureRequest(page: page, count: count, fullName: param)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<[ProcedureResponse], Error>) in
            switch result {
            case .success(let staffs):
                completion(.success(staffs))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
    
    func updateProcedure(ProcedureId: Int, Procedure: ProcedureRequest, completion: @escaping (Result<ProcedureResponse, Error>) -> Void) {
        lastTask?.cancel()
        let request = updateProcedureRequest(ProcedureId: ProcedureId, Procedure: Procedure)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<ProcedureResponse, Error>) in
            switch result {
            case .success(let staffs):
                completion(.success(staffs))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
    
    func addProcedure(Procedure: ProcedureRequest, completion: @escaping (Result<ProcedureResponse, Error>) -> Void) {
        lastTask?.cancel()
        let request = addProcedureRequest(Procedure: Procedure)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<ProcedureResponse, Error>) in
            switch result {
            case .success(let staff):
                completion(.success(staff))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
    
    func deleteProcedure(ProcedureId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        lastTask?.cancel()
        let request = deleteProcedureRequest(ProcedureId: ProcedureId)
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

private extension ProcedureService {
    
    func allProcedureRequest(page: Int, count: Int, fullName: String) -> URLRequest {
        var path = "/procedures"
        if fullName != "" {
            path += "/find?name=\(fullName)&"
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
    
    func updateProcedureRequest(ProcedureId: Int ,Procedure: ProcedureRequest) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/procedures/\(ProcedureId)",
            httpMethod: "PUT",
            baseURL: DefaultBaseURL
        )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let jsonData = try? JSONEncoder().encode(Procedure) {
            request.httpBody = jsonData
        }
        return request
    }
    
    func addProcedureRequest(Procedure: ProcedureRequest) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/procedures",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let jsonData = try? JSONEncoder().encode(Procedure) {
            request.httpBody = jsonData
        }
        return request
    }
    
    func deleteProcedureRequest(ProcedureId: Int) -> URLRequest {
        let request = URLRequest.makeHTTPRequest(
            path: "/procedures/\(ProcedureId)",
            httpMethod: "DELETE",
            baseURL: DefaultBaseURL
        )
        return request
    }
    

}

