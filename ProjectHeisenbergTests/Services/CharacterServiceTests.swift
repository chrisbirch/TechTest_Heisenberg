import XCTest
@testable import ProjectHeisenberg

class CharacterServiceTests: UnitTestCase {

    var sut: CharacterService!
        
    
    var singleCharacterData: Data!
    var allCharactersData: Data!
        
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        singleCharacterData = try TestDataHelpers.loadJSONDataFromBundle(filename: "SingleCharacter")
        allCharactersData = try TestDataHelpers.loadJSONDataFromBundle(filename: "AllCharacters")
        sut = Injected.characterService
    }

    override func createMockCharacterService() -> MockNetworkService? {
        return nil //We are testing this service
    }

    func test_callAPI_whenHTTP200_thenCorrectNumberOfCharactersAreDecodedFromJSONAndReturned() throws {
        
        XCTFail()
    }
    func test_callAPI_whenHTTP200AndReturnsSingleCharacter_thenCharacterIsCorrectlyDecoded() throws {
       
        XCTFail()
    }
    func test_callAPI_whenOtherThanHTTP200_thenErrorIsThrown() throws {
        XCTFail()
    }
    
    func test_userFiltersOnSeason_thenOnlyCharactersFromSelectedSeasonAreReturned() throws {
       
        XCTFail()
    }
    func test_userSearchesForCharacterName_thenCorrectCharacterIsReturned() throws {
       
        XCTFail()
    }
}
