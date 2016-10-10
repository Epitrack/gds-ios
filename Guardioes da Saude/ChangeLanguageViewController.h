//
//  ChangeLanguageViewController.h
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 4/4/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeLanguageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property BOOL goToTutorial;
@property (weak, nonatomic) IBOutlet UITableView *tableLanguages;
@end
