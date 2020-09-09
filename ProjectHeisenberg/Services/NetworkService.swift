import Foundation
struct NetworkResponse {
    let urlResponse: HTTPURLResponse
    let data: Data
    var utf8Value: String? {
        guard !data.isEmpty else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}

typealias NetworkHandler = ((Result<NetworkResponse, Error>) -> Void)
protocol NetworkService: class {
    func data(request: URLRequest, _ handler: @escaping NetworkHandler)
}

extension Network {
    class Service: NetworkService {
        let urlSession = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        func data(request: URLRequest, _ handler: @escaping NetworkHandler) {
            self.urlSession.dataTask(with: request, completionHandler: {(data, urlResponse, error) in
                //call back on main thread
                delayedCall {
                    if let error = error {
                        handler(.failure(error))
                    } else {
                        handler(.success(NetworkResponse(urlResponse: urlResponse as! HTTPURLResponse, data: data ?? Data())))
                        
                    }
                }
            }).resume()
        }
    }
}
