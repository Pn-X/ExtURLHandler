//
//  Alert.m
//  Example
//
//  Created by hang_pan on 2020/8/19.
//  Copyright © 2020 hang_pan. All rights reserved.
//

#import "Alert.h"
#import <ExtURLHandler/ExtURLHandler.h>

@implementation Alert

- (void)show:(ExtURLInfo *)info {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:info.query[@"title"] message:info.query[@"message"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancel];
    UIWindow *window = nil;
    for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
        if (windowScene.activationState == UISceneActivationStateForegroundActive) {
            window = windowScene.windows[0];
            break;
        }
    }
    [window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

+ (NSArray <NSString *>*)ext_targetUniqueName {
    return @[@"alerrrrrrt"];
}

@end
