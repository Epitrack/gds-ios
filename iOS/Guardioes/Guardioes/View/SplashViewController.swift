import UIKit

class SplashViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onEnter(sender: AnyObject) {
        
        let viewController = WelcomeViewController(nibName: "WelcomeViewController", bundle: nil)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
