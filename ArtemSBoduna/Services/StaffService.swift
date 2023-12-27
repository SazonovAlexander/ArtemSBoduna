import Foundation

    
final class StaffService {
    private let urlSession = URLSession.shared
    private var lastTask: URLSessionTask?
    
    func fetchAllStaff(page: Int, count: Int, param: String, completion: @escaping (Result<[StaffResponse], Error>) -> Void) {
        lastTask?.cancel()
        let request = allStaffRequest(page: page, count: count, fullName: param)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<[StaffResponse], Error>) in
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
    
    func updateStaff(StaffId: Int, Staff: StaffRequest, completion: @escaping (Result<StaffResponse, Error>) -> Void) {
        lastTask?.cancel()
        let request = updateStaffRequest(StaffId: StaffId, Staff: Staff)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<StaffResponse, Error>) in
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
    
    func addStaff(Staff: StaffRequest, completion: @escaping (Result<StaffResponse, Error>) -> Void) {
        lastTask?.cancel()
        let request = addStaffRequest(Staff: Staff)
        let task = urlSession.objectTask(for: request, completion: { (result: Result<StaffResponse, Error>) in
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
    
    func deleteStaff(StaffId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        lastTask?.cancel()
        let request = deleteStaffRequest(StaffId: StaffId)
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

private extension StaffService {
    
    func allStaffRequest(page: Int, count: Int, fullName: String) -> URLRequest {
        var path = "/staffs"
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
    
    func updateStaffRequest(StaffId: Int ,Staff: StaffRequest) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/staffs/\(StaffId)",
            httpMethod: "PUT",
            baseURL: DefaultBaseURL
        )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let jsonData = try? JSONEncoder().encode(Staff) {
            request.httpBody = jsonData
        }
        return request
    }
    
    func addStaffRequest(Staff: StaffRequest) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/staffs",
            httpMethod: "POST",
            baseURL: DefaultBaseURL
        )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let jsonData = try? JSONEncoder().encode(Staff) {
            request.httpBody = jsonData
        }
        return request
    }
    
    func deleteStaffRequest(StaffId: Int) -> URLRequest {
        let request = URLRequest.makeHTTPRequest(
            path: "/staffs/\(StaffId)",
            httpMethod: "DELETE",
            baseURL: DefaultBaseURL
        )
        return request
    }
    

}

