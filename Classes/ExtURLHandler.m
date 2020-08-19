//
//  ExtURLHandler.m
//  ExtURLHandler
//
//  Created by Pn-X on 2020/5/4.
//  Copyright © 2020 pn-x. All rights reserved.
//

#import "ExtURLHandler.h"
#import "ExtURLInfo.h"
#import <objc/runtime.h>

SEL ExtURLHandlerArgumentSelector(NSString *action);
SEL ExtURLHandlerSelector(NSString *action);

@interface ExtURLHandler ()

@property (nonatomic, strong) NSMutableDictionary *targetClassMap;

@property (nonatomic, strong) NSMutableDictionary *reuseInstanceMap;

@property (nonatomic, strong)NSMutableSet<NSString *> *appSchemeSet;

@end

@implementation ExtURLHandler

- (instancetype)init {
    self = [super init];
    if (self) {
        self.reuseInstanceMap = [NSMutableDictionary dictionary];
        self.targetClassMap = [NSMutableDictionary dictionary];
        self.appSchemeSet = [NSMutableSet new];
        NSArray *typeArray = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleURLTypes"];
        for (NSDictionary *dic in typeArray) {
            NSArray *schemes = [dic objectForKey:@"CFBundleURLSchemes"];
            [self.appSchemeSet addObjectsFromArray:schemes];
        }
    }
    return self;
}

+ (instancetype)singleton {
    static ExtURLHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [ExtURLHandler new];
    });
    return handler;
}

//just for pass complier
+ (instancetype)shared {
    return [self singleton];
}


- (void)registTargetClass:(Class)targetClass {
    NSAssert(targetClass != nil, @"[ExtURLHandler][targetClass cannot be nil]");
    NSArray *uniqueNames = [targetClass ext_targetUniqueName];
    for (NSString *uniqueName in uniqueNames) {
        if (self.targetClassMap[uniqueName]) {
            @throw [NSException exceptionWithName:@"" reason:@"" userInfo:@{}];
        }
        self.targetClassMap[uniqueName] = targetClass;
    }
}

- (Class)matchClassForName:(NSString *)uniqueName {
    return self.targetClassMap[uniqueName];
}

- (id)mactchInstanceForName:(NSString *)uniqueName {
    return self.reuseInstanceMap[uniqueName];
}


- (BOOL)validateURL:(NSURL *)URL {
    NSString *scheme = URL.scheme?:@"";
    if (scheme.length <= 0) {
        return NO;
    }
    NSArray *components = URL.pathComponents;
    if (components.count < 3) {
        return NO;
    }
    NSString *target = components[1];
    if (target.length <= 0) {
        return NO;
    }
    NSString *action = components[2];
    if (action.length <= 0) {
        return NO;
    }
    return YES;
}

- (BOOL)validateURLString:(NSString *)URLString {
    return [self validateURL:[NSURL URLWithString:URLString]];
}

- (id)handleURL:(NSURL *)URL {
    if (![self validateURL:URL]) {
        return nil;
    }
    ExtURLInfo *info = [ExtURLInfo new];
    info.scheme = URL.scheme;
    info.host = URL.host;
    info.user = URL.user;
    info.password = URL.password;
    NSArray *components = URL.pathComponents;
    info.target = components[1];
    info.action = components[2];
    info.query = URL.ext_resolvedQuery;
    info.fragment = URL.fragment;
    
    Class aClass = self.targetClassMap[info.target];
    id instance = self.reuseInstanceMap[info.target];
    if (!instance) {
        if ([aClass respondsToSelector:@selector(ext_targetConstructor:)]) {
            instance = [aClass ext_targetConstructor:info];
        } else if ([aClass respondsToSelector:@selector(singleton)]) {
            instance = [aClass singleton];
        } else if ([aClass respondsToSelector:@selector(shared)]) {
            instance = [aClass shared];
        } else {
            instance = [aClass new];
        }
        if ([instance respondsToSelector:@selector(ext_targetReuseable)] && [instance ext_targetReuseable]) {
            self.reuseInstanceMap[info.target] = instance;
        }
    }
    NSNumber *responds = objc_getAssociatedObject(instance, "ExtRespondsToTargetVerifyInfo");
    if (responds == nil) {
        if ([instance respondsToSelector:@selector(ext_targetVerifyInfo:)]) {
            responds = @YES;
        } else {
            responds = @NO;
        }
        objc_setAssociatedObject(instance, "ExtRespondsToTargetVerifyInfo", responds, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    BOOL verfiy = YES;
    if ([responds boolValue]) {
        verfiy = [instance ext_targetVerifyInfo:info];
    }
    if (!verfiy) {
        NSLog(@"[ExtURLHandler]Cannot handle URL:%@", URL);
        return nil;
    }
    SEL argSelector = ExtURLHandlerArgumentSelector(info.action);
    SEL selector = ExtURLHandlerSelector(info.action);
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([instance respondsToSelector:argSelector]) {
        return [instance performSelector:argSelector withObject:info];
    } else if ([instance respondsToSelector:selector]){
        return [instance performSelector:selector];
    }
    #pragma clang diagnostic pop
    NSLog(@"[ExtURLHandler]Cannot handle URL:%@", URL);
    return nil;
}

- (id)handleURLString:(NSString *)URLString {
    return [self handleURL:[NSURL URLWithString:URLString]];
}

- (NSString *)targetDescription {
    return [self.targetClassMap description];
}

@end

@implementation ExtURLHandler (StringMethod)



@end

ExtURLHandlerQueryKey * const ExtURLHandlerAnimatedKey = @"__animated";
ExtURLHandlerQueryKey * const ExtURLHandlerCallbackKey = @"__callback";

SEL ExtURLHandlerArgumentSelector(NSString *action) {
    return NSSelectorFromString([NSString stringWithFormat:@"%@:", action]);
}

SEL ExtURLHandlerSelector(NSString *action) {
    return NSSelectorFromString(action);
}
