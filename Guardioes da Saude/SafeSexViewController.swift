//
//  SafeSexViewController.swift
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 6/17/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

import UIKit

class SafeSexViewController: UIViewController {

    @IBOutlet weak var txtContent: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = NSLocalizedString("safe_sex.title", comment: "")
        
        let btnBack = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = btnBack;
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.txtContent.setContentOffset(CGPointZero, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
