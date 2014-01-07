//
//  Definitions.h
//  StorePad
//
//  Created by Adam Wolf on 12/15/13.
//  Copyright (c) 2013 Adam A. Wolf. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SPUserDefaults_LastLaunchVersion    @"SPUserDefaults_LastLaunchVersion"

@interface Definitions : NSObject

+ (NSString *) contentDataStoreFilename;
+ (NSString *) storeImageNameFromStoreName: (NSString *) storeName;
+ (NSString *) addressStringFromStoreDictionary: (NSDictionary *) storeDictionary;

+ (UIColor *) tintColor;
+ (UIColor *) navigationBarTitleColor;
+ (UIColor *) navigationBarBackgroundColor;
+ (UIColor *) viewControllerBackgroundColor;

@end
