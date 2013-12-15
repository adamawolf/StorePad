//
//  Store.h
//  StorePad
//
//  Created by Adam Wolf on 12/15/13.
//  Copyright (c) 2013 Adam A. Wolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Store : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * addressLine1;
@property (nonatomic, retain) NSString * addressLine3;
@property (nonatomic, retain) NSString * addressLine2;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * fax;

@end
