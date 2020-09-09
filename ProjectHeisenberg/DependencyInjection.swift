/*
 The following is an extremely simple DI solution.
 */
import Foundation

struct Injected {
    static var networkService: NetworkService!
    
    static func reset() {
        networkService = Network.Service()
    }
}
