//
//  NSURL+ExtURLHandler.m
//  ExtURLHandler
//
//  Created by Pn-X on 2020/5/5.
//  Copyright © 2020 pn-x. All rights reserved.
//

#import "NSURL+ExtURLHandler.h"
#import <objc/runtime.h>

static BOOL ExtURLValidStashKey(NSString *key) {
    if (key.length <= 4 || ![key hasPrefix:@"{{"] || ![key hasSuffix:@"}}"]) {
        return NO;
    }
    return YES;
}

static NSString *ExtURLParseStashKey(NSString *key) {
    if (!ExtURLValidStashKey(key)) {
        return @"";
    }
    return [key substringWithRange:NSMakeRange(2, key.length - 4)];
}

static NSString *ExtURLGenerateStashKey(NSString *key) {
    return [NSString stringWithFormat:@"{{%@}}", key];
}

@implementation NSURL (ExtURLHandler)

+ (NSURL *)ext_URLWithString:(NSString *)URLString appendQuery:(NSDictionary *)query {
    NSMutableDictionary *stash = [NSMutableDictionary dictionary];
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:URLString];
    if (query) {
        NSMutableArray *array = components.queryItems?[components.queryItems mutableCopy]:[NSMutableArray array];
        for (NSString *key in query) {
            id object = query[key];
            NSURLQueryItem *item = nil;
            if ([object isKindOfClass:[NSString class]]) {
                item = [[NSURLQueryItem alloc] initWithName:key value:query[key]];
            } else {
                stash[key] = object;
                item = [[NSURLQueryItem alloc] initWithName:key value:ExtURLGenerateStashKey(key)];
            }
            [array addObject:item];
        }
        components.queryItems = array;
    }
    NSURL *url = [components URL];
    url.ext_queryStash = stash;
    return url;
}

- (NSMutableDictionary *)ext_queryStash {
    NSMutableDictionary *dic = objc_getAssociatedObject(self, "ext_queryStash");
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, "ext_queryStash", dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dic;
}

- (void)ext_setQueryStash:(NSMutableDictionary *)ext_queryStash {
    objc_setAssociatedObject(self, "ext_queryStash", ext_queryStash, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)ext_query {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:YES];
    for (NSURLQueryItem *item in components.queryItems) {
        [dic setValue:item.value?:@"" forKey:item.name?:@""];
    }
    return dic;
}

- (NSMutableDictionary *)ext_resolvedQuery {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:YES];
    for (NSURLQueryItem *item in components.queryItems) {
        id value = item.value;
        if (ExtURLValidStashKey(value)) {
            value = self.ext_queryStash[ExtURLParseStashKey(value)];
        }
        [dic setValue:value?:@"" forKey:item.name?:@""];
    }
    return dic;
}

@end
