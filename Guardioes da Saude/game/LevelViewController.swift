//
//  LevelViewController.swift
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 4/27/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

import UIKit

class LevelViewController: UIViewController {
    
    var titleBarImage: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        let btnBack = UIBarButtonItem(title: " ", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = btnBack
        
        if let _ = self.titleBarImage {
            self.navigationController?.navigationBar.addSubview(self.titleBarImage!)
        }else{
            self.titleBarImage = UIImageView(image: UIImage(named: "gdSToolbar"))
            let imgSize = CGSize(width: 400, height: 70)
            let imgXPoint = ((self.navigationController?.navigationBar.frame.size.width)!/2) - (imgSize.width/2)
            self.titleBarImage?.frame = CGRectMake(imgXPoint, -25, imgSize.width, imgSize.height)
            
            self.navigationController?.navigationBar.addSubview(self.titleBarImage!)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let _ = self.titleBarImage{
            self.titleBarImage?.removeFromSuperview()
        }
    }
}
