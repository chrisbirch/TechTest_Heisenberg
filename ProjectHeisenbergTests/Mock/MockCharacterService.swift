import Foundation
@testable import ProjectHeisenberg
import XCTest

class MockCharacterService: CharacterService {
    static let dummyCharacter = Character.Character(charID: 0, name: "Mr Test", occupation: ["Tester"], img: "http://anImage.com", status: .alive, nickname: "Mr Nickname", appearance: [1,2])
    var returnResult: Result<[Character.Character], Error> = .success(
        [dummyCharacter]
    )
    var lastRequest: Character.CharacterRequest?
    
    func retrieveCharacters(_ request: Character.CharacterRequest, _ completion: @escaping Character.CharacterRetrievalHandler) {
        lastRequest = request
        completion(returnResult)
    }
}
