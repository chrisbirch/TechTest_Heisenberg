import XCTest
@testable import ProjectHeisenberg

class CharacterServiceTests: UnitTestCase {
    enum DummyErrors: Error {
        case networkError
    }
    var sut: CharacterService!
    
    var singleCharacterData: Data!
    var allCharactersData: Data!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        singleCharacterData = try TestDataHelpers.loadJSONDataFromBundle(filename: "SingleCharacter")
        allCharactersData = try TestDataHelpers.loadJSONDataFromBundle(filename: "AllCharacters")
        sut = Injected.characterService
    }
    
    override func createMockCharacterService() -> MockCharacterService? {
        return nil //We are testing this service
    }
    
    private func setupNetworkLayerWithAllCharactersMock() {
        let mockResponse = HTTPURLResponse(url: Character.Service.Contstants.Endpoints.character, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockNetworkService.returnResult = .success(.init(urlResponse: mockResponse, data: allCharactersData))
    }
    private func setupNetworkLayerWithSingleCharacterMock() {
        let mockResponse = HTTPURLResponse(url: Character.Service.Contstants.Endpoints.character, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockNetworkService.returnResult = .success(.init(urlResponse: mockResponse, data: singleCharacterData))
    }
    private func setupNetworkLayerWithError() {
        mockNetworkService.returnResult = .failure(DummyErrors.networkError)
    }
    
    func test_callAPI_whenHTTP200_thenCorrectNumberOfCharactersAreDecodedFromJSONAndReturned() throws {
        setupNetworkLayerWithAllCharactersMock()
        let expect = expectation(description: "Characters are downloaded and decoded")
        sut.retrieveCharacters(.init(returnFromCacheIfAvaiable: false, searchForName: nil, filterBySeason: nil), { result in
            switch result {
            case .success(let characters):
                XCTAssertEqual(characters.count, 63)
            case .failure:
                XCTFail("Should not have failed!")
            }
            expect.fulfill()
        })
        waitForExpectations(timeout: Test.testTimeout) { _ in }
    }
    
    
    func test_callAPI_whenHTTP200_thenOnlyBreakingBadCharactersAreReturned() throws {
        setupNetworkLayerWithAllCharactersMock()
        let expect = expectation(description: "Breaking bad chars only")
        sut.retrieveCharacters(.init(returnFromCacheIfAvaiable: false, searchForName: nil, filterBySeason: nil), { result in
            switch result {
            case .success(let characters):
                XCTAssertEqual(characters.count, 57)
            case .failure:
                XCTFail("Should not have failed!")
            }
            expect.fulfill()
        })
        waitForExpectations(timeout: Test.testTimeout) { _ in }
    }
    
    
    func test_callAPI_whenHTTP200AndReturnsSingleCharacter_thenCharacterIsCorrectlyDecoded() throws {
        setupNetworkLayerWithSingleCharacterMock()
        let expect = expectation(description: "Character is downloaded and decoded")
        sut.retrieveCharacters(.init(returnFromCacheIfAvaiable: false, searchForName: nil, filterBySeason: nil), { result in
            switch result {
            case .success(let characters):
                guard let character = characters.first else {
                    XCTFail("No character has been decoded")
                    return
                }
                
                XCTAssertEqual(character.charID, 7)
                XCTAssertEqual(character.name, "Mike Ehrmantraut")
                XCTAssertEqual(character.portrayed, "Jonathan Banks")
                XCTAssertEqual(character.occupation,  ["Hitman", "Private Investigator", "Ex-Cop"])
                XCTAssertEqual(character.img, "https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_mike-ehrmantraut-lg.jpg")
                XCTAssertEqual(character.status, .deceased)
                XCTAssertEqual(character.nickname, "Mike")
                XCTAssertEqual(character.appearance,  [2, 3, 4, 5])
                
            case .failure:
                XCTFail("Should not have failed!")
            }
            expect.fulfill()
        })
        waitForExpectations(timeout: Test.testTimeout) { _ in }
    }
    func test_callAPI_whenOtherThanHTTP200_thenErrorIsThrown() throws {
        setupNetworkLayerWithError()
        let expect = expectation(description: "Network error is returned")
        sut.retrieveCharacters(.init(returnFromCacheIfAvaiable: false, searchForName: nil, filterBySeason: nil), { result in
            switch result {
            case .success:
                XCTFail("Should not have failed!")
            case .failure:
                break
            }
            expect.fulfill()
        })
        waitForExpectations(timeout: Test.testTimeout) { _ in }
    }
    
    func test_userFiltersOnSeason_thenOnlyCharactersFromSelectedSeasonAreReturned() throws {
        setupNetworkLayerWithAllCharactersMock()
        let expect = expectation(description: "Characters from filtered season are downloaded and decoded")
        sut.retrieveCharacters(.init(returnFromCacheIfAvaiable: false, searchForName: nil, filterBySeason: [2]), { result in
            switch result {
            case .success(let characters):
                XCTAssertEqual(characters.count, 36)
            case .failure:
                XCTFail("Should not have failed!")
            }
            expect.fulfill()
        })
        waitForExpectations(timeout: Test.testTimeout) { _ in }
    }
    func test_userSearchesForCharacterName_thenCorrectCharacterIsReturned() throws {
        setupNetworkLayerWithAllCharactersMock()
        let expect = expectation(description: "Only characters whose names match are returned")
        sut.retrieveCharacters(.init(returnFromCacheIfAvaiable: false, searchForName: "walt", filterBySeason: nil), { result in
            switch result {
            case .success(let characters):
                guard characters.count == 2 else {
                    XCTFail("Wrong number of characters returned")
                    return
                }
                let expectedWalterWhite = characters[0]
                let expectedWaltJunior = characters[1]
                
                XCTAssertEqual(expectedWalterWhite.name, "Walter White")
                XCTAssertEqual(expectedWaltJunior.name, "Walter White Jr.")
            case .failure:
                XCTFail("Should not have failed!")
            }
            expect.fulfill()
        })
        waitForExpectations(timeout: Test.testTimeout) { _ in }
    }
    func test_userSearchesForCharacterNameUppercased_thenCorrectCharacterIsReturned() throws {
           setupNetworkLayerWithAllCharactersMock()
           let expect = expectation(description: "Only characters whose names match are returned")
           sut.retrieveCharacters(.init(returnFromCacheIfAvaiable: false, searchForName: "WALT", filterBySeason: nil), { result in
               switch result {
               case .success(let characters):
                   guard characters.count == 2 else {
                       XCTFail("Wrong number of characters returned")
                       return
                   }
                   let expectedWalterWhite = characters[0]
                   let expectedWaltJunior = characters[1]
                   
                   XCTAssertEqual(expectedWalterWhite.name, "Walter White")
                   XCTAssertEqual(expectedWaltJunior.name, "Walter White Jr.")
               case .failure:
                   XCTFail("Should not have failed!")
               }
               expect.fulfill()
           })
           waitForExpectations(timeout: Test.testTimeout) { _ in }
       }
}
