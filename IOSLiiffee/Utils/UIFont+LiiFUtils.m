//
// Created by Agathe Battestini on 3/20/14.
// Copyright (c) 2014 Storenvy. All rights reserved.
//

#import "UIFont+LiiFUtils.h"


@implementation UIFont (LiiFUtils)

+ (UIFont*)liifDefaultFontWithSize:(CGFloat )size
{
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

+ (NSDictionary *)liifStringAttributesWithSize:(CGFloat)size withColor:(UIColor*)color
{
    return @{ NSFontAttributeName : [UIFont liifDefaultFontWithSize:size],
//            NSUnderlineStyleAttributeName : @1 ,
            NSForegroundColorAttributeName : color
    };
}

+ (NSDictionary *)liifParagraphStyleForLineBreakStyle:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    return [NSDictionary dictionaryWithDictionary:paragraphStyle];
}



@end