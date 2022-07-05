import UIKit

class AlertViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func addAlertAction(_ message :String) -> UIAlertController{
        let alertBox = UIAlertController(title: "알림", message: "\(message)", preferredStyle: .alert)
        let action  = UIAlertAction(title: "확인", style: .destructive, handler: nil)
        alertBox.addAction(action)
        return alertBox
    }
}
