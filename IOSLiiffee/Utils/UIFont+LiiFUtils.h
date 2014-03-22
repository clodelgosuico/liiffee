//
// Created by Agathe Battestini on 3/20/14.
// Copyright (c) 2014 Storenvy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIFont (LiiFUtils)

+ (UIFont *)liifDefaultFontWithSize:(CGFloat)size;

+ (NSDictionary *)liifStringAttributesWithSize:(CGFloat)size withColor:(UIColor *)color;

+ (NSDictionary *)liifParagraphStyleForLineBreakStyle:(NSLineBreakMode)lineBreakMode;

@end