import UIKit
class BusyView: View {
    
    enum State {
        case retry
        case busy
    }
    
    var state = State.busy {
        didSet {
            updateForState()
        }
    }
    var retryHandler: VoidHandler?
    
    let lbTitle = UILabel()
    let spinny = UIActivityIndicatorView(style: .large)
    lazy private var btnRetry = Button(title: "Retry").touchUpInside { _ in
        self.retryHandler?()
    }
    private lazy var stackView = StackView(.vertical, distribution: .fill, spacing: 10, [lbTitle, AlignmentView<UIActivityIndicatorView>(contentView: spinny), btnRetry])
    var spinnyStyle: UIActivityIndicatorView.Style {
        get {
            return spinny.style
        }
        set {
            spinny.style = newValue
        }
    }
    override  func commonInit() {
        super.commonInit()
    }
    
    var loadingText = ""
    
    private func updateForState() {
        switch state {
        case .busy:
            lbTitle.text = loadingText
            spinny.isHidden = false
            btnRetry.isHidden = true
        case .retry:
            lbTitle.text = "Whoops, something went wrong :("
            spinny.isHidden = true
            btnRetry.isHidden = false
            btnRetry.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
        }
    }
    
    override  func createSubviews() {
        add(view: stackView, .middle)
        if let buttonLabel = btnRetry.label(.title) {
            buttonLabel.textAlignment = .center
            buttonLabel.textColor = .white
        }
        
        lbTitle.textColor = .white
        backgroundColor = UIColor.black.withAlphaComponent(0.12)
        spinny.color = .white
        spinny.startAnimating()
        updateForState()
    }
    @discardableResult  func set(spinnyStyle: UIActivityIndicatorView.Style) -> Self {
        self.spinnyStyle = spinnyStyle
        return self
    }   
}
