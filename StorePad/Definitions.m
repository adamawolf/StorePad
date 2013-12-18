//
//  Definitions.m
//  StorePad
//
//  Created by Adam Wolf on 12/15/13.
//  Copyright (c) 2013 Adam A. Wolf. All rights reserved.
//

#import "Definitions.h"

@implementation Definitions

+ (NSString *) contentDataStoreFilename
{
    return @"Content.sqlite";
}

+ (NSString *) storeImageNameFromStoreName: (NSString *) storeName
{
    return [[storeName componentsSeparatedByString:@" "] componentsJoinedByString:@"_"];
}

+ (NSString *) addressStringFromStoreDictionary: (NSDictionary *) storeDictionary
{
    NSMutableArray * lines = [NSMutableArray new];
    
    [lines addObject:storeDictionary[@"addressLine1"]];
    if (storeDictionary[@"addressLine2"]) [lines addObject:storeDictionary[@"addressLine2"]];
    if (storeDictionary[@"addressLine3"]) [lines addObject:storeDictionary[@"addressLine3"]];
    [lines addObject:[NSString stringWithFormat:@"%@, %@", storeDictionary[@"city"], storeDictionary[@"state"]]];
    [lines addObject:storeDictionary[@"zip"]];
    
    return [lines componentsJoinedByString:@"\n"];
}

+ (UIColor *) tintColor
{
    static UIColor * _tintColor = nil;
    if (!_tintColor)
    {
        _tintColor = [UIColor colorWithRed:(20.0f/255.0f) green:(75.0f/255.0f) blue:(15.0f/255.0f) alpha:1.0f];
    }
    
    return _tintColor;
}

+ (UIColor *) navigationBarTitleColor
{
    static UIColor * _navigationBarTitleColor = nil;
    if (!_navigationBarTitleColor)
    {
        _navigationBarTitleColor = [UIColor colorWithRed:(7.0f/255.0f) green:(37.0f/255.0f) blue:(4.0f/255.0f) alpha:1.0f];
    }
    
    return _navigationBarTitleColor;
}

+ (UIColor *) navigationBarBackgroundColor
{
    static UIColor * _navigationBarBackgroundColor = nil;
    if (!_navigationBarBackgroundColor)
    {
        _navigationBarBackgroundColor = [UIColor colorWithRed:(250.0f/255.0f) green:(248.0f/255.0f) blue:(246.0f/255.0f) alpha:1.0f];
    }
    
    return _navigationBarBackgroundColor;
}

+ (UIColor *) viewControllerBackgroundColor
{
    static UIColor * _viewControllerBackgroundColor = nil;
    if (!_viewControllerBackgroundColor)
    {
        _viewControllerBackgroundColor = [UIColor colorWithRed:(243.0f/255.0f) green:(238.0f/255.0f) blue:(230.0f/255.0f) alpha:1.0f];
    }
    
    return _viewControllerBackgroundColor;
}

@end
