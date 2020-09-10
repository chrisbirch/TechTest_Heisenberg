import UIKit

class AlignmentView<T>: View where T: UIView {
    enum AlignmentOption {
        case center
    }
    let contentView: T
    var alignment: AlignmentOption = .center {
        didSet {
            createAlignmentConstraints()
        }
    }
    
    init(contentView: T? = nil) {
        self.contentView = contentView ?? T.self.init()
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createAlignmentConstraints() {
        contentView.removeFromSuperview()
        switch alignment {
        case .center:
            add(view: contentView, .middle)
        }
    }
    override func createSubviews() {
        createAlignmentConstraints()
    }
    
    override var intrinsicContentSize: CGSize {
        contentView.intrinsicContentSize
    }
}
