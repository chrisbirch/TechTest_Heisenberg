import UIKit

class SearchBar: UISearchBar, UISearchBarDelegate {
    
    var searchDelay = TimeInterval(0.6)
    private var timer: Timer?
    var textChanged: Handler<String>?
    
    @discardableResult  func searchDelay(_ time: TimeInterval) -> Self {
        searchDelay = time
        return self
    }
    
    @discardableResult  func textChanged(_ handler: @escaping Handler<String>) -> Self {
        textChanged = handler
        return self
    }
    // MARK: - Inits
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    public init() {
        super.init(frame: .zero)
        commonInit()
    }
    public init(placeholder: String) {
        super.init(frame: .zero)
        commonInit()
        self.placeholder = placeholder ?? ""
    }
    
    // MARK: - View lifecycle
    
    func commonInit() {
        delegate = self
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let timer = timer { timer.invalidate() }
        timer = Timer.scheduledTimer(withTimeInterval: searchDelay, repeats: false) {[weak self] timer in
            guard let self = self else { return }
            self.textChanged?(searchBar.text ?? "")
            timer.invalidate()
            self.timer = nil
        }
    }
}
