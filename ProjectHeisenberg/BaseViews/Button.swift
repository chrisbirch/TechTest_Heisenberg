import UIKit

 class Button: Control {
     enum Style {
        case monetary
        case toggle(group: ButtonGroup?)
    }
     var style: Style {
        didSet {
            setupForNormalState()
        }
    }
    @discardableResult  func style(_ style: Style) -> Self {
        self.style = style
        return self
    }
    
     var isTogglable: Bool {
        switch style {
        case .toggle:
            return true
        default:
            return false
        }
    }
    
     var isOn: Bool = false {
        didSet {
            if isOn {
                setupForOnState()
            } else {
                setupForOffState()
            }
            isOnChanged?(self)
        }
    }
    
     typealias TouchHandler = ((_ button: Button) -> Void)
     var touchDown: TouchHandler?
     var forceTouchDown: TouchHandler?
     var touchUpInside: TouchHandler?
    @discardableResult  func forceTouchDown(_ handler: @escaping TouchHandler) -> Self {
        self.forceTouchDown = handler
        return self
    }
    @discardableResult  func touchDown(_ handler: @escaping TouchHandler) -> Self {
        self.touchDown = handler
        return self
    }
    @discardableResult  func touchUpInside(_ handler: @escaping TouchHandler) -> Self {
        self.touchUpInside = handler
        return self
    }
     var isOnChanged: ((_ button: Button) -> Void)?
    
    ///If we created this instance passing in a contentStackView
     let contentStackView: Button.ContentStackView
     convenience init(style: Button.Style = .monetary, title: String, label: UILabel? = nil) {
        let label = label ?? UILabel()
        label.text = title
        self.init(style: style, axis: .horizontal, [
            .label(.title, label)
        ])
    }
     convenience init(style: Button.Style = .monetary, image: UIImage, imageView: ImageView? = nil) {
           let imageView = imageView ?? ImageView()
           imageView.image = image
           self.init(style: style, axis: .horizontal, [
                .image(.image1, imageView)
           ])
       }
     init(style: Button.Style = .monetary, stack: ContentStackView) {
        self.contentStackView = stack
        self.style = style
        super.init()
        add(view: contentStackView)
    }
     init(
        style: Button.Style = .monetary,
        axis: NSLayoutConstraint.Axis = .horizontal,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        spacing: CGFloat = 2,
        layoutMargins: UIEdgeInsets? = nil,
        _ items: [Content.Item]) {
        
        self.style = style
        self.contentStackView = ContentStackView(axis, alignment: alignment, distribution: distribution,
                                                 spacing: spacing, layoutMargins: layoutMargins, contentItems: items)
        super.init()
        add(view: contentStackView)
    }
    
    required  init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func setupForOnState() {
        backgroundColour(.green)
    }
     func setupForOffState() {
        backgroundColour(.clear)
    }
    
     func setupForTouchDownState() {
        backgroundColour(.clear)
    }
     func setupForNormalState() {
        if isTogglable {
            if isOn {
                setupForOnState()
            } else {
                setupForOffState()
            }
        } else {
            backgroundColour(.clear)
        }
    }
     func setupForDragExitState() {
        setupForNormalState()
    }
    private var hideTimer: Timer?
    
     func hide(for duration: TimeInterval) {
        self.isHidden = true
        hideTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            self.isHidden = false
        }
    }
    
     override var isHidden: Bool {
        didSet {
            hideTimer?.invalidate()
            hideTimer = nil
        }
    }
     func touchDownHaptic() {
        let impact = UIImpactFeedbackGenerator()
        if #available(iOS 13.0, *) {
            impact.impactOccurred(intensity: 0.5)
        } else {
            // Fallback on earlier versions
        }
    }
     func touchUpHaptic() {
        let impact = UIImpactFeedbackGenerator()
        if #available(iOS 13.0, *) {
            impact.impactOccurred(intensity: 0.1)
        } else {
            // Fallback on earlier versions
        }
    }
     func touchDragExitHaptic() {
        let impact = UIImpactFeedbackGenerator()
        if #available(iOS 13.0, *) {
            impact.impactOccurred(intensity: 0.2)
        } else {
            // Fallback on earlier versions
        }
    }
     func touchUpInsideHaptic() {
        let impact = UIImpactFeedbackGenerator()
        if #available(iOS 13.0, *) {
            impact.impactOccurred(intensity: 1)
        } else {
            // Fallback on earlier versions
        }
    }
    
    enum ButtonEvents {
        case touchDown
        case touchDownForce
        case touchUp
        case touchUpInside
        case touchDragEnter
        case touchDragExit
        
        static let all: [ButtonEvents] = [.touchDown, .touchDownForce, .touchUp, .touchUpInside, .touchDragEnter, .touchDragExit]
    }
    var generateEvents: [ButtonEvents] = ButtonEvents.all
    
    func onForceTouchDown() {
        setupForTouchDownState()
        forceTouchDown?(self)
    }
    func onTouchDown() {
        setupForTouchDownState()
        touchDown?(self)
    }
    func onTouchUp() {
        setupForNormalState()
    }
    func onTouchDragEnter() {
        setupForTouchDownState()
    }
    func onTouchDragExit() {
        setupForDragExitState()
    }
    
    func onTouchUpInside() {
        if isTogglable {
            toggle()
        }
        setupForNormalState()
        touchUpInside?(self)
    }
    
    func toggle() {
        guard isTogglable else { fatalError("This button is not togglable. You must ensure isTogglable is set to true")}
        isOn = !isOn
    }
    
    private func isTouchInside(_ touch: UITouch?) -> Bool {
        guard let touch = touch else { return false }
        let touchPoint = touch.location(in: self)
        return self.bounds.contains(touchPoint)
    }
    var forcePushThreshold = CGFloat(0.7)
    override  func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if generateEvents.contains(.touchDown) {
            onTouchDown()
            touchDownHaptic()
        }
    }
    private var wasInside = true
    private var isForceTouch = false
    override  func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let isInside = isTouchInside(touches.first)
        //        print("Touches moved is inside \(isInside)")
        let movedOutside = !isInside && wasInside
        let movedInside = isInside && !wasInside
        if generateEvents.contains(.touchDragEnter) && movedInside {
            print("Drag Enter")
            setupForTouchDownState()
            touchDownHaptic()
            
        } else if generateEvents.contains(.touchDragExit) && movedOutside {
            if generateEvents.contains(.touchDragExit) {
                print("Drag exit")
                setupForDragExitState()
                touchDragExitHaptic()
            }
        } else if !isForceTouch {
            //moved around within the frame
            let wasForceTouch = forceTouchDown != nil && touches.first?.force ?? forcePushThreshold - 0.01 >= forcePushThreshold
            if wasForceTouch && generateEvents.contains(.touchDownForce) {
                print("Force touch")
                isForceTouch = true
                onForceTouchDown()
                touchDownHaptic()
            }
        }
        
        wasInside = isInside
    }
    
    override  func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("Touches Ended")
        guard !isForceTouch else {
            setupForNormalState()
            isForceTouch = false
            return
        }
        guard isTouchInside(touches.first) else {
            if generateEvents.contains(.touchUp) {
                print("Touch up outside")
                onTouchUp()
                touchUpHaptic()
            }
            return
        }
        if generateEvents.contains(.touchUpInside) {
            print("Touch up inside")
            onTouchUpInside()
            touchUpInsideHaptic()
        }
    }
    private var gradientLayer: CAGradientLayer?
    
    override  func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        if let gradientLayer = gradientLayer {
            gradientLayer.frame = layer.bounds
        }
    }
    
     func gradientBackground(start: CGPoint, end: CGPoint, _ colours: [UIColor] = [.black, .white]) {
        var layer: CAGradientLayer! = gradientLayer
        if layer == nil {
            layer = CAGradientLayer()
            self.layer.addSublayer(layer)
        }
        gradientLayer = layer
        layer.locations = [1.0, 0.0]
        layer.startPoint = start
        layer.endPoint = end
        layer.colors = colours.map { $0.cgColor }
    }
}
