import UIKit

class MainViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMenuButton()
    }
    
    private func loadMenuButton() {
        
        let menuButton = UIBarButtonItem(image: UIImage(named: "Menu"),
                                         style: UIBarButtonItemStyle.Plain,
                                         target: self,
                                         action: "onMenu")
        
        navigationItem.setLeftBarButtonItem(menuButton, animated: true)
    }
    
    func onMenu() {
        
        let viewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func onNews(sender: AnyObject) {
    
        let viewController = NewsViewController(nibName: "NewsViewController", bundle: nil)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func onMap(sender: AnyObject) {
    
        let viewController = MapViewController(nibName: "MapViewController", bundle: nil)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func onJoin(sender: AnyObject) {
        
        let viewController = SelectParticipantViewController(nibName: "SelectParticipantViewController", bundle: nil)
        
        navigationController?.pushViewController(viewController, animated: true)
    
    }
    
    @IBAction func onTip(sender: AnyObject) {
        
        let viewController = TipViewController(nibName: "TipViewController", bundle: nil)
        
        navigationController?.pushViewController(viewController, animated: true)
    
    }
    
    @IBAction func onDiary(sender: AnyObject) {
        
        let viewController = DiaryViewController(nibName: "DiaryViewController", bundle: nil)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
