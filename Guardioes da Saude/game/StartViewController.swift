//
//  StartViewController.swift
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 4/25/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

import UIKit
import AVFoundation

class StartViewController: UIViewController {
    
    var titleBarImage: UIImageView?
    var audioPlayer: AVAudioPlayer?
    var circleLayer: CAShapeLayer!
    var breakTime = false

    @IBOutlet weak var viewQuestion: UIView!
    @IBOutlet weak var viewQuestionTimer: UIView!
    @IBOutlet weak var lbTimer: UILabel!
    
    @IBOutlet weak var btnAnswer1: UIButton!
    @IBOutlet weak var btnAnswer2: UIButton!
    @IBOutlet weak var btnAnswer3: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        let btnBack = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = btnBack
        
        let path = NSBundle.mainBundle().pathForResource("effect_button", ofType: "mp3")
        if let _ = path {
            let url = NSURL.fileURLWithPath(path!)
            
            do{
                try self.audioPlayer = AVAudioPlayer(contentsOfURL: url)
            }catch{
                
            }
        }
        
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.viewQuestionTimer.frame.size.width / 2.0, y: self.viewQuestionTimer.frame.size.height / 2.0), radius: (self.viewQuestionTimer.frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = UIColor(red: 239.0/255.0, green: 98.0/255.0, blue: 26.0/255.0, alpha: 1).CGColor
        circleLayer.lineWidth = 7.0;
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = 0.0
        
        
        // Add the circleLayer to the view's layer's sublayers
        self.viewQuestionTimer.layer.addSublayer(circleLayer)
        self.viewQuestionTimer.layer.cornerRadius = self.viewQuestionTimer.frame.width/2;
    }
    
    func animateCircle(duration: NSTimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0
        
        // Do the actual animation
        circleLayer.addAnimation(animation, forKey: "animateCircle")
        
        
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue, {
            for i in 1...15 {
                if self.breakTime {
                    break
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.lbTimer.text = "\(i)"
                }
                sleep(1)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func resetQuestionDialog() {
        breakTime = false
        btnAnswer1.setBackgroundImage(UIImage(named: "btn_question"), forState: UIControlState.Normal)
        btnAnswer2.setBackgroundImage(UIImage(named: "btn_question"), forState: UIControlState.Normal)
        btnAnswer3.setBackgroundImage(UIImage(named: "btn_question"), forState: UIControlState.Normal)
    }

    @IBAction func btnMedalAction(sender: AnyObject) {
        self.playSoundButton()
    }
    
    @IBAction func btnTrofeuAction(sender: AnyObject) {
        self.playSoundButton()
        let levelView = LevelViewController()
        self.navigationController?.pushViewController(levelView, animated: false)
        
    }
    
    @IBAction func btnCloseQuestion(sender: AnyObject) {
        self.playSoundButton()
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.viewQuestion.transform = CGAffineTransformMakeScale(0.1, 0.1)
            self.viewQuestion.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (finished: Bool) -> Void in
            self.viewQuestion.hidden = true
            self.resetQuestionDialog()
        }
    }
    
    @IBAction func btnQuestionAction(sender: AnyObject) {
        self.playSoundButton()
        self.viewQuestion.transform = CGAffineTransformMakeScale(0.1, 0.1)
        self.viewQuestion.hidden = false;
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.viewQuestion.transform = CGAffineTransformIdentity
            self.viewQuestion.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        }) { (finished: Bool) -> Void in
            self.animateCircle(14.0)
        }
    }
    func playSoundButton() {
        if let _ = self.audioPlayer {
            if audioPlayer!.playing {
                audioPlayer!.stop()
                audioPlayer?.currentTime = 0
            }
            audioPlayer!.play()
        }
    }
    @IBAction func btnAnswerAction(sender: UIButton) {
        if sender.isEqual(self.btnAnswer1) {
            let congratulationScreen = CongratulationsViewController()
            self.navigationController?.pushViewController(congratulationScreen, animated: true)
        }else{
            btnAnswer1.setBackgroundImage(UIImage(named: "btn_correct_answer"), forState: UIControlState.Normal)
            btnAnswer2.setBackgroundImage(UIImage(named: "btn_wrong_answer"), forState: UIControlState.Normal)
            self.circleLayer .removeAllAnimations();
            self.breakTime = true
        }
    }
}
