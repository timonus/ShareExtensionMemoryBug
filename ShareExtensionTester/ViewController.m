//
//  ViewController.m
//  ShareExtensionTester
//
//  Created by Tim Johnsen on 12/20/22.
//

#import "ViewController.h"

@interface ViewController ()

@property (copy) NSString *filename;

@end

static NSString *const kFileExtension = @"heic";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.filename = @"48mp";
    
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithFrame:CGRectMake(20, 100, 300, 64) actions:@[
        [UIAction actionWithTitle:@"48mp" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        self.filename = @"48mp";
    }],
        [UIAction actionWithTitle:@"12mp" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        self.filename = @"12mp";
    }],
        [UIAction actionWithTitle:@"7mp" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        self.filename = @"7mp";
    }],
    ]];
    seg.selectedSegmentIndex = 0;
    [self.view addSubview:seg];
    
    UIButton *imageDataButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(seg.frame) + 40, 300, 64)];
    imageDataButton.titleLabel.numberOfLines = 0;
    [imageDataButton setTitle:@"Share image NSData\n(Fast, no memory bloat)" forState:UIControlStateNormal];
    [imageDataButton setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"] forState:UIControlStateSelected];
    [imageDataButton addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        // Share image as data
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.filename ofType:kFileExtension] options:NSDataReadingMappedIfSafe error:nil]] applicationActivities:nil];
        activityViewController.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
            [self dismissViewControllerAnimated:YES completion:^{
                imageDataButton.selected = NO;
            }];
        };
        [self presentViewController:activityViewController animated:YES completion:nil];
        imageDataButton.selected = YES;
    }] forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(imageDataButton.frame) + 40, 300, 64)];
    imageButton.titleLabel.numberOfLines = 0;
    [imageButton setTitle:@"Share UIImage\n(Slow, memory bloat)" forState:UIControlStateNormal];
    [imageButton setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"] forState:UIControlStateSelected];
    [imageButton addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        // Share UIImage
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[[UIImage imageNamed:[NSString stringWithFormat:@"%@.%@", self.filename, kFileExtension]]] applicationActivities:nil];
        activityViewController.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
            [self dismissViewControllerAnimated:YES completion:^{
                imageButton.selected = NO;
            }];
        };
        [self presentViewController:activityViewController animated:YES completion:nil];
        imageButton.selected = YES;
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
