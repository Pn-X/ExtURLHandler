//
//  ViewController.m
//  Example
//
//  Created by hang_pan on 2020/8/19.
//  Copyright © 2020 hang_pan. All rights reserved.
//

#import "ViewController.h"
#import <ExtURLHandler/ExtURLHandler.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registTarget];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)]];
    [self.view addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress)]];
}

- (void)handleTap {
    NSURL *url = [NSURL ext_URLWithString:@"ext-url-handler:///router/routeTo?title=Test%20Title" appendQuery:@{
//        @"title":@"A BC",
        @"navi":self.navigationController,
        @"color":[UIColor redColor],
    }];
    [[ExtURLHandler singleton] handleURL:url];
}


- (void)handleLongPress {
    [[ExtURLHandler singleton] handleURLString:@"ext-url-handler:///alerrrrrrt/show?title=Test%20Title&message=Lorem%20ipsum%20dolor%20sit%20amet%2C%20ligula%20suspendisse%20nulla%20pretium%2C%20rhoncus%20tempor%20fermentum%2C%20enim%20integer%20ad%20vestibulum%20volutpat."];
}


//you can read all target by a configuration file(JSON/YAML/...)
- (void)registTarget {
    NSArray *array = @[
        NSClassFromString(@"Router"),
        NSClassFromString(@"Alert"),
    ];
    for (Class cls in array) {
        [[ExtURLHandler singleton] registTargetClass:cls];
    }
}


@end
