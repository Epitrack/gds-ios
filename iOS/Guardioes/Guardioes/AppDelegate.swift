import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate { // GGLInstanceIDDelegate
    
    var window: UIWindow? = UIWindow(frame: UIScreen.mainScreen().bounds)
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if let window = window {
            
            let viewController = SplashViewController(nibName: "SplashViewController", bundle: nil)
            
            window.rootViewController = UINavigationController(rootViewController: viewController)
            
            window.makeKeyAndVisible()
        }
        
        setupPush(application)
        
        return true
    }
    
    private func setupPush(application: UIApplication) {
        
        let notificationType: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Sound, UIUserNotificationType.Badge]
        
        let notificationSetting = UIUserNotificationSettings(forTypes: notificationType,
                                                             categories: nil)
        
        application.registerUserNotificationSettings(notificationSetting)
        
        application.registerForRemoteNotifications()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        requestPushToken()
    }
    
    private func requestPushToken() {
        
        /* GGLInstanceID.sharedInstance().startWithConfig(GGLInstanceIDConfig.defaultConfig())
        
        let option = [kGGLInstanceIDRegisterAPNSOption: deviceToken, kGGLInstanceIDAPNSServerTypeSandboxOption: true]
        
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(Push.Sender,
                                                                 scope: kGGLInstanceIDScopeGCM,
                                                                 options: option,
                                                                 handler: pushHandler) */
    }
    
    func pushHandler(token: String!, error: NSError!) {
        
        if let token = token {
            
            print(token)
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        // TEMP
        print("Fail to register")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        // TEMP
        print("Notification received")
    }
    
    func onTokenRefresh() {
        
        requestPushToken()
    }
}
