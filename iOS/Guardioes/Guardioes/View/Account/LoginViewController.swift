import UIKit

class LoginViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func onLogin(sender: AnyObject) {
        
        let viewController = MainViewController(nibName: "MainViewController", bundle: nil)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
