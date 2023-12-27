import Foundation


extension URLRequest {
    
    static func makeHTTPRequest(
            path: String,
            httpMethod: String,
            baseURL: URL = DefaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        print(request)
        return request
    }
    
}

