import UIKit


extension UIRectEdge {
    static let centerX = UIRectEdge(rawValue: 1 << 99)
    static let centerY = UIRectEdge(rawValue: 1 << 100)
}

public class Edges {
    class Edge {
        let edge: UIRectEdge
        var inset: CGFloat?
        var margin: Bool
        var safeLayoutGuide: Bool = false
        var stretch: Bool
        ///The priority of the constraint to be created
        var priority = UILayoutPriority.required
        weak var constraint: NSLayoutConstraint?
        
        func stretch(_ stretch: Bool = true) -> Self {
            self.stretch = stretch
            return self
        }
        
        func priority(_ priority: UILayoutPriority) -> Self {
            self.priority = priority
            return self
        }
        
        init(_ edge: UIRectEdge, _ inset: CGFloat? = nil, stretch: Bool = false, margin: Bool = false) {
            self.edge = edge
            self.inset = inset
            self.margin = margin
            self.stretch = stretch
        }
        
    }
    let left = Edge(.left)
    let right = Edge(.right)
    let top = Edge(.top)
    let bottom = Edge(.bottom)
    let centerX = Edge(.centerX)
    let centerY = Edge(.centerY)
    
    lazy private(set)var rect = [left, right, top, bottom]
    lazy private(set)var rectHorizontal = [left, right]
    lazy private(set)var rectVertical = [top, bottom]
    lazy private(set)var all = [centerX, centerY] + rect
    
    init(_ uniform: CGFloat? = nil, l: CGFloat? = nil, r: CGFloat? = nil, t: CGFloat? = nil, b: CGFloat? = nil,
                pmL: CGFloat? = nil, pmR: CGFloat? = nil, pmT: CGFloat? = nil, pmB: CGFloat? = nil,
                safeL: CGFloat? = nil, safeR: CGFloat? = nil, safeT: CGFloat? = nil, safeB: CGFloat? = nil,
                h: CGFloat? = nil, v: CGFloat? = nil,
                pmH: CGFloat? = nil, pmV: CGFloat? = nil,
                safeH: CGFloat? = nil, safeV: CGFloat? = nil,
                cX: CGFloat? = nil, cY: CGFloat? = nil, stretch: UIRectEdge=[]) {
        if let uniform = uniform {
            self.uniform(uniform, ignoreNil: true)
        } else {
            assert((l == nil || pmL == nil || safeL == nil) || (h == nil || pmH == nil || safeL == nil),
                   "Parameters [l], [pmL], [safeL], [h] and [pmH] are mutally exclusive")
            assert((r == nil || pmR == nil || safeR == nil) || (h == nil || pmH == nil || safeR == nil),
                   "Parameters [r], [pmR], [safeR], [h] and [pmH] are mutally exclusive")
            assert((t == nil || pmT == nil || safeT == nil) || (v == nil || pmV == nil || safeT == nil),
                   "Parameters [t], [pmT], [safeT], [v] and [pmV] are mutally exclusive")
            assert((b == nil || pmB == nil || safeB == nil) || (v == nil || pmV == nil || safeB == nil),
                   "Parameters [b], [pmB], [safeB], [v] and [pmV] are mutally exclusive")
            
            var t = t, b = b, l = l, r = r
            var pmT = pmT, pmB = pmB, pmL = pmL, pmR = pmR
            var safeT = safeT, safeB = safeB, safeL = safeL, safeR = safeR
            
            if let value = h { l = value; r = value }
            if let value = v { t = value; b = value }
            if let value = pmH { pmL = value; pmR = value }
            if let value = pmV { pmT = value; pmB = value }
            if let value = safeH { safeL = value; safeR = value }
            if let value = safeV { safeT = value; safeB = value }

            func setup(margin: Bool) {
                if let value = t { top.inset = value; top.margin = margin; top.stretch = stretch.contains(.top) }
                if let value = b { bottom.inset = value; bottom.margin = margin; bottom.stretch = stretch.contains(.bottom) }
                if let value = l { left.inset = value; left.margin = margin; left.stretch = stretch.contains(.left) }
                if let value = r { right.inset = value; right.margin = margin; right.stretch = stretch.contains(.right) }

                if let value = safeT {
                    top.inset = value; top.safeLayoutGuide = true; top.stretch = stretch.contains(.top)
                }
                if let value = safeB {
                    bottom.inset = value; bottom.safeLayoutGuide = true; bottom.stretch = stretch.contains(.bottom)
                }
                if let value = safeL {
                    left.inset = value; left.safeLayoutGuide = true; left.stretch = stretch.contains(.left)
                }
                if let value = safeR {
                    right.inset = value; right.safeLayoutGuide = true; right.stretch = stretch.contains(.right)
                }
            }
            setup(margin: false)
            t = pmT
            b = pmB
            l = pmL
            r = pmR
            setup(margin: true)

            if let value = cX { centerX.inset = value; centerX.stretch = stretch.contains(.centerX) }
            if let value = cY { centerY.inset = value; centerY.stretch = stretch.contains(.centerY) }
        }
    }
    
