//
//  ExtURLHandler.h
//  ExtURLHandler
//
//  Created by Pn-X on 2020/5/4.
//  Copyright © 2020 pn-x. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURL+ExtURLHandler.h"
#import "ExtURLTargetProtocol.h"

typedef NSString ExtURLHandlerQueryKey;

extern ExtURLHandlerQueryKey * const ExtURLHandlerAnimatedKey;
extern ExtURLHandlerQueryKey * const ExtURLHandlerCallbackKey;

//URL format: appScheme[required]://host[optionl]/target[required]/action[required]?query[optionl]
@interface ExtURLHandler : NSObject

+ (instancetype)singleton;

- (void)registTargetClass:(Class)target;
- (Class)matchClassForName:(NSString *)uniqueName;
- (id)mactchInstanceForName:(NSString *)uniqueName;

- (BOOL)validateURL:(NSURL *)URL;
- (BOOL)validateURLString:(NSString *)URLString;

- (id)handleURL:(NSURL *)URL;
- (id)handleURLString:(NSString *)URLString;

- (NSString *)targetDescription;

@end
