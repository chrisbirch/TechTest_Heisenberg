import UIKit

class SeasonFilterBar: View {
    let lbTitle = UILabel()
    let buttonStackView = StackView(distribution: .fillEqually)
    let stackView = StackView(.vertical, distribution: .fillEqually)
    typealias SeasonsSelected = ((_ seasons: [Int]?) -> Void)
    var seasonsSelected: SeasonsSelected?
    var buttonGroup: ButtonGroup!
    
    @discardableResult func seasonsSelected(_ handler: SeasonsSelected?) -> Self {
        seasonsSelected = handler
        return self
    }
    
    override func createSubviews() {
        super.createSubviews()
        var buttons = [Button]()
        for i in 1...5 {
            let button = Button(title: "\(i)")
                .touchUpInside {[unowned self] _ in
                    let selectedSeasonNumbers = self.buttonGroup.selectedButtons.map {$0.tag}
                    self.seasonsSelected?(selectedSeasonNumbers.isEmpty ? nil : selectedSeasonNumbers)
                }
            if let titleLabel = button.label(.title) {
                titleLabel.textAlignment = .center
                titleLabel.textColor = .white
            }
            
            buttons.append(button)
            button.tag = i
        }
        lbTitle.text = "Select season"
        lbTitle.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        lbTitle.textColor = .white
        lbTitle.textAlignment = .center
        let buttonContainer = View()
        buttonContainer.add(view: buttonStackView, Edges(2))
        buttonContainer.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        stackView.add([lbTitle, buttonStackView])
        buttonStackView.add(buttons)
        buttonGroup = ButtonGroup("Seasons", buttons)
        buttonGroup.allowsMultipleSelection = true
        add(view: stackView)
    }
    
    override var intrinsicContentSize: CGSize {
        .init(width: 100, height: 34)
    }
}
