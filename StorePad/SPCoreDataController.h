//
//  SPCoreDataController.h
//  StorePad
//
//  Created by Adam Wolf on 12/15/13.
//  Copyright (c) 2013 Adam A. Wolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SPCoreDataController : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (SPCoreDataController *) sharedController;
+ (NSString *) applicationDocumentsDirectory;

- (void) saveContext: (NSManagedObjectContext *) context;
- (void) saveDataInContext:(void(^)(NSManagedObjectContext *context))saveBlock;
- (void) saveDataInBackgroundWithContext:(void(^)(NSManagedObjectContext *context))saveBlock completion:(void(^)(void))completion;

#ifdef CONTENTGEN
- (void) generateContent;
#endif

- (void) createEditableCopyOfContentDatabaseIfNeeded;

- (NSArray *) fetchAllStoreDictionaries;

@end
