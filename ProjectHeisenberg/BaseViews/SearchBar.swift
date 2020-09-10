import UIKit

class SearchBar: UISearchBar {
    
    var searchDelay = TimeInterval(0.6)
    private var timer: Timer?
    var textChanged: Handler<String>?
    var endedEditing: VoidHandler?
    var beganEditing: VoidHandler?
    
    @discardableResult  func searchDelay(_ time: TimeInterval) -> Self {
        searchDelay = time
        return self
    }
    
    @discardableResult  func textChanged(_ handler: @escaping Handler<String>) -> Self {
        textChanged = handler
        return self
    }
    // MARK: - Inits
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    init(placeholder: String) {
        super.init(frame: .zero)
        commonInit()
        self.placeholder = placeholder
    }
    
    // MARK: - View lifecycle
    
    func commonInit() {
        delegate = self
    }
    
}
extension SearchBar: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        endedEditing?()
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        beganEditing?()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let timer = timer { timer.invalidate() }
        timer = Timer.scheduledTimer(withTimeInterval: searchDelay, repeats: false) {[weak self] timer in
            guard let self = self else { return }
            self.textChanged?(searchBar.text ?? "")
            timer.invalidate()
            self.timer = nil
        }
    }
}
