//
//  CongratulationsViewController.swift
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 4/29/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

import UIKit

class CongratulationsViewController: UIViewController {
    
    var puzzeViewReference: PuzzeViewController?
    var level: Int!
    var part: Int?
    
    @IBOutlet weak var imgPuzzle: UIImageView!
    @IBOutlet weak var viewPart: UIView!
    @IBOutlet weak var imgLvl: UIImageView!
    
    var titleBarImage: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        
        if let part = self.part {
            self.viewPart.hidden = false
            self.imgLvl.hidden = true
            
            let img = UIImage(named: "img_lvl\(self.level)_pt\(part)")
            self.imgPuzzle.image = img
        }else{
            self.viewPart.hidden = true
            self.imgLvl.hidden = false
            
            let img = UIImage(named: "img_lvl\(self.level)")
            self.imgLvl.image = img
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
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

    @IBAction func btnQuestionAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        if let puzzeViewReference = self.puzzeViewReference {
            if let part = self.part {
                puzzeViewReference.transitionQuestion(self.level, part: part)
            }else{
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
