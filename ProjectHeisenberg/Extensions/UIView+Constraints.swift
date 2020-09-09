import UIKit

extension UIView {
    @discardableResult func set(size: CGSize, _ margins: UIEdgeInsets? = nil) -> Self {
        ViewHelpers.set(size: size, on: self, margins)
        return self
    }
    @discardableResult func set(width: CGFloat? = nil, height: CGFloat? = nil, _ margins: UIEdgeInsets? = nil) -> Self {
        ViewHelpers.set(width: width, height: height, on: self, margins)
        return self
    }
    @discardableResult func set(square: CGFloat, margins: UIEdgeInsets? = nil) -> Self {
        ViewHelpers.set(square: square, on: self, margins: margins)
        return self
    }
    @discardableResult func set(x: CGFloat? = nil, y: CGFloat? = nil) -> Self {
        ViewHelpers.set(x: x, y: y, on: self)
        return self
    }
    @discardableResult func set(origin: CGPoint) -> Self {
        ViewHelpers.set(x: origin.x, y: origin.y, on: self)
        return self
    }
    
    @discardableResult func cornerRadius(_ radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        return self
    }
    
    @discardableResult func border(_ thickness: CGFloat, _ colour: UIColor) -> Self {
        layer.borderWidth = thickness
        layer.borderColor = colour.cgColor
        return self
    }
    
    @discardableResult func layoutMargins(_ insets: UIEdgeInsets) -> Self {
        layoutMargins = insets
        return self
    }
    
    @discardableResult func layoutMargins(_ uniform: CGFloat) -> Self {
        layoutMargins = .init(uniform: uniform)
        return self
    }
    
    @discardableResult func layoutMargins(h: CGFloat? = nil, v: CGFloat? = nil) -> Self {
        if let value = h { layoutMargins.left = value; layoutMargins.right = value }
        if let value = v { layoutMargins.top = value; layoutMargins.bottom = value }
        return self
    }
    
}

extension UIView {
    func hAnchor(for edge: UIRectEdge, layoutMargin: Bool = false) -> NSLayoutXAxisAnchor {
        
        switch edge {
        case .left:
            return (layoutMargin ? layoutMarginsGuide.leadingAnchor : leadingAnchor)
        case .right:
            return (layoutMargin ? layoutMarginsGuide.trailingAnchor : trailingAnchor)
        case .centerX:
            return centerXAnchor
        case .top, .bottom:
            fatalError("Call verticalAnchor instead")
            
        default:
            fatalError("No anchor for: \(edge)")
        }
    }
    func vAnchor(for edge: UIRectEdge, layoutMargin: Bool = false) -> NSLayoutYAxisAnchor {
        
        switch edge {
        case .left, .right:
            fatalError("Call horizontalAnchor instead")
        case .top:
            return (layoutMargin ? layoutMarginsGuide.topAnchor : topAnchor)
        case .bottom:
            return (layoutMargin ? layoutMarginsGuide.bottomAnchor : bottomAnchor)
        case .centerY:
            return centerYAnchor
        default:
            fatalError("No anchor for: \(edge)")
        }
    }
    @discardableResult func hConstrain(_ edge: UIRectEdge, _ relation: NSLayoutConstraint.Relation = .equal,
                                              to otherView: UIView, _ otherEdge: UIRectEdge, _ constant: CGFloat = 0,
                                              priority: UILayoutPriority = .defaultHigh, layoutMargin: Bool = false) -> Self {
        let anchor1 = hAnchor(for: edge)
        let anchor2 = otherView.hAnchor(for: otherEdge, layoutMargin: layoutMargin)
        var constraint: NSLayoutConstraint!
        switch relation {
        case .equal:
            constraint = anchor1.constraint(equalTo: anchor2, constant: constant)
        case .greaterThanOrEqual:
            constraint = anchor1.constraint(greaterThanOrEqualTo: anchor2, constant: constant)
        case .lessThanOrEqual:
            constraint = anchor1.constraint(lessThanOrEqualTo: anchor2, constant: constant)
        default:
            fatalError("Cant handle constraint with type '\(relation)'")
        }
        constraint.priority = priority
        constraint.isActive = true
        return self
    }
    @discardableResult func vConstrain(_ edge: UIRectEdge, _ relation: NSLayoutConstraint.Relation = .equal,
                                              to otherView: UIView, _ otherEdge: UIRectEdge, _ constant: CGFloat = 0,
                                              priority: UILayoutPriority = .defaultHigh, layoutMargin: Bool = false) -> Self {
        let anchor1 = vAnchor(for: edge)
        let anchor2 = otherView.vAnchor(for: otherEdge, layoutMargin: layoutMargin)
        var constraint: NSLayoutConstraint!
        switch relation {
        case .equal:
            constraint = anchor1.constraint(equalTo: anchor2, constant: constant)
        case .greaterThanOrEqual:
            constraint = anchor1.constraint(greaterThanOrEqualTo: anchor2, constant: constant)
        case .lessThanOrEqual:
            constraint = anchor1.constraint(lessThanOrEqualTo: anchor2, constant: constant)
        default:
            fatalError("Cant handle constraint with type '\(relation)'")
        }
        
        constraint.priority = priority
        constraint.isActive = true
        return self
    }
    
