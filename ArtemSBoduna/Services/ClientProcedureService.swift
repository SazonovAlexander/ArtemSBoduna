import Foundation


final class ClientProcedureService {
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    
    func fetchProcedure(clientId: Int, completion: @escaping (Result<[ClientProcedureResponse], Error>) -> Void) {
        lastTask?.cancel()
        let request = allClientProcedureRequest(clientId: clientId)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<[ClientProcedureResponse], Error>) in
            switch result {
            case .success(let client):
                completion(.success(client))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
    
    func updateClientProcedure(clientId: Int, procId: Int,client: ClientProcedureRequest, completion: @escaping (Result<ClientProcedureResponse, Error>) -> Void) {
        lastTask?.cancel()
        let request = updateClientRequest(clientId: clientId, procedureId: procId, procClient: client)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<ClientProcedureResponse, Error>) in
            switch result {
            case .success(let client):
                completion(.success(client))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
    
    func addClientProcedure(client: ClientProcedureRequest, completion: @escaping (Result<ClientProcedureResponse, Error>) -> Void) {
        lastTask?.cancel()
        let request = addClientRequest(procClient: client)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<ClientProcedureResponse, Error>) in
            switch result {
            case .success(let client):
                completion(.success(client))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        lastTask = task
        task.resume()
    }
    
    func deleteClientProcedure(clientId: Int, procId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        lastTask?.cancel()
        let request = deleteClientRequest(clientId: clientId, procedureId: procId)
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

private extension ClientProcedureService {
    
    func updateClientRequest(clientId: Int , procedureId: Int, procClient: ClientProcedureRequest) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/procedure/client/\(clientId)/\(procedureId)",
            httpMethod: "PUT",
            baseURL: DefaultBaseURL
        )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let jsonData = try? JSONEncoder().encode(procClient) {
            print(procClient)
            request.httpBody = jsonData
        }
        return request
    }
    
    func addClientRequest(procClient: ClientProcedureRequest) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/procedure/client",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let jsonData = try? JSONEncoder().encode(procClient) {
            request.httpBody = jsonData
        }
        return request
    }
    
    func deleteClientRequest(clientId: Int , procedureId: Int) -> URLRequest {
        let request = URLRequest.makeHTTPRequest(
            path: "/procedure/client/\(clientId)/\(procedureId)",
            httpMethod: "DELETE",
            baseURL: DefaultBaseURL
        )
        return request
    }
    

    func allClientProcedureRequest(clientId: Int) -> URLRequest {
        let request = URLRequest.makeHTTPRequest(
            path: "/client/procedure/\(clientId)",
            httpMethod: "GET",
            baseURL: DefaultBaseURL
        )
        return request
    }
}

