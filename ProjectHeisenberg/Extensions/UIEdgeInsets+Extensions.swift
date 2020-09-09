import UIKit

extension UIEdgeInsets {
    init(uniform: CGFloat) {
        self.init(top: uniform, left: uniform, bottom: uniform, right: uniform)
    }
    
    static func * (lhs: UIEdgeInsets, scaler: CGFloat) -> UIEdgeInsets {
       var insets = lhs
       insets.left *= scaler
       insets.right *= scaler
        insets.top *= scaler
        insets.bottom *= scaler
        return insets
    }
    
  static func uniform(_ value: CGFloat) -> UIEdgeInsets {
        .init(top: value, left: value, bottom: value, right: value)
    }
    
    @discardableResult func left(_ value: CGFloat) -> UIEdgeInsets {
        var new = self
        new.left = value
        return new
    }
    @discardableResult func right(_ value: CGFloat) -> UIEdgeInsets {
        var new = self
        new.right = value
        return new
    }
    @discardableResult func top(_ value: CGFloat) -> UIEdgeInsets {
        var new = self
        new.top = value
        return new
    }
    @discardableResult func bottom(_ value: CGFloat) -> UIEdgeInsets {
        var new = self
        new.bottom = value
        return new
    }
    
    @discardableResult func horizontal(_ value: CGFloat) -> UIEdgeInsets {
        var new = self
        new.left = value
        new.right = value
        return new
    }
    @discardableResult func vertical(_ value: CGFloat) -> UIEdgeInsets {
        var new = self
        new.top = value
        new.bottom = value
        return new
    }
    
    var vertical: CGFloat {
        return top + bottom
    }
    var horizontal: CGFloat {
        return left + right
    }
    
    var cgPoint: CGPoint {
        return .init(x: left, y: top)
    }
}

public func uiedges(l: CGFloat? = nil, r: CGFloat? = nil, t: CGFloat? = nil, b: CGFloat? = nil) -> UIEdgeInsets {
    var edges = UIEdgeInsets.zero
    if let left = l {  edges.left = left }
    if let right = r { edges.right = right }
    if let top = t { edges.top = top }
    if let bottom = b { edges.bottom = bottom }
    return edges
}

public func uiedges(_ uniform: CGFloat) -> UIEdgeInsets {
    return .init(uniform: uniform)
}

public func uiedges(h: CGFloat? = nil, v: CGFloat? = nil) -> UIEdgeInsets {
    var edges = UIEdgeInsets.zero
    if let horizontal = h { edges = edges.horizontal(horizontal) }
    if let vertical = v { edges = edges.vertical(vertical) }
    return edges
}
