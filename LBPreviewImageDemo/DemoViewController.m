
//
//  DemoViewController.m
//  LBPreviewImageDemo
//
//  Created by 李祖建 on 2017/10/13.
//  Copyright © 2017年 LittleBitch. All rights reserved.
//

#import "DemoViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "PreviewImageViewController.h"

@interface DemoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,PreviewImageViewControllerDelegate>

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImagePickerController *picker;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"刘楚恬3.jpg"]];
    self.imageView.frame = CGRectMake(0, 0, 200, 250);
    self.imageView.center = self.view.center;
    self.imageView.backgroundColor = [UIColor blackColor];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self.imageView addGestureRecognizer:tapGesture];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.clipsToBounds = YES;
    
    //这个是去除默认系统选框的效果
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemPressed:)];
}


- (UIImagePickerController *)picker
{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.allowsEditing = NO;
    }
    return _picker;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage *dataImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        
        
        //如果不是相机，就走自定义的imagepiker的选择界面
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            [self chooseWithImage:dataImage];
        }else{
            
            PreviewImageViewController *photoDetailViewController = [[PreviewImageViewController alloc]init];
            photoDetailViewController.image = dataImage;
            photoDetailViewController.delegate = self;
            [picker pushViewController:photoDetailViewController animated:YES];
        }
    }
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PreviewImageViewControllerDelegate
- (void)clickedCancelBtn:(UIButton *)sender
{
    [self.picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)chooseWithImage:(UIImage *)image
{
    NSLog(@"dataImg:%@",NSStringFromCGSize(image.size));
    
    self.imageView.image = image;
    
    [self.picker dismissViewControllerAnimated:YES completion:nil];
}




- (void)tapGestureRecognizer:(UITapGestureRecognizer *)sender
{
    [PreviewImageViewController showImage:self.imageView backgroundColor:[UIColor blackColor]];
}

- (void)rightItemPressed:(UIBarButtonItem *)sender
{
    [self localPhone];
    
}



//打开相机
-(void)takePhone
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status ==AVAuthorizationStatusDenied)
    {
        //        [self showAlertControlWithMessage:MESSAGE_NOTOPENCAERA];
        return;
    }
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        
    }
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.picker animated:YES completion:nil];
    }else
    {
        //        [AppDelegate showHintLabelWithMessage:@"据说相机无法正常使用~"];
    }
}
//打开相册
-(void)localPhone
{
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.picker animated:YES completion:nil];
}

@end
