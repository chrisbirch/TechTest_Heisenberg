import Foundation
extension Character {
    struct Character: Codable {
        enum Category: String, Codable {
            case betterCallSaul = "Better Call Saul"
            case breakingBad = "Breaking Bad"
            case breakingBadBetterCallSaul = "Breaking Bad, Better Call Saul"
        }

        enum Status: String, Codable {
            case alive = "Alive"
            case deceased = "Deceased"
            case empty = "?"
            case presumedDead = "Presumed dead"
            case unknown = "Unknown"
        }

        
        let charID: Int
        let name: String
        let occupation: [String]
        let img: String
        let category: Category
        let status: Status
        let portrayed: String
        let nickname: String
        let appearance: [Int]
        
        enum CodingKeys: String, CodingKey {
            case charID = "char_id"
            case portrayed, name, category, occupation, img, status, nickname, appearance
        }
    }

}