    @discardableResult func vCenterConstrain(_ target: UIView? = nil, offset: CGFloat = 0,
                                                    priority: UILayoutPriority = .defaultHigh) -> Self {
        let optTarget = target ?? self.superview
        guard let target = optTarget else { fatalError("No superview to constrain to!")}
        let constraint = centerYAnchor.constraint(equalTo: target.centerYAnchor, constant: offset)
        
        constraint.priority = priority
        constraint.isActive = true
        return self
    }
    
    @discardableResult func hCenterConstrain(_ target: UIView? = nil, offset: CGFloat = 0,
                                                    priority: UILayoutPriority = .defaultHigh) -> Self {
        let optTarget = target ?? self.superview
        guard let target = optTarget else { fatalError("No superview to constrain to!")}
        let constraint = centerXAnchor.constraint(equalTo: target.centerXAnchor, constant: offset)
        
        constraint.priority = priority
        constraint.isActive = true
        return self
    }
    
    @discardableResult func constrain(_ edge: UIRectEdge, _ relation: NSLayoutConstraint.Relation = .equal, to otherView: UIView, _ otherEdge: UIRectEdge, _ constant: CGPoint = .zero, priority: UILayoutPriority = .defaultHigh, layoutMargin: Bool = false) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let horizontalEdges = UIRectEdge.horizontalEdges.filter { edge.contains($0) }
        let verticalEdges = UIRectEdge.verticalEdges.filter { edge.contains($0) }
        guard horizontalEdges.count <= 2 else { fatalError("Too many horizontal edges specified: \(horizontalEdges)")}
        guard verticalEdges.count <= 2 else { fatalError("Too many vertical edges specified: \(verticalEdges)")}
        
        let otherViewHorizontalEdges = UIRectEdge.horizontalEdges.filter {otherEdge.contains($0)}
        let otherViewVerticalEdges = UIRectEdge.verticalEdges.filter {otherEdge.contains($0)}
        guard otherViewHorizontalEdges.count <= 2
            else { fatalError("Too many horizontal edges specified for other view: \(otherViewHorizontalEdges)")}
        guard otherViewVerticalEdges.count <= 2
            else { fatalError("Too many vertical edges specified for other view: \(otherViewVerticalEdges)")}
        
        if let hEdge = horizontalEdges.first, let otherEdge = otherViewHorizontalEdges.first {
            hConstrain(hEdge, relation, to: otherView, otherEdge, constant.x, priority: priority, layoutMargin: layoutMargin)
        }
        if let vEdge = verticalEdges.first, let otherEdge = otherViewVerticalEdges.first {
            vConstrain(vEdge, relation, to: otherView, otherEdge, constant.y, priority: priority, layoutMargin: layoutMargin)
        }
        
        return self
    }
    
    @discardableResult func constrainToSuperviewBottom(_ constant: CGFloat = 0, stretch: Bool = false) -> Self {
        if stretch {
            vConstrain(.bottom, .lessThanOrEqual, to: superview!, .bottom, constant)
        } else {
            vConstrain(.bottom, to: superview!, .bottom, constant)
        }
        
        return self
    }
}

extension UIView {
    
    @discardableResult func add(views: [UIView], axis: NSLayoutConstraint.Axis = .horizontal, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, spacing: CGFloat = 2, _ edges: Edges = .rect) -> StackView {
        let stack = StackView(axis, alignment: alignment, distribution: distribution, spacing: spacing, views)
        add(view: stack, edges)
        return stack
    }
    
    @discardableResult func add(view: UIView, _ edges: Edges = .rect) -> Self {
        addSubview(view)
        view.constrainToParent(edges)
        return self
    }
    
