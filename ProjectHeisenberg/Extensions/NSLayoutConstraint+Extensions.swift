import UIKit

extension NSLayoutConstraint {
    static func ofKind(_ constraints: [NSLayoutConstraint], kinds: [NSLayoutConstraint.Attribute]) -> [NSLayoutConstraint] {
        return kinds.map { kind in
            return constraints.filter { constraint in
                return constraint.firstAttribute == kind
            }
        }.flatMap { $0 }//flattens 2d array to 1d array
    }
}
