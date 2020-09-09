import UIKit

class ImageView: View {
    private(set) var view = UIImageView(frame: .zero)
    ///Instead of setting height and width constraints we can optinally return our size via intrinsic content size
    private var _intrinsicContentSize: CGSize?
    
    override func createSubviews() {
        super.createSubviews()
        layoutMargins = .zero
        isUserInteractionEnabled = false
        view.clips()
        contentMode = .scaleAspectFit
        add(view: view, .rectMargins)
    }
    
    @discardableResult func setImage(size: CGSize?, _ margins: UIEdgeInsets = .zero, forceImageSizeConstraints: Bool = false) -> Self {
        layoutMargins = margins
        _intrinsicContentSize = size
        if let size = size, forceImageSizeConstraints { view.set(size: size) }
        return self
    }
    
    @discardableResult func setImage(size: CGSize, sizeIncludingMargins: CGSize? = nil, forceImageSizeConstraints: Bool = false) -> Self {
        let totalSize = sizeIncludingMargins ?? size
        let horizontalMargin = (totalSize.width - size.width) / 2
        let verticalMargin = (totalSize.height - size.height) / 2
        _intrinsicContentSize = size
        if forceImageSizeConstraints { view.set(size: size) }
        layoutMargins = uiedges(h: horizontalMargin, v: verticalMargin)
        return self
    }
    
    convenience init(_ image: UIImage) {
        self.init()
        self.image = image
    }
    
    var image: UIImage? {
        get {
            view.image
        } set {
            view.image = newValue
        }
    }
    
    @discardableResult func img(_ image: UIImage) -> Self {
        view.image = image
        return self
    }
    
    override var contentMode: UIView.ContentMode {
        get {
            return view.contentMode
        } set {
            view.contentMode = newValue
        }
    }
    
    var imageURL: URL? {
        didSet {
            guard let imageURL = imageURL else {
                return
            }
            
            doAsync {[weak self] complete in
                do {
                    guard let self = self else { return }
                    let imageData = try Data(contentsOf: imageURL)
                    let image = UIImage(data: imageData)
                    //do on main thread
                    delayedCall {
                        self.view.image = image
                    }
                    
                } catch {
                    Swift.print(error)
                }
                complete()
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        var size = _intrinsicContentSize ?? view.intrinsicContentSize
        
        size.width += layoutMargins.horizontal
        size.height += layoutMargins.vertical
        
        return size
    }
}
