import UIKit

class CreateAccountViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func onCreateAccount(sender: AnyObject) {
        
        let viewController = MainViewController(nibName: "MainViewController", bundle: nil)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
