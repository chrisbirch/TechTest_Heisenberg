import Foundation
import XCTest
@testable import ProjectHeisenberg

class UnitTestCase: XCTestCase {
    var mockNetworkService: MockNetworkService!
    
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
    }
    
    // MARK: - Subclassing

    func createMockNetworkService() -> MockNetworkService? {
        return MockNetworkService()
    }
    func createMockCharacterService() -> MockNetworkService? {
        return MockNetworkService()
    }
}
