import UIKit

extension UIView {
    func fadeTransition(_ duration: CFTimeInterval = 0.3) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

extension UIView {
    struct Actions: OptionSet {
        let rawValue: Int
        
        static let copy = Actions(rawValue: 1 << 0)
        static let paste = Actions(rawValue: 1 << 1)
        
        static let all: Actions = [.copy, .paste]
        
        init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }

 
    @discardableResult func resistCompression(_ priority: UILayoutPriority = .required, axis: Axis = .both) -> Self {
        if axis.contains(.horizontal) {
            setContentCompressionResistancePriority(priority, for: .horizontal)
        }
        if axis.contains(.vertical) {
            setContentCompressionResistancePriority(priority, for: .vertical)
        }
        return self
    }
    
    @discardableResult func hugContent(_ priority: UILayoutPriority = .required, axis: Axis = .both) -> Self {
        if axis.contains(.horizontal) {
            setContentHuggingPriority(priority, for: .horizontal)
        }
        if axis.contains(.vertical) {
            setContentHuggingPriority(priority, for: .vertical)
        }
        return self
    }
    
    var topLeft: CGPoint {
        return self.frame.origin
    }
    var topRight: CGPoint {
        return .init(x: self.frame.origin.x + self.frame.size.width, y: self.frame.origin.y)
    }
    var botLeft: CGPoint {
        return .init(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.size.height)
    }
    var botRight: CGPoint {
        return .init(x: self.frame.origin.x + self.frame.size.width, y: self.frame.origin.y + self.frame.size.height)
    }
    
    @discardableResult @objc func backgroundColour(_ colour: UIColor) -> Self {
        backgroundColor = colour
        return self
    }
    @discardableResult func visible(_ visible: Bool) -> Self {
        isHidden = !visible
        return self
    }
    
    @discardableResult func border(_ width: CGFloat, _ colour: UIColor?) -> Self {
        layer.borderWidth = width
        layer.borderColor = colour?.cgColor
        return self
    }
    
    @discardableResult func clips() -> Self {
        clipsToBounds = true
        return self
    }
 
    @discardableResult func content(_ mode: UIView.ContentMode) -> Self {
        contentMode = mode
        return self
    }
    
    @discardableResult func interaction(_ enabled: Bool) -> Self {
        isUserInteractionEnabled = enabled
        return self
    }
}

extension Array where Element == UIView {
    func removeFromSuperviews() {
        forEach { $0.removeFromSuperview() }
    }
}


extension UIView {
    func constraints(for type: NSLayoutConstraint.Attribute, firstView: UIView? = nil, secondView: UIView? = nil) -> [NSLayoutConstraint]? {
        let all = NSLayoutConstraint.ofKind(self.constraints, kinds: [type])
        return all.filter {
            (firstView == nil || ($0.firstItem as? UIView) == firstView) || (secondView == nil || ($0.secondItem as? UIView) == secondView)}
    }
    @discardableResult func removeConstraints(with types: [NSLayoutConstraint.Attribute]? = nil) -> Self {
        guard let types = types else {
            removeConstraints(constraints)
            return self
        }
        
        types.forEach { removeConstraints(constraints(for: $0) ?? []) }
        return self
    }
    
    @discardableResult func removeSizeConstraints() -> Self {
        removeConstraints(with: [.width, .height])
    }
}

struct ViewHelpers {
    @discardableResult static func set(x: CGFloat? = nil, y: CGFloat? = nil, on view: UIView) -> (left: NSLayoutConstraint?, top: NSLayoutConstraint?) {
        
        let leading = view.constraints(for: .leading, secondView: view)
        let top = view.constraints(for: .top, secondView: view)
        var constraintLeading = leading?.first
        var constraintTop = top?.first
        
        constraintLeading = nil
        constraintTop = nil
        if let x = x {
            if let constraintLeading = constraintLeading {
                constraintLeading.constant = x
            } else {
                //                constraintLeading = view.superview!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -x)
                constraintLeading = view.leadingAnchor.constraint(equalTo: view.superview!.leadingAnchor, constant: x)
            }
            constraintLeading!.isActive = true
        }
        if let y = y {
            if let constraintTop = constraintTop {
                constraintTop.constant = y
            } else {
                constraintTop = view.topAnchor.constraint(equalTo: view.superview!.topAnchor, constant: y)
                //                constraintTop = view.superview!.topAnchor.constraint(equalTo: view.topAnchor, constant: y)
                
            }
            constraintTop!.isActive = true
        }
        
        return (left: constraintLeading, top: constraintTop)
    }
    @discardableResult static func set(width: CGFloat? = nil, height: CGFloat? = nil, on view: UIView, _ margins: UIEdgeInsets? = nil) -> (width: NSLayoutConstraint?, height: NSLayoutConstraint?) {
        
        var constraintWidth: NSLayoutConstraint? = view.constraints(for: .width)?.first
        var constraintHeight: NSLayoutConstraint? = view.constraints(for: .height)?.first
        if let width = width {
            if let constraintWidth = constraintWidth {
                constraintWidth.constant = width
            } else {
                constraintWidth = view.widthAnchor.constraint(equalToConstant: width)
            }
            constraintWidth!.isActive = true
        }
        if let height = height {
            if let constraintHeight = constraintHeight {
                constraintHeight.constant = height
            } else {
                constraintHeight = view.heightAnchor.constraint(equalToConstant: height)
                
            }
            constraintHeight!.isActive = true
        }
        if let margins = margins {
            view.layoutMargins = margins
        }
        
        return (width: constraintWidth, height: constraintHeight)
    }
    @discardableResult static func set(size: CGSize, on view: UIView, _ margins: UIEdgeInsets? = nil) -> (width: NSLayoutConstraint?, height: NSLayoutConstraint?) {
        set(width: size.width, height: size.height, on: view, margins)
    }
    @discardableResult static func set(square: CGFloat, on view: UIView, margins: UIEdgeInsets? = nil) -> (width: NSLayoutConstraint?, height: NSLayoutConstraint?) {
        set(width: square, height: square, on: view, margins)
    }
}
