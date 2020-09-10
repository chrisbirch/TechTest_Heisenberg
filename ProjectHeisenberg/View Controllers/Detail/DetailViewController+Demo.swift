import UIKit

#if DEBUG
extension DetailViewController {
    static func createDemoInstance() -> DetailViewController {
        let jsonData =
        """
        {
            "char_id": 7,
            "name": "Mike Ehrmantraut",
            "birthday": "Unknown",
            "occupation": ["Hitman", "Private Investigator", "Ex-Cop"],
            "img": "https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_mike-ehrmantraut-lg.jpg",
            "status": "Deceased",
            "nickname": "Mike",
            "appearance": [2, 3, 4, 5],
            "portrayed": "Jonathan Banks",
            "category": "Breaking Bad, Better Call Saul",
            "better_call_saul_appearance": [1, 2, 3, 4]
        }
        """.data(using: .utf8)!
        let character = try! JSONDecoder().decode(Character.Character.self, from: jsonData)
        return DetailViewController(model: DetailViewControllerModel(character))
            
    }
}
#endif
