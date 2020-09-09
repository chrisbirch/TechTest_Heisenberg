import UIKit

open class Control: UIControl {
    
    // MARK: - Inits
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    public init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    // MARK: - View lifecycle
    
    open func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        createSubviews()
    }
    open func createSubviews() {
        
    }
    
}
