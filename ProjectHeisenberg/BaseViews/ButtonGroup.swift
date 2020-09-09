import UIKit

///Used for grouping buttons together as radio buttons/check marks etc
open class ButtonGroup {
    let title: String?
    var allowsMultipleSelection = true
    private (set) var buttons = [Button]() {
        didSet {
            updateButtonStyles()
        }
    }
    
    init(_ title: String? = nil, _ buttons: [Button]) {
        self.title = title
        self.buttons = buttons
        updateButtonStyles()
    }
    private var ignoreUpdates = false
    
    var selectedButtons: [Button] {
        buttons.filter { $0.isOn }
    }
    func updateButtonStyles() {
        
        buttons.forEach { $0.style = .toggle(group: self) }
        buttons.forEach { button in
            button.isOnChanged = {[unowned self] _ in
                guard !self.ignoreUpdates else { return }
                
                if !self.allowsMultipleSelection {
                    self.ignoreUpdates = true
                    self.buttons
                        .filter { $0 != button }
                        .forEach { $0.isOn = false }
                    self.ignoreUpdates = false
                }                
            }
        }
    }
}
