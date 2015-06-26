import UIKit

class SplashViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        RequestManager().request(.GET, url: "https://flunearyou.org/flu-news.json", parameterMap: nil, encoding: .JSON)
    }

    @IBAction func onEnter(sender: AnyObject) {
        
        let viewController = WelcomeViewController(nibName: "WelcomeViewController", bundle: nil)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
