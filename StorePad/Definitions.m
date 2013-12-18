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

+ (UIColor *) viewControllerBackgroundColor
{
    static UIColor * _viewControllerBackgroundColor = nil;
    if (!_viewControllerBackgroundColor)
    {
        _viewControllerBackgroundColor = [UIColor colorWithWhite:0.88 alpha:1.0f];
    }
    
    return _viewControllerBackgroundColor;
}

@end
