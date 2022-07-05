import UIKit

class AlertViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func addAlertAction(_ message :String) -> UIAlertController{
//        guard let message =  message else { return }
        
        let alertBox = UIAlertController(title: "경고", message: "\(message)", preferredStyle: .alert)
        let action  = UIAlertAction(title: "확인", style: .destructive, handler: nil)
        alertBox.addAction(action)
        return alertBox
    }

}
