import Foundation

struct TestDataHelpers {
    enum DataLoadError: Error {
        case couldntLoadJSON
    }
    static func loadJSONDataFromBundle(filename: String) throws -> Data {
        let bundle = Bundle(for: UnitTestCase.self)
        guard let path = bundle.path(forResource: filename, ofType: "json") else {
            throw DataLoadError.couldntLoadJSON
        }
        let url = URL(fileURLWithPath: path)
        return try Data(contentsOf: url)
    }
    
}
