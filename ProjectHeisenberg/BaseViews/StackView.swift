import UIKit

class StackView: UIStackView {
    
}

extension UIStackView {
    convenience init(_ axis: NSLayoutConstraint.Axis = .horizontal,
                            alignment: UIStackView.Alignment = .fill,
                            distribution: UIStackView.Distribution = .fill,
                            spacing: CGFloat = 2,
                            layoutMargins: UIEdgeInsets? = nil,
                            _ views: [UIView] = []) {
        self.init(arrangedSubviews: views)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
        if let layoutMargins = layoutMargins {
            self.layoutMargins = layoutMargins
            self.isLayoutMarginsRelativeArrangement = true
        }

        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @discardableResult func set(axis: NSLayoutConstraint.Axis? = nil,
                                       alignment: UIStackView.Alignment? = nil,
                                       distribution: UIStackView.Distribution? = nil,
                                       spacing: CGFloat? = 0,
                                       layoutMargins: UIEdgeInsets? = nil) -> Self {
        if let value = axis {
            self.axis = value
        }
        if let value = alignment {
            self.alignment = value
        }
        if let value = distribution {
            self.distribution = value
        }
        if let value = spacing {
            self.spacing = value
        }
        if let layoutMargins = layoutMargins {
            self.layoutMargins = layoutMargins
            self.isLayoutMarginsRelativeArrangement = true
        }
        return self
    }

    @discardableResult func horizontal(_ spacing: CGFloat = 0) -> Self {
        axis = .horizontal
        return space(spacing)
    }

    @discardableResult func vertical(_ spacing: CGFloat = 0) -> Self {
        axis = .vertical
        return space(spacing)
    }

    @discardableResult func space(_ spacing: CGFloat = 8) -> Self {
        self.spacing = spacing
        return self
    }
    
    @discardableResult func removeAllArrangedSubviews() -> [UIView] {
      let removedSubviews = arrangedSubviews.reduce([]) { (removedSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            NSLayoutConstraint.deactivate(subview.constraints)
            subview.removeFromSuperview()
            return removedSubviews + [subview]
        }
        return removedSubviews
    }
    
    @discardableResult func add(_ arrangedSubviews: [UIView]) -> Self {
        arrangedSubviews.forEach { addArrangedSubview($0) }
        return self
    }
    
    subscript(arrangedSubviewIndex: Int) -> UIView? {
        guard arrangedSubviewIndex < arrangedSubviews.count && arrangedSubviewIndex > -1 else { return nil }
        return arrangedSubviews[arrangedSubviewIndex]
    }
}
