//
//  NSURL+ExtURLHandler.h
//  ExtURLHandler
//
//  Created by Pn-X on 2020/5/5.
//  Copyright © 2020 pn-x. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (ExtURLHandler)

@property (nonatomic, strong, setter=ext_setQueryStash:) NSMutableDictionary *ext_queryStash;

+ (NSURL *)ext_URLWithString:(NSString *)URLString appendQuery:(NSDictionary *)query;

- (NSMutableDictionary <NSString *, NSString *>*)ext_query;

- (NSMutableDictionary <NSString *, id>*)ext_resolvedQuery;

@end

NS_ASSUME_NONNULL_END
