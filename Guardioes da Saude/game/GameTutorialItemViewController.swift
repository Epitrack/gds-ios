//
//  GameTutorialItemViewController.swift
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 4/22/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

import UIKit

class GameTutorialItemViewController: UIViewController {
    
    var index: Int!
    @IBOutlet weak var lbPageNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.title = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        switch index {
        case 0:
            self.lbPageNumber.text = NSLocalizedString("game_tutorial.welcome", comment: "")
        case 1:
            self.lbPageNumber.text = NSLocalizedString("game_tutorial.how_play", comment: "")
        case 2:
            self.lbPageNumber.text = NSLocalizedString("game_tutorial.rota", comment: "")
        case 3:
            self.lbPageNumber.text = NSLocalizedString("game_tutorial.fases", comment: "")
        case 4:
            self.lbPageNumber.text = NSLocalizedString("game_tutorial.correct_answer", comment: "")
        case 5:
            self.lbPageNumber.text = NSLocalizedString("game_tutorial.collect_pictures", comment: "")
        default:
            self.lbPageNumber.text = "Screen #\(self.index)"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