    init(h: CGFloat, v: CGFloat) {
        left.inset = h
        right.inset = h
        top.inset = v
        bottom.inset = v
    }
    init(insets: UIEdgeInsets) {
        left.inset = insets.left
        right.inset = insets.right
        top.inset = insets.top
        bottom.inset = insets.bottom
    }
    
    // MARK: Rect Edges
    
    @discardableResult func top(_ inset: CGFloat? = nil, _ priority: UILayoutPriority? = nil, stretch: Bool? = nil, margin: Bool? = nil) -> Self {
        if let inset = inset { top.inset = inset }
        if let stretch = stretch { top.stretch = stretch }
        if let priority = priority { top.priority = priority }
        if let margin = margin { top.margin = margin }
        return self
    }
    @discardableResult func bottom(_ inset: CGFloat? = nil, _ priority: UILayoutPriority? = nil, stretch: Bool? = nil, margin: Bool? = nil) -> Self {
        if let inset = inset { bottom.inset = inset }
        if let stretch = stretch { bottom.stretch = stretch }
        if let priority = priority { bottom.priority = priority }
        if let margin = margin { bottom.margin = margin }
        return self
    }
    @discardableResult func left(_ inset: CGFloat? = nil, _ priority: UILayoutPriority? = nil, stretch: Bool? = nil, margin: Bool? = nil) -> Self {
        if let inset = inset { left.inset = inset }
        if let stretch = stretch { left.stretch = stretch }
        if let priority = priority { left.priority = priority }
        if let margin = margin { left.margin = margin }
        return self
    }
    @discardableResult func right(_ inset: CGFloat? = nil, _ priority: UILayoutPriority? = nil, stretch: Bool? = nil, margin: Bool? = nil) -> Self {
        if let inset = inset { right.inset = inset }
        if let stretch = stretch { right.stretch = stretch }
        if let priority = priority { right.priority = priority }
        if let margin = margin { right.margin = margin }
        return self
    }
    
    
    
    // MARK: Center 'Edges'
    
    func centerX(_ offset: CGFloat = 0, _ priority: UILayoutPriority = .required, h: CGFloat? = nil, pmH: CGFloat? = nil) -> Self {
        assert((h == nil || pmH == nil), "Parameters [h] and [pmH] are mutally exclusive")
        
        centerX.inset = offset
        centerX.priority = priority
        
        if let value = h { horizontal(value, .required, stretch: true, margin: false, ignoreNil: false) }
        if let value = pmH { horizontal(value, .required, stretch: true, margin: true, ignoreNil: false) }
        
        return self
    }
    func centerY(_ offset: CGFloat = 0, _ priority: UILayoutPriority = .required, v: CGFloat? = nil, pmV: CGFloat? = nil) -> Self {
        centerY.inset = offset
        centerY.priority = priority
        
        if let value = v { vertical(value, .required, stretch: true, margin: false, ignoreNil: false) }
        if let value = pmV { vertical(value, .required, stretch: true, margin: true, ignoreNil: false) }
        return self
    }
    
