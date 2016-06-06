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
    var questionViewRef: QuestionViewController?
    var level: Int!
    var part: Int!
    var stars :Int!
    var isLevelDone = false
    
    @IBOutlet weak var imgPuzzle: UIImageView!
    @IBOutlet weak var viewPart: UIView!
    @IBOutlet weak var imgLvl: UIImageView!
    @IBOutlet weak var imgStar1: UIImageView!
    @IBOutlet weak var imgStar2: UIImageView!
    @IBOutlet weak var imgStar3: UIImageView!
    @IBOutlet weak var btnNextQuestion: UIButton!
    
    var titleBarImage: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        
        self.viewPart.hidden = false
        self.imgLvl.hidden = true
        let img = UIImage(named: "img_lvl\(self.level)_pt\(part)")
        self.imgPuzzle.image = img
        
        self.btnNextQuestion.enabled = !isLevelDone
        
        switch self.stars {
        case 1:
            self.imgStar2.image = UIImage(named: "icon_unstar_2")
            self.imgStar3.image = UIImage(named: "icon_unstar_3")
        case 2:
            self.imgStar3.image = UIImage(named: "icon_unstar_3")
        default:
            break
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
        self.puzzeViewReference?.viewQuestion.hidden = true
        
        self.navigationController?.popViewControllerAnimated(true)
        if let puzzeViewReference = self.puzzeViewReference {
            if let part = self.part {
                puzzeViewReference.transitionQuestion(self.level, part: part, isLevelDone: isLevelDone)
            }else{
                
            }
        }
    }
    
    @IBAction func btnNextQuestion(sender: AnyObject) {
        self.puzzeViewReference?.viewQuestion.hidden = true
        
        self.navigationController?.popViewControllerAnimated(true)
        if let puzzeViewReference = self.puzzeViewReference {
            if let part = self.part {
                puzzeViewReference.transitionQuestion(self.level, part: part, callNextQuestion: true, isLevelDone: isLevelDone)
            }else{
                
            }
        }
    }
    
    @IBAction func btnRepeatQuestion(sender: AnyObject) {
        self.questionViewRef?.resetView()
        self.questionViewRef?.breakTime = false
        self.questionViewRef?.animateCircle(15)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
