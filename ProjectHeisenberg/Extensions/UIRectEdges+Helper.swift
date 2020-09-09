import UIKit

extension UIRectEdge {
    
  static let topLeftRight: UIRectEdge = [.top, .left, .right]
  static let bottomLeftRight: UIRectEdge = [.bottom, .left, .right]
  static let topLeft: UIRectEdge = [.top, .left]
  static let topRight: UIRectEdge = [.top, .right]
  static let bottomLeft: UIRectEdge = [.bottom, .left]
  static let bottomRight: UIRectEdge = [.bottom, .right]
  static let leftRight: UIRectEdge = [.left, .right]
  static let topBottom: UIRectEdge = [.top, .bottom]
    static let topBottomLeft: UIRectEdge = [.top, .bottom, .left]
    static let topBottomRight: UIRectEdge = [.top, .bottom, .right]
    
    static let horizontalEdges: [UIRectEdge] = [
        .left, .right, .centerX
    ]
    static let verticalEdges: [UIRectEdge] = [
        .top, .bottom, .centerY
    ]
    static let allEdges: [UIRectEdge] = {
       horizontalEdges + verticalEdges
    }()
}
