//
// Created by Agathe Battestini on 3/20/14.
// Copyright (c) 2014 Storenvy. All rights reserved.
//

#import "UIColor+LiiFUtils.h"


@implementation UIColor (LiiFUtils)

+ (UIColor*)randomColorWithAlpha:(CGFloat)alpha
{
    NSInteger aRedValue = arc4random()%255;
    NSInteger aGreenValue = arc4random()%255;
    NSInteger aBlueValue = arc4random()%255;

    return [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                                                 [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                                                 [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                                                 [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }

    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];

    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor*)randomColor
{
    return [UIColor randomColorWithAlpha:1.0f];
}

#pragma mark - Typography

+ (UIColor*)liifWhite
{
    return [UIColor colorWithHexString:@"fff"];
}


+ (UIColor*)liifGreen
{
    return [UIColor colorWithHexString:@"6ec4a5"];
}

#pragma mark - Data grid

+ (UIColor*)liifBarelyGray
{
    return [UIColor colorWithHexString:@"f6f6f6"];
}

+ (UIColor*)liifSubtleGray
{
    return [UIColor colorWithHexString:@"ddd"];
}



@end