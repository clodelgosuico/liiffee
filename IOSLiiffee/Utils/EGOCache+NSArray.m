//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import "EGOCache+NSArray.h"


@implementation EGOCache (NSArray)

- (void)setArray:(NSArray*)array forKey:(NSString*)key {
    [self setArray:array forKey:key withTimeoutInterval:self.defaultTimeoutInterval];
}

- (void)setArray:(NSArray*)array forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval {
    [self setData:[NSKeyedArchiver archivedDataWithRootObject:array] forKey:key withTimeoutInterval:timeoutInterval];
}

- (NSArray*)arrayForKey:(NSString*)key {
    NSData* data = [self dataForKey:key];

    if(data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        return nil;
    }
}

@end