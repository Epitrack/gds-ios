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
                print("asdasdasdasd")
            }
        }
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

    @IBAction func btnMedalAction(sender: AnyObject) {
        self.playSoundButton()
    }
    
    @IBAction func btnTrofeuAction(sender: AnyObject) {
        self.playSoundButton()
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
}
