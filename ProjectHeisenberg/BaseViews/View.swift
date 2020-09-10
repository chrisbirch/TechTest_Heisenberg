import UIKit
extension CALayer {
    
     func setupShadow(colour: UIColor = .black, offset: CGSize = CGSize(width: 0, height: 1), opacity: Float = 0.08) {
        masksToBounds = false
        shadowColor = colour.cgColor
        shadowOffset = offset
        shadowOpacity = opacity
    }
}


class View: UIView {
    
    // MARK: - Tap handling
    
    var tappable: Bool = false {
        didSet {
            installOrRemoveTapHandler()
        }
    }
    @discardableResult func tappable(_ tapEnabled: Bool = true) -> Self {
        self.tappable = tapEnabled
        return self
    }
    var touchUpInside: Handler<View>?
    @discardableResult func touchUpInside(_ touchUpInside: @escaping Handler<View>) -> Self {
        self.touchUpInside = touchUpInside
        return self
    }
    
    private var recogniser: UITapGestureRecognizer?
    
    private func installOrRemoveTapHandler() {
        if tappable {
            if let recogniser = recogniser {
                self.removeGestureRecognizer(recogniser)
            }
            recogniser = UITapGestureRecognizer(target: self, action: #selector(onTouchUpInside))
            
            addGestureRecognizer(recogniser!)
        } else if let recogniser = recogniser {
            self.removeGestureRecognizer(recogniser)
        }
    }
    
    @objc func onTouchUpInside() {
        touchUpInside?(self)
    }
    var isOrphan: Bool {
        return superview == nil
    }
    var gradientLayer: CAGradientLayer?
    var renderAsCard: Bool = false {
        didSet {
            if cardBackgroundLayer.superlayer != layer {
                layer.addSublayer(layer)
            }
        }
    }
    
    @discardableResult func cardStyle(borderColor: CGColor = UIColor.lightGray.cgColor,
                                      backgroundColor: CGColor = UIColor.white.cgColor,
                                      backgroundCornerRadius: CGFloat = 8) -> Self {
        cardBackgroundLayerBorderColor = borderColor
        cardBackgroundLayerBackgroundColor = backgroundColor
        cardBackgroundLayer.cornerRadius = backgroundCornerRadius
        renderAsCard = true
        return self
    }
    
    
    // MARK: - Inits
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required  init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
     init(frame: CGRect = .zero, tappable: Bool = false) {
        super.init(frame: frame)
        
        commonInit()
        self.tappable = tappable
    }
    
    // MARK: - View lifecycle
    
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        createSubviews()
        installOrRemoveTapHandler()
    }
    
    func createSubviews() { }
    
    // MARK: - Card rendering related
    
    private var cardBackgroundLayerBorderColor: CGColor = UIColor.lightGray.cgColor
    private var cardBackgroundLayerBackgroundColor: CGColor = UIColor.white.cgColor
    
    private lazy var cardBackgroundLayer: CALayer = {
        let layer = CALayer()
        self.cardLayer = layer
        layer.borderColor = cardBackgroundLayerBorderColor
        layer.backgroundColor = cardBackgroundLayerBackgroundColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        layer.setupShadow()
        layer.zPosition = -100
        self.layer.addSublayer(layer)
        return layer
    }()
    
    var cardLayer: CALayer!
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if renderAsCard {
            cardBackgroundLayer.frame = layer.bounds
        }
        
        if let gradientLayer = gradientLayer {
            gradientLayer.frame = layer.bounds
        }
    }
    
    // MARK: - Async work
    
    
     typealias WorkHandler = ((_ complete: @escaping VoidHandler) -> Void)
    
    
    ///Added to the view when async job is underway
    lazy var busyView: BusyView = {[unowned self] in
        let busyView = self.createBusyView()
        self.add(view: busyView)
        return busyView
        }()
    
    func doAsync(_ handler: @escaping WorkHandler) {
        showBusyView()
        DispatchQueue.global().async {
            handler {[weak self] in
                //call back on main thread
                delayedCall {
                    guard let self = self else { return }
                    self.hideBusyView()
                }
            }
        }
    }
    
    ///Subclasses should override if they wish to customise the view that they present when performing async job
    func createBusyView() -> BusyView {
        BusyView()
    }
    var suppressBusyView = false
    // MARK: - Helpers
    ///the amount of time that must pass before we show the busy view. This prevents flashing when we dont really need to show it for very long
    var busyViewDelay = TimeInterval(0.3)
    var busyViewDisplayTimer: Timer?
    
    func showBusyView() {
        guard !suppressBusyView else { return }
        func show() {
            busyView.isHidden = false
            setNeedsLayout()
            layoutIfNeeded()
            superview?.bringSubviewToFront(busyView)
        }
        busyViewDisplayTimer?.invalidate()
        busyViewDisplayTimer = nil
        
        if busyViewDelay > 0 {
            busyViewDisplayTimer = Timer.scheduledTimer(withTimeInterval: busyViewDelay, repeats: false) {[weak self] timer in
                guard let self = self else { return }
                timer.invalidate()
                self.busyViewDisplayTimer = nil
                
                show()
                
            }
        } else {
            show()
        }
    }
    
    func hideBusyView() {
        busyViewDisplayTimer?.invalidate()
        busyViewDisplayTimer = nil
        
        busyView.isHidden = true
    }
    
    private var hideTimer: Timer?
    
    func hide(for duration: TimeInterval, _ complete: VoidHandler? = nil) {
        self.isHidden = true
        hideTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            self.isHidden = false
            complete?()
        }
    }
    
    override var isHidden: Bool {
        didSet {
            hideTimer?.invalidate()
            hideTimer = nil
            showTimer?.invalidate()
            showTimer = nil
        }
    }
    
    private var showTimer: Timer?
    
    func show(for duration: TimeInterval, _ complete: VoidHandler? = nil) {
        self.isHidden = false
        showTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            self.isHidden = true
            complete?()
        }
    }
}
