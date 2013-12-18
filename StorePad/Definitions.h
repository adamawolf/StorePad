//
//  Definitions.h
//  StorePad
//
//  Created by Adam Wolf on 12/15/13.
//  Copyright (c) 2013 Adam A. Wolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Definitions : NSObject

+ (NSString *) contentDataStoreFilename;
+ (NSString *) storeImageNameFromStoreName: (NSString *) storeName;

@end
