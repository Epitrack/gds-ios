//
//  SelectAvatarViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 24/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "SelectAvatarViewController.h"
#import "User.h"
#import "ProfileFormViewController.h"
#import "DTO.h"

@interface SelectAvatarViewController () {
    User *user;
    DTO *dto;
}

@end

@implementation SelectAvatarViewController

@synthesize library;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    user = [User getInstance];
    dto = [DTO getInstance];
    
    self.navigationItem.title = @"Editar Foto";
    //self.navigationItem.hidesBackButton = YES;
    self.library = [[ALAssetsLibrary alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnPhotoAction:(id)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Aparelho não possui câmera." preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button OK");
        }];
        [alert addAction:defaultAction];
    } else {
    
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //self.imageView.image = chosenImage;
    
    if (chosenImage != nil) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
       
        NSString *timeString = [dateFormatter stringFromDate:[NSDate date]];
        NSString *idPhoto;
        
        if (user.idHousehold != nil && ![user.idHousehold isEqualToString:@""]) {
            idPhoto = user.idHousehold;
        } else {
            idPhoto = user.idUser;
        }
        
        NSString *imageName = [NSString stringWithFormat: @"gdsprofile_%@_%@.png", idPhoto, timeString];
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:imageName];
        
        NSData* data = UIImagePNGRepresentation(chosenImage);
        [data writeToFile:path atomically:YES];
        
        UIImage* image = [UIImage imageWithContentsOfFile:path];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        user.avatar = @"";
        user.photo = @"";
        
        dto.data = image;
        
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)btn1Action:(id)sender {
    [self setAvatar:@"1"];
}

- (IBAction)btn2Action:(id)sender {
    [self setAvatar:@"2"];
}

- (IBAction)btn5Action:(id)sender {
    [self setAvatar:@"5"];
}

- (IBAction)btn6Action:(id)sender {
    [self setAvatar:@"6"];
}

- (IBAction)btn4Action:(id)sender {
    [self setAvatar:@"4"];
}

- (IBAction)btn8Action:(id)sender {
    [self setAvatar:@"8"];
}

- (IBAction)btn9Action:(id)sender {
    [self setAvatar:@"9"];
}

- (IBAction)btn10Action:(id)sender {
    [self setAvatar:@"10"];
}

- (IBAction)btn7Action:(id)sender {
    [self setAvatar:@"7"];
}

- (IBAction)btn11Action:(id)sender {
    [self setAvatar:@"11"];
}

- (IBAction)btn12Action:(id)sender {
    [self setAvatar:@"12"];
}

- (IBAction)btn3Action:(id)sender {
    [self setAvatar:@"3"];
}

- (void) setAvatar:(NSString *)idAvatar {
    user.avatar = @"";
    user.photo = @"";
    
    //user.avatar = idAvatar;
    dto.string = idAvatar;
    dto.data = idAvatar;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
