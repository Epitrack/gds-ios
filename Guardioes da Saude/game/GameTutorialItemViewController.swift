//
//  GameTutorialItemViewController.swift
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 4/22/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

import UIKit

class GameTutorialItemViewController: UIViewController {
    
    var index: Int?
    @IBOutlet weak var lbPageNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.lbPageNumber.text = "Screen #\(self.index)"
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
