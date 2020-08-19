//
//  Router.m
//  Example
//
//  Created by hang_pan on 2020/8/19.
//  Copyright © 2020 hang_pan. All rights reserved.
//

#import "Router.h"
#import <ExtURLHandler/ExtURLHandler.h>

@implementation Router

+ (NSArray <NSString *>*)ext_targetUniqueName {
    return @[@"router"];
}

- (void)routeTo:(ExtURLInfo *)info {
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = info.query[@"color"];
    vc.title = info.query[@"title"];
    UINavigationController *navi = info.query[@"navi"];
    [navi pushViewController:vc animated:YES];
}

@end
