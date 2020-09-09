import Foundation
extension Character {
    struct Character: Codable {
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
        let status: Status
        let nickname: String
        let appearance: [Int]
        
        enum CodingKeys: String, CodingKey {
            case charID = "char_id"
            case name, occupation, img, status, nickname, appearance
        }
    }

}
