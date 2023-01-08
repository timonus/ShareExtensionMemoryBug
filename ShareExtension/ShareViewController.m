//
//  ShareViewController.m
//  ShareExtension
//
//  Created by Tim Johnsen on 12/29/22.
//

#import "ShareViewController.h"
@import UniformTypeIdentifiers;
#import <mach/mach.h>

@implementation ShareViewController

// https://stackoverflow.com/a/787535/3943258
CGFloat report_memory(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = TASK_BASIC_INFO_COUNT;
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        NSLog(@"Memory in use (in bytes): %lu", info.resident_size);
        NSLog(@"Memory in use (in MB): %f", ((CGFloat)info.resident_size / (1000 * 1000)));
        return ((CGFloat)info.resident_size / (1000 * 1000));
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
    }
    return 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    for (NSExtensionItem *const item in self.extensionContext.inputItems) {
        for (NSItemProvider *const provider in item.attachments) {
            const CFTimeInterval startTime = CACurrentMediaTime();
            [provider loadItemForTypeIdentifier:UTTypeImage.identifier
                                        options:@{}
                              completionHandler:^(NSObject<NSSecureCoding> *item, NSError * _Null_unspecified error) {
                const CFTimeInterval timeTaken = CACurrentMediaTime() - startTime;
                const BOOL success = item != nil;
                const CGFloat memory = report_memory();
                NSLog(@"Loaded item: %@\nError: %@", item, error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height / 2.0, self.view.bounds.size.width - 40, self.view.bounds.size.height / 2.0)];
                    label.backgroundColor = [UIColor systemBackgroundColor];
                    label.numberOfLines = 0;
                    label.font = [UIFont boldSystemFontOfSize:20.0];
                    label.text = [NSString stringWithFormat:@"Load success: %@\nMemory consumed (MB): %0.1f\nTime Taken (s): %0.1f", success ? @"Yes" : @"No", memory, timeTaken];
                    [self.view addSubview:label];
                });
            }];
        }
    }
}

@end