    @discardableResult func constrainToParent(_ edges: Edges) -> Self {
        guard let superview = superview else {
            print("View has not yet been added to superview. Cant add constraints")
            return self
        }
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: NSLayoutConstraint!
        if let distance = edges.centerX.inset {
            let edge = edges.centerX
            let targetAnchor = superview.centerXAnchor
            
            if edge.stretch {
                constraint = centerXAnchor.constraint(greaterThanOrEqualTo: targetAnchor, constant: distance)
            } else {
                constraint = centerXAnchor.constraint(equalTo: targetAnchor, constant: distance)
            }
            
            constraint.priority = edge.priority
            constraint.isActive = true
            edge.constraint = constraint
        }
        
        if let distance = edges.centerY.inset {
            let edge = edges.centerY
            let targetAnchor = superview.centerYAnchor
            
            if edge.stretch {
                constraint = centerYAnchor.constraint(greaterThanOrEqualTo: targetAnchor, constant: distance)
            } else {
                constraint = centerYAnchor.constraint(equalTo: targetAnchor, constant: distance)
            }
            constraint.priority = edge.priority
            constraint.isActive = true
            edge.constraint = constraint
            
        }
        
        if let distance = edges.top.inset {
            let edge = edges.top
            let targetAnchor: NSLayoutYAxisAnchor = {
                if edge.safeLayoutGuide {
                    return superview.safeAreaLayoutGuide.topAnchor
                } else if edge.margin {
                    return superview.layoutMarginsGuide.topAnchor
                } else {
                    return superview.topAnchor
                }
            }()
            
            if edge.stretch {
                constraint = topAnchor.constraint(greaterThanOrEqualTo: targetAnchor, constant: distance)
            } else {
                constraint = topAnchor.constraint(equalTo: targetAnchor, constant: distance)
            }
            
            constraint.priority = edge.priority
            constraint.isActive = true
            edge.constraint = constraint
        }
        if let distance = edges.bottom.inset {
            let edge = edges.bottom
            let targetAnchor: NSLayoutYAxisAnchor = {
                if edge.safeLayoutGuide {
                    return superview.safeAreaLayoutGuide.bottomAnchor
                } else if edge.margin {
                    return superview.layoutMarginsGuide.bottomAnchor
                } else {
                    return superview.bottomAnchor
                }
            }()
            
            if edge.stretch {
                constraint = bottomAnchor.constraint(lessThanOrEqualTo: targetAnchor, constant: -distance)
            } else {
                constraint = bottomAnchor.constraint(equalTo: targetAnchor, constant: -distance)
            }
            
            constraint.priority = edge.priority
            constraint.isActive = true
            edge.constraint = constraint
        }
        
        if let distance = edges.left.inset {
            let edge = edges.left
            let targetAnchor: NSLayoutXAxisAnchor = {
                if edge.safeLayoutGuide {
                    return superview.safeAreaLayoutGuide.leadingAnchor
                } else if edge.margin {
                    return superview.layoutMarginsGuide.leadingAnchor
                } else {
                    return superview.leadingAnchor
                }
            }()
            
            if edge.stretch {
                constraint = leadingAnchor.constraint(greaterThanOrEqualTo: targetAnchor, constant: distance)
            } else {
                constraint = leadingAnchor.constraint(equalTo: targetAnchor, constant: distance)
            }
            
            constraint.priority = edge.priority
            constraint.isActive = true
            edge.constraint = constraint
        }
        
        if let distance = edges.right.inset {
            let edge = edges.right
            let targetAnchor: NSLayoutXAxisAnchor = {
                if edge.safeLayoutGuide {
                    return superview.safeAreaLayoutGuide.trailingAnchor
                } else if edge.margin {
                    return superview.layoutMarginsGuide.trailingAnchor
                } else {
                    return superview.trailingAnchor
                }
            }()
            
            if edge.stretch {
                constraint = trailingAnchor.constraint(lessThanOrEqualTo: targetAnchor, constant: -distance)
            } else {
                constraint = trailingAnchor.constraint(equalTo: targetAnchor, constant: -distance)
            }
            
            constraint.priority = edge.priority
            constraint.isActive = true
            edge.constraint = constraint
        }
        
        return self
    }
    
}

extension Array where Element: NSLayoutConstraint {
    func removeConstraints(from view: UIView) {
        forEach { view.removeConstraint($0) }
    }
}
extension UIView {
    var widthConstraint: NSLayoutConstraint? {
        return constraints.first { $0.firstAttribute == .width }
    }
    var heightConstraint: NSLayoutConstraint? {
        return constraints.first { $0.firstAttribute == .height }
    }
}