    func middle(_ offset: CGFloat = 0, _ priority: UILayoutPriority = .required, h: CGFloat? = nil, pmH: CGFloat? = nil, v: CGFloat? = nil, pmV: CGFloat? = nil) -> Self {
        centerX(offset, priority, h: h, pmH: pmH).centerY(offset, priority, v: v, pmV: pmV)
    }
    // MARK: -

    
    @discardableResult func parentMargin(_ margin: Bool = true) -> Self {
        all.forEach { $0.margin = margin}
        return self
    }

    @discardableResult func parentSafeLayoutGuide(_ safeLayoutGuide: Bool = true) -> Self {
        all.forEach { $0.safeLayoutGuide = safeLayoutGuide}
        return self
    }
    
    @discardableResult func stretch(_ stretch: Bool = true) -> Self {
        all.forEach { $0.stretch = stretch}
        return self
    }
    
    @discardableResult func priority(_ priority: UILayoutPriority) -> Self {
        all.forEach { $0.priority = priority}
        return self
    }
    
    
    @discardableResult func stretchHorizontal(_ stretch: Bool = true) -> Self {
        rectHorizontal.forEach { $0.stretch = stretch }
        return self
    }
    
    
    @discardableResult func stretchVertical(_ stretch: Bool = true) -> Self {
        rectVertical.forEach { $0.stretch = stretch }
        return self
    }
    
    @discardableResult func uniform(_ inset: CGFloat, _ priority: UILayoutPriority? = nil, margin: Bool? = nil, ignoreNil: Bool = true) -> Self {
        if !ignoreNil || left.inset != nil { left(inset, priority, margin: margin) }
        if !ignoreNil || right.inset != nil { right(inset, priority, margin: margin) }
        if !ignoreNil || top.inset != nil { top(inset, priority, margin: margin) }
        if !ignoreNil || bottom.inset != nil { bottom(inset, priority, margin: margin) }
        return self
    }
    @discardableResult func horizontal(_ inset: CGFloat, _ priority: UILayoutPriority? = nil, stretch: Bool? = nil, margin: Bool? = nil, ignoreNil: Bool = true) -> Self {
        if !ignoreNil || left.inset != nil { left(inset, priority, stretch: stretch, margin: margin) }
        if !ignoreNil || right.inset != nil { right(inset, priority, stretch: stretch, margin: margin) }
        return self
    }
    @discardableResult func vertical(_ inset: CGFloat, _ priority: UILayoutPriority? = nil, stretch: Bool? = nil, margin: Bool? = nil, ignoreNil: Bool = true) -> Self {
        if !ignoreNil || top.inset != nil { top(inset, priority, stretch: stretch, margin: margin) }
        if !ignoreNil || bottom.inset != nil { bottom(inset, priority, stretch: stretch, margin: margin) }
        return self
    }
    
    var edgeInsets: UIEdgeInsets {
        var insets = UIEdgeInsets()
        if let distance = top.inset { insets.top = distance }
        if let distance = bottom.inset { insets.bottom = distance }
        if let distance = left.inset { insets.left = distance }
        if let distance = right.inset { insets.right = distance }
        return insets
    }
    
    var rectEdges: UIRectEdge {
        var edges = UIRectEdge()
        if top.inset != nil { edges.insert(.top) }
        if bottom.inset != nil { edges.insert(.bottom) }
        if left.inset != nil { edges.insert(.left) }
        if right.inset != nil { edges.insert(.right) }
        return edges
    }
    static let defaultInset = uiedges(0)
    
    // MARK: Rect edges
    
    static var rect: Edges { Edges(insets: defaultInset) }
    static var rectMargins: Edges { Edges(insets: defaultInset).parentMargin() }
    static var rectMarginsBottomStretch: Edges { Edges(insets: defaultInset).parentMargin().bottom(stretch: true) }
    static var rectSafe: Edges { Edges().top(0).bottom(0).left(0).right(0).parentSafeLayoutGuide() }
    
