import UIKit

class SeasonView: View {
    let stackView = StackView(.horizontal, alignment: .center, distribution: .fillEqually, spacing: 7)

    var seasons: [Int]? {
        didSet {
            updateSeasonViews()
        }
    }
    
    override func createSubviews() {
        add(view: stackView, .rectMargins)
    }

    private func updateSeasonViews() {
        stackView.removeAllArrangedSubviews()
        guard let seasons = seasons else { return }
        stackView.add(seasons.map { seasonNum in
            let label = UILabel()
                .set(width: 20, height: 20)
                .cornerRadius(10)
                .backgroundColour(UIColor.white.withAlphaComponent(0.7))
                .border(1, UIColor.white.withAlphaComponent(1))
                
            label.textAlignment = .center
            label.text = "\(seasonNum)"
            return label
        })
        
    }
    
}
