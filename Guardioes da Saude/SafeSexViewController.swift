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

//        self.navigationItem.title = NSLocalizedString("safe_sex.title", comment: "")
        let titleLabel = UILabel(frame: CGRectMake(0,0,200,40))
        titleLabel.text = NSLocalizedString("safe_sex.title", comment: "")
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5;
        self.navigationItem.titleView = titleLabel;
        
        let btnBack = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = btnBack;
//        self.txtContent.setContentOffset(CGPointZero, animated: false)
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
//        self.txtContent.setContentOffset(CGPointZero, animated: false)
        ViewUtil.applyFont(self.txtContent.font, withColor: UIColor(red: 15.0/255.0, green: 76.0/255.0, blue: 153.0/255.0, alpha: 1),
                           ranges: [NSLocalizedString("safe_sex.subtitle_1", comment: ""),
                            NSLocalizedString("safe_sex.subtitle_2", comment: ""),
                            NSLocalizedString("safe_sex.subtitle_3", comment: ""),
                            NSLocalizedString("safe_sex.subtitle_4", comment: "")],
                           atTextView: self.txtContent)
        
    }
}
