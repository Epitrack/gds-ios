//
//  OverlayViewController.m
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 2/12/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import "OverlayViewController.h"
#import "MBProgressHUD.h"
#import <Google/Analytics.h>

@interface OverlayViewController ()

@end

@implementation OverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;

    
    int position = 0;
    
    if (screenHeight == 568)
    {
        position = 124;
    }
    else
    {
        position = 80;
    }
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithOvalInRect:
                           CGRectMake(0.0f, 80.0f, 320.0f, 320.0f)];
    [path2 setUsesEvenOddFillRule:YES];
    
    [circleLayer setPath:[path2 CGPath]];
    
    [circleLayer setFillColor:[[UIColor clearColor] CGColor]];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 320, screenHeight-72) cornerRadius:0];
    
    [path appendPath:path2];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.8;
    [self.view.layer addSublayer:fillLayer];
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

- (IBAction)takePhoto:(id)sender {
    [self.pickerReference takePicture];
}

- (IBAction)cancel:(id)sender {
    [self.pickerReference dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_change_avatar"
                                                           label:@"Change avatar"
                                                           value:nil] build]];
    
    UIImage *image = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
    UIImage *imageCroped = [self imageByCroppingImage:image toSize:CGSizeMake(image.size.width, image.size.width)];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __block NSString *url;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:imageCroped];
        url = [[assetChangeRequest placeholderForCreatedAsset] localIdentifier];
    } completionHandler:^(BOOL success, NSError *error){
        if (!success) {
            NSLog(@"Error creating asset: %@", error);
        } else {
            [self.profileFormReference setPhoto:url];
            [picker dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size
{
    // not equivalent to image.size (which depends on the imageOrientation)!
    double refWidth = CGImageGetWidth(image.CGImage);
    double refHeight = CGImageGetHeight(image.CGImage);
    
    double x = (refWidth - size.width) / 2.0;
    double y = (refHeight - size.height) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:UIImageOrientationRight];
    CGImageRelease(imageRef);
    
    return cropped;
}
@end
