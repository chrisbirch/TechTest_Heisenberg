import UIKit

class InfoFieldView<T>: View where T: UIView {
    let lbTitle = UILabel()
    let contentView: T
    var axis = NSLayoutConstraint.Axis.vertical {
        didSet {
            stackView.axis = axis
        }
    }
    private lazy var stackView = StackView(axis, spacing: 1)
    
    init(title: String, contentView: T? = nil) {
        self.contentView = contentView ?? T.self.init()
        self.lbTitle.text = title
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.layoutMargins = .zero
        stackView.add([lbTitle, UIView(), contentView])
        add(view: stackView, .rectMargins)
    }
}
