import Foundation


final class ClientService {
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    
    func fetchAllClient(page: Int, count: Int, param: String, completion: @escaping (Result<[ClientResponse], Error>) -> Void) {
        lastTask?.cancel()
        let request = allClientRequest(page: page, count: count, fullName: param)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<[ClientResponse], Error>) in
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
    
    func updateClient(clientId: Int, client: ClientRequest, completion: @escaping (Result<ClientResponse, Error>) -> Void) {
        lastTask?.cancel()
        let request = updateClientRequest(clientId: clientId, client: client)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<ClientResponse, Error>) in
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
    
    func addClient(client: ClientRequest, completion: @escaping (Result<ClientResponse, Error>) -> Void) {
        lastTask?.cancel()
        let request = addClientRequest(client: client)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<ClientResponse, Error>) in
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
    
    func deleteClient(clientId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        lastTask?.cancel()
        let request = deleteClientRequest(clientId: clientId)
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

private extension ClientService {
    
    func allClientRequest(page: Int, count: Int, fullName: String) -> URLRequest {
        var path = "/clients"
        if fullName != "" {
            path += "/find?fullName=\(fullName)&"
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
    
    func updateClientRequest(clientId: Int ,client: ClientRequest) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/clients/\(clientId)",
            httpMethod: "PUT",
            baseURL: DefaultBaseURL
        )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let jsonData = try? JSONEncoder().encode(client) {
            request.httpBody = jsonData
        }
        return request
    }
    
    func addClientRequest(client: ClientRequest) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/clients",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let jsonData = try? JSONEncoder().encode(client) {
            request.httpBody = jsonData
        }
        return request
    }
    
    func deleteClientRequest(clientId: Int) -> URLRequest {
        let request = URLRequest.makeHTTPRequest(
            path: "/clients/\(clientId)",
            httpMethod: "DELETE",
            baseURL: DefaultBaseURL
        )
        return request
    }
    

}
