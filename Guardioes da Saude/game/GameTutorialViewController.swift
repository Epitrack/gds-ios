//
//  GameTutorialViewController.swift
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 4/20/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

import UIKit

class GameTutorialViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageController: UIPageViewController!
    var index = 0
    var titleBarImage: UIImageView?

    @IBOutlet weak var presentationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        pageController.dataSource = self
        pageController.view.frame = self.presentationView.bounds
        let initialViewController = viewControllerAtIndex(0)
        let viewControllers = [initialViewController]
        self.pageController.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        addChildViewController(pageController)
        self.presentationView.addSubview(pageController.view)
        pageController.didMoveToParentViewController(self)
        
        let btnBack = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = btnBack
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
        if let _ = self.titleBarImage {
            self.titleBarImage?.removeFromSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let gameTutorialItemView = viewController as? GameTutorialItemViewController {
            index = gameTutorialItemView.index!
        }
        
        index += 1
        
        if index == 6 {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let gameTutorialItemView = viewController as? GameTutorialItemViewController {
            index = gameTutorialItemView.index!
        }
        
        if index == 0 {
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> GameTutorialItemViewController{
        let gameTutorialView = GameTutorialItemViewController()
        gameTutorialView.index = index
        
        return gameTutorialView;
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 6;
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0;
    }
    @IBAction func btnNext(sender: AnyObject) {
        var arrViews = self.navigationController?.viewControllers
        let view = arrViews![arrViews!.count - 2]
        if view.isEqual(StartViewController) {
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            let preferences = NSUserDefaults.standardUserDefaults();
            preferences.setValue("true", forKey: kGameTutorialReady)
            preferences.synchronize()
            User.getInstance().isGameTutorailReady = true
            
            let startGameView = StartViewController()
            self.navigationController?.pushViewController(startGameView, animated: true)
        }
    }
}
