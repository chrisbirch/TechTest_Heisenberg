import Foundation

protocol CharacterService {
    func retrieveCharacters(_ request: Character.CharacterRequest, _ completion: @escaping Character.CharacterRetrievalHandler)
}

extension Character {
    typealias CharacterRetrievalHandler = Handler<Result<[Character], Error>>
    struct CharacterRequest {
        let returnFromCacheIfAvailable: Bool
        let searchForName: String?
        let filterBySeason: [Int]?
        
        init(returnFromCacheIfAvailable: Bool, searchForName: String? = nil, filterBySeason: [Int]? = nil) {
            self.returnFromCacheIfAvailable = returnFromCacheIfAvailable
            self.searchForName = searchForName
            self.filterBySeason = filterBySeason
        }
    }
    class Service: CharacterService {
        struct Contstants {
            struct Endpoints {
                static let character = URL(string: "https://breakingbadapi.com/api/characters")!
            }
        }
        func retrieveCharacters(_ request: CharacterRequest, _ completion: @escaping CharacterRetrievalHandler) {
            let network = Injected.networkService
            let cachePolicy: NSURLRequest.CachePolicy = request.returnFromCacheIfAvailable ? .returnCacheDataElseLoad : .reloadIgnoringLocalAndRemoteCacheData
            let urlRequest = URLRequest(url: Contstants.Endpoints.character, cachePolicy: cachePolicy, timeoutInterval: 60)
            network?.data(request: urlRequest, { result in
                switch result {
                case .success(let response):
                    do {
                        var characters = try JSONDecoder().decode([Character].self, from: response.data)
                        characters = characters.filter {$0.category != .betterCallSaul}
                        if let filterOnNameText = request.searchForName?.lowercased(), !filterOnNameText.isEmpty {
                            characters = characters.filter { $0.name.lowercased().contains(filterOnNameText)}
                        }
                        
                        if let filterBySesson = request.filterBySeason {
                            let filterSeasonSet = Set<Int>(filterBySesson)
                            characters = characters.filter { character in
                                var seasonSet = Set<Int>(character.appearance)
                                seasonSet.formIntersection(filterSeasonSet)
                                return !seasonSet.isEmpty
                            }
                        }
                        
                        completion(.success(characters))
                    }
                    catch {
                        completion(.failure(DownloadError.jsonParsingError))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
    }
}
