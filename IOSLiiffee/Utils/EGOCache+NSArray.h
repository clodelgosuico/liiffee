//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EGOCache/EGOCache.h>

@interface EGOCache (NSArray)
- (void)setArray:(NSArray*)array forKey:(NSString*)key;
- (void)setArray:(NSArray*)array forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

- (NSArray*)arrayForKey:(NSString*)key;
@end