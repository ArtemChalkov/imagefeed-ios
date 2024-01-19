
import UIKit

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    //var completion: ()->()
}

class AlertPresenter {
    
    var completion: (()->())?
    
    func show(model: AlertModel, controller: UIViewController) {
        
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let continueAction = UIAlertAction.init(
            title: model.buttonText,
            style: .default) { [weak self] action in
                
                guard let self else { return }
                
                self.completion?()
 
            }
        
        alert.view.accessibilityIdentifier = "GameResults"
        
        alert.addAction(continueAction)
        controller.present(alert, animated: true)
    }
}
