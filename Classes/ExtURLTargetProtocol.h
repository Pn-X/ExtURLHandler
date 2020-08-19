//
//  ExtURLTargetProtocol.h
//  Pods
//
//  Created by hang_pan on 2020/8/19.
//

#ifndef ExtURLTargetProtocol_h
#define ExtURLTargetProtocol_h

#import "ExtURLInfo.h"

@protocol ExtURLTargetProtocol <NSObject>

+ (NSArray <NSString *>*)ext_targetUniqueName;

@optional;
+ (id)ext_targetConstructor:(ExtURLInfo *)info;

- (BOOL)ext_targetReuseable;

- (BOOL)ext_targetVerifyInfo:(ExtURLInfo *)info;

@end


#endif /* ExtURLTargetProtocol_h */
