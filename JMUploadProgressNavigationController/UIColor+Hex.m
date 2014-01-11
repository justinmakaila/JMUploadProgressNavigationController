//
//  UIColor+Hex.m
//
//  Created by Dan Scanlon on 8/26/13.
//  Copyright (c) 2013 Dan Scanlon All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor*)colorWithHexString:(NSString *)hex {
    NSString *colorString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // If string is 3 characters, double it
    if([colorString length] == 3) colorString = [colorString stringByAppendingString:colorString];
    // Strip 0X prefix if it appears
    if([colorString hasPrefix:@"0X"]) colorString = [colorString substringFromIndex:2];
    // String should be 6 or 8 characters
    if([colorString length] < 6) return [UIColor grayColor];
    
    // Separate into r,g,b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *redString = [colorString substringWithRange:range];
    
    range.location = 2;
    NSString *greenString = [colorString substringWithRange:range];
    
    range.location = 4;
    NSString *blueString = [colorString substringWithRange:range];
    
    // Scan values
    unsigned int red, green, blue;
    [[NSScanner scannerWithString:redString] scanHexInt:&red];
    [[NSScanner scannerWithString:greenString] scanHexInt:&green];
    [[NSScanner scannerWithString:blueString] scanHexInt:&blue];
    
    // Return UIColor
    return [UIColor colorWithRed:((float) red / 255.0f)
                           green:((float) green / 255.0f)
                            blue:((float) blue / 255.0f)
                           alpha:1.0f];
}

@end