    static var topLeftRight: Edges { Edges().top(0).left(0).right(0) }
    static var bottomLeftRight: Edges { Edges().bottom(0).left(0).right(0) }
    static var topLeft: Edges { Edges().top(0).left(0) }
    static var topRight: Edges { Edges().top(0).right(0) }
    static var bottomLeft: Edges { Edges().bottom(0).left(0) }
    static var bottomRight: Edges { Edges().bottom(0).right(0) }
    static var left: Edges { Edges().left(0) }
    static var right: Edges { Edges().right(0) }
    static var top: Edges { Edges().top(0) }
    static var bottom: Edges { Edges().bottom(0) }
    static var leftRight: Edges { Edges().left(0).right(0) }
    static var topBottom: Edges { Edges().top(0).bottom(0) }
    static var topBottomLeft: Edges { Edges().top(0).bottom(0).left(0) }
    static var topBottomRight: Edges { Edges().bottom(0).right(0) }
    
    static var topLeftRightMargins: Edges { Edges().top(0).left(0).right(0).parentMargin() }
    static var bottomLeftRightMargins: Edges { Edges().bottom(0).left(0).right(0).parentMargin() }
    static var topLeftMargins: Edges { Edges().top(0).left(0).parentMargin() }
    static var topRightMargins: Edges { Edges().top(0).right(0).parentMargin() }
    static var bottomLeftMargins: Edges { Edges().bottom(0).left(0).parentMargin() }
    static var bottomRightMargins: Edges { Edges().bottom(0).right(0).parentMargin() }
    static var leftMargin: Edges { Edges().left(0).parentMargin() }
    static var rightMargin: Edges { Edges().right(0).parentMargin() }
    static var leftRightMargins: Edges { Edges().left(0).right(0).parentMargin() }
    static var topBottomMargins: Edges { Edges().top(0).bottom(0).parentMargin() }
    static var topBottomLeftMargins: Edges { Edges().top(0).bottom(0).left(0).parentMargin() }
    static var topBottomRightMargins: Edges { Edges().bottom(0).right(0).parentMargin() }

    static var topLeftRightSafe: Edges { Edges().top(0).left(0).right(0).parentSafeLayoutGuide() }
    static var bottomLeftRightSafe: Edges { Edges().bottom(0).left(0).right(0).parentSafeLayoutGuide() }
    static var topLeftSafe: Edges { Edges().top(0).left(0).parentSafeLayoutGuide() }
    static var topRightSafe: Edges { Edges().top(0).right(0).parentSafeLayoutGuide() }
    static var bottomLeftSafe: Edges { Edges().bottom(0).left(0).parentSafeLayoutGuide() }
    static var bottomRightSafe: Edges { Edges().bottom(0).right(0).parentSafeLayoutGuide() }
    static var leftSafe: Edges { Edges().left(0).parentSafeLayoutGuide() }
    static var rightSafe: Edges { Edges().right(0).parentSafeLayoutGuide() }
    static var leftRightSafe: Edges { Edges().left(0).right(0).parentSafeLayoutGuide() }
    static var topBottomSafe: Edges { Edges().top(0).bottom(0).parentSafeLayoutGuide() }
    static var topBottomLeftSafe: Edges { Edges().top(0).bottom(0).left(0).parentSafeLayoutGuide() }
    static var topBottomRightSafe: Edges { Edges().bottom(0).right(0).parentSafeLayoutGuide() }

    // MARK: 'Center' Edges
    static var centerX: Edges {  Edges().centerX(0) }
    static var centerY: Edges {  Edges().centerY(0) }
    static var middle: Edges {  Edges().centerX(0).centerY(0) }
    static var topCenterX: Edges {  Edges().centerX(0).top(0) }
    static var bottomCenterX: Edges {  Edges().centerX(0).bottom(0) }
    static var leftCenterY: Edges {  Edges().centerY(0).left(0) }
    static var rightCenterY: Edges {  Edges().centerY(0).right(0) }
}
