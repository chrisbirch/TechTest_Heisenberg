import Foundation
import XCTest
@testable import ProjectHeisenberg

class UnitTestCase: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var mockCharacterService: MockCharacterService!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        Injected.reset()
        setupMocks()
    }
    
    func setupMocks() {
        if let mock = createMockNetworkService() {
            mockNetworkService = mock
            Injected.networkService = mock
        }
        if let mock = createMockCharacterService() {
            mockCharacterService = mock
            Injected.characterService = mock
        }
    }
    
    // MARK: - Subclassing

    func createMockNetworkService() -> MockNetworkService? {
        return MockNetworkService()
    }
    func createMockCharacterService() -> MockCharacterService? {
        return mockCharacterService()
    }
}
