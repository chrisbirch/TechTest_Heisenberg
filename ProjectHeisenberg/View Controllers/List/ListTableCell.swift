import UIKit

extension ListViewController {

    class ListTableCell: UITableViewCell {
        static let reuseIdentifier = "ListTableCell"
        
        let imgThumb = ImageView()
            .setImage(size: CGSize(width: 45, height: 45), .init(top: 4, left: 4, bottom: 4, right: 4), forceImageSizeConstraints: true)
            
        let lbName = UILabel()
        private lazy var stackView = StackView(.horizontal, spacing: 10, [
            imgThumb,
            lbName
        ])
        
        var model: Character.Character? {
            didSet {
                guard let model = model else { return }
                imgThumb.image = UIImage(named: "Placeholder")
                imgThumb.imageURL = URL(string: model.img)
                lbName.text = model.name
            }
        }
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            createSubViews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func createSubViews() {
            add(view: stackView)
            lbName.textColor = .white
            backgroundColor = UIColor.black.withAlphaComponent(0.75)
            imgThumb.contentMode = .scaleAspectFit
            
        }
    }
}
