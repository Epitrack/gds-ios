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

    override func viewDidLoad() {
        super.viewDidLoad()
        pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        pageController.dataSource = self
        pageController.view.frame = self.view.bounds
        let initialViewController = viewControllerAtIndex(0)
        let viewControllers = [initialViewController]
        self.pageController.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        pageController.didMoveToParentViewController(self)
        
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
        
        if index == 5 {
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
        return 5;
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0;
    }
}
