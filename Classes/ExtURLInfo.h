//
//  ExtURLInfo.h
//  ExtURLHandler
//
//  Created by hang_pan on 2020/8/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExtURLInfo : NSObject

@property (nonatomic, copy) NSString *scheme;
@property (nonatomic, copy, nullable) NSString *host;
@property (nonatomic, copy, nullable) NSString *user;
@property (nonatomic, copy, nullable) NSString *password;
@property (nonatomic, copy) NSString *target;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, strong) NSDictionary *query;
@property (nonatomic, copy, nullable) NSString *fragment;

@end

NS_ASSUME_NONNULL_END
