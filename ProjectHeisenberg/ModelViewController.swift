import UIKit

class ViewControllerModel: NSObject {
    weak var viewController: ViewControllerDisplayLogic?
    
    override init() { }
    
    func controllerConnected() { }
}

protocol ViewControllerDisplayLogic: class {
    func updateFromModel()
    ///Called by model when its data is considered changed enough to warrant updating
    func modelDirty()
}

class ModelViewController<ViewModel>: UIViewController, ViewControllerDisplayLogic where ViewModel: ViewControllerModel {
    var isDirty = false
    var model: ViewModel? {
        didSet {
            if oldValue != model {
                model?.viewController = self
                self.model?.controllerConnected()
            }
            self.updateFromModel()
        }
    }
    
    func modelDirty() {
        isDirty = true
    }
    
   @discardableResult func model(_ model: ViewModel) -> Self {
       self.model = model
       return self
   }
    
    init(model: ViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
        self.model?.viewController = self
        self.model?.controllerConnected()
        self.updateFromModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateFromModel() {
        fatalError("Missing implementation of `updateFromModel()` in \(self)")
    }
}
