import Foundation

public enum NetworkResult {
    case success(data: Data)
    case error(reason: Error)
    case unexpected
}

public extension URLSession {
    
    func getData(request: URLRequest, dataResponse: @escaping (NetworkResult) -> ()) {
        dataTask(with: request) { (serverData, serverResponse, networkError) in
            let validStatusCodeRange: ClosedRange<Int> = 200...299
            switch (serverData, serverResponse, networkError) {
            case (_, _, let error?):
                dataResponse(.error(reason: error))
            case(let data?, let response as HTTPURLResponse, _)
                where validStatusCodeRange.contains(response.statusCode):
                dataResponse(.success(data: data))
            default:
                dataResponse(.unexpected)
            }
        }.resume()
    }
}
