import UIKit

class MenuViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    let positionProfile = 0
    let positionSettings = 1
    let positionAbout = 2
    let positionHelp = 3
    let positionExit = 4
    
    // temp
    let menuArray = ["Perfil", "Configurações", "Sobre", "Ajuda", "Sair"]
    
    let cellIdentifier = "MenuCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let menuCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MenuCell
        
        menuCell.name.text = menuArray[indexPath.row]
        
        return menuCell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == positionProfile {
            
            let viewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            
            navigationController?.pushViewController(viewController, animated: true)
        
        } else if indexPath.row == positionSettings {
            
            let viewController = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
            
            navigationController?.pushViewController(viewController, animated: true)
        
        } else if indexPath.row == positionAbout {
            
            let viewController = AboutViewController(nibName: "AboutViewController", bundle: nil)
            
            navigationController?.pushViewController(viewController, animated: true)
            
        } else if indexPath.row == positionHelp {
            
            let viewController = HelpViewController(nibName: "HelpViewController", bundle: nil)
            
            navigationController?.pushViewController(viewController, animated: true)
            
        } else if indexPath.row == positionExit {
            // Show dialog
        }
    }
}
