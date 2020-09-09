import Foundation
@testable import ProjectHeisenberg
import XCTest

class MockNetworkService: NetworkService {
    var returnResult: Result<NetworkResponse, Error> = .success(
        .init(
            urlResponse: HTTPURLResponse(url: URL(string: "http://www.dummy.com/")!, statusCode: 200, httpVersion: nil, headerFields: nil)!,
            data: Data()
        )
    )
    var lastRequest: URLRequest?
    
    func data(request: URLRequest, _ handler: @escaping NetworkHandler) {
        lastRequest = request
        handler(returnResult)
    }
}
