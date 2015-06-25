import UIKit

class WelcomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        
        let viewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func onCreateAccount(sender: AnyObject) {
        
        let viewController = CreateAccountViewController(nibName: "CreateAccountViewController", bundle: nil)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
