//
// Created by Agathe Battestini on 3/20/14.
// Copyright (c) 2014 Storenvy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (LiiFUtils)

+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)randomColor;

+ (UIColor *)liifWhite;

+ (UIColor *)liifGreen;

+ (UIColor *)liifDarkText;

+ (UIColor *)liifActiveIcon;

+ (UIColor *)liifInactiveIcon;

+ (UIColor *)liifBarelyGray;

+ (UIColor *)liifSubtleGray;
@end