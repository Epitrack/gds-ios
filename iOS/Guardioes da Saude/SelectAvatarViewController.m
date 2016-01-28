//
//  SelectAvatarViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 24/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "SelectAvatarViewController.h"
#import "ProfileFormViewController.h"
#import "ViewUtil.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "MBProgressHUD.h"
#import <Google/Analytics.h>
@import PhotosUI;

@interface SelectAvatarViewController () {
    BOOL showCameraBtn;
}

@end

@implementation SelectAvatarViewController


- (instancetype)initWithBtnCamera: (bool) showBtnCamera{
    showCameraBtn = showBtnCamera;
    
    return [super init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Editar Foto";
    
    self.btnPhoto.hidden = !showCameraBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Select Avatar Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
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
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Aparelho não possui câmera."];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
    
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = (UIImage *) [info objectForKey: UIImagePickerControllerEditedImage];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __block NSString *url;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        url = [[assetChangeRequest placeholderForCreatedAsset] localIdentifier];
    } completionHandler:^(BOOL success, NSError *error){
        if (!success) {
            NSLog(@"Error creating asset: %@", error);
        } else {
            [self.profileFormCtr updatePicture:url];
            [picker dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
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
    self.profileFormCtr.pictureSelected = idAvatar;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
