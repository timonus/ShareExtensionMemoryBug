//
//  ViewController.m
//  ShareExtensionTester
//
//  Created by Tim Johnsen on 12/20/22.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *imageDataButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 300, 64)];
    [imageDataButton setTitle:@"Share image NSData" forState:UIControlStateNormal];
    [imageDataButton addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        // Share image as data
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"very-large-photo" ofType:@"jpg"]]] applicationActivities:nil];
        [self presentViewController:activityViewController animated:YES completion:nil];
    }] forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(imageDataButton.frame) + 40, 300, 64)];
    [imageButton setTitle:@"Share UIImage" forState:UIControlStateNormal];
    [imageButton addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        // Share UIImage
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[[UIImage imageNamed:@"very-large-photo.jpg"]] applicationActivities:nil];
        [self presentViewController:activityViewController animated:YES completion:nil];
    }] forControlEvents:UIControlEventTouchUpInside];
    
    for (UIButton *button in @[imageDataButton, imageButton]) {
        [button setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 8;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [[UIColor systemBlueColor] CGColor];
        [self.view addSubview:button];
    }
}


@end
