import UIKit
class BusyView: View {
    let spinny = UIActivityIndicatorView(style: .large)
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
        backgroundColor = UIColor.black.withAlphaComponent(0.12)
        
        spinny.startAnimating()
        
    }
    override  func createSubviews() {
        add(view: spinny, .middle)
    }
    @discardableResult  func set(spinnyStyle: UIActivityIndicatorView.Style) -> Self {
        self.spinnyStyle = spinnyStyle
        return self
    }   
}
