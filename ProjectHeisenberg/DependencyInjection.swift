/*
 The following is an extremely simple DI solution.
 */
import Foundation

struct Injected {
    static var networkService: NetworkService!
    static var characterService: CharacterService!
    
    static func reset() {
        networkService = Network.Service()
        characterService = Character.Service()
    }
}
