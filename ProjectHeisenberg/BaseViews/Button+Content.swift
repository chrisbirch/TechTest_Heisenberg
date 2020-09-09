import UIKit

extension Button {
    public struct Content {
        public enum LabelIdentifer {
            case title
            case subTitle
            case body
        }
        public enum ImageIdentifier {
            case image1
            case image2
            case image3
        }
        
        public enum CustomViewIdentifier {
            case customView1
            case customView2
            case customView3
        }
        
        public enum Item {
            case image(ImageIdentifier, ImageView)
            case label(LabelIdentifer, UILabel)
            case custom(CustomViewIdentifier, UIView)
            
            public var view: UIView {
                switch self {
                case .image(_, let imageView):
                    return imageView
                case .label(_, let label):
                    return label
                case .custom(_, let view):
                    return view
                }
            }
        }
        
    }
    
    public func label(_ identifier: Content.LabelIdentifer) -> UILabel? {
        for item in contentStackView.contentItems {
            switch item {
            case .label(let id, let label):
                if id == identifier {
                    return label
                }
            default:
                continue
            }
        }
        return nil
    }
    
    public func image(_ identifier: Content.ImageIdentifier) -> ImageView? {
        for item in contentStackView.contentItems {
            switch item {
            case .image(let id, let imageView):
                if id == identifier {
                    return imageView
                }
            default:
                continue
            }
        }
        return nil
    }
    public func customView(_ identifier: Content.CustomViewIdentifier) -> UIView? {
        for item in contentStackView.contentItems {
            switch item {
            case .custom(let id, let view):
                if id == identifier {
                    return view
                }
            default:
                continue
            }
        }
        return nil
    }
    
    public class ContentStackView: StackView {
        public let contentItems: [Content.Item]
        public init(_ axis: NSLayoutConstraint.Axis = .horizontal,
                    alignment: UIStackView.Alignment = .fill,
                    distribution: UIStackView.Distribution = .fill,
                    spacing: CGFloat = 2,
                    layoutMargins: UIEdgeInsets? = nil,
                    contentItems: [Content.Item]) {
            self.contentItems = contentItems
            let views = contentItems.map { $0.view }
            super.init(frame: .zero)
            self.alignment = alignment
            self.distribution = distribution
            self.spacing = spacing
            if let margins = layoutMargins {
                self.layoutMargins = margins
            }
            add(views)
        }
        
        required public init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
