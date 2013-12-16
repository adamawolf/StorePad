//
//  SPCoreDataController.m
//  StorePad
//
//  Created by Adam Wolf on 12/15/13.
//  Copyright (c) 2013 Adam A. Wolf. All rights reserved.
//

//
//  CoreDataController.m
//  TapTypingChallenge
//
//  Created by Adam Wolf on 5/31/11.
//  Copyright 2012 Flairify LLC. All rights reserved.
//

#import "SPCoreDataController.h"
#import "Store.h"

static SPCoreDataController * _sharedController = nil;

static dispatch_queue_t coredata_background_save_queue;

static dispatch_queue_t background_save_queue()
{
    if (coredata_background_save_queue == NULL)
    {
        coredata_background_save_queue = dispatch_queue_create("com.flairify.tttccoredataqueue", 0);
    }
    return coredata_background_save_queue;
}

@implementation SPCoreDataController

- (id) init
{
	self = [super init];
	if (self != nil)
	{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextSaved:) name:NSManagedObjectContextDidSaveNotification object:nil];
	}
	return self;
}

+ (SPCoreDataController *) sharedController
{
	if (_sharedController == nil)
    {
		_sharedController = [[SPCoreDataController alloc] init];
	}
	return _sharedController;
}


- (void) managedObjectContextSaved: (NSNotification *)notification
{
    if (_managedObjectContext)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self managedObjectContext] mergeChangesFromContextDidSaveNotification:notification];
        });
    }
}

- (void)saveDataInContext:(void(^)(NSManagedObjectContext *context))saveBlock
{
    NSManagedObjectContext * context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context performBlockAndWait:^{
        [context setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    }];
    
	[context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    if (_managedObjectContext)
    {
        [[self managedObjectContext] setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(managedObjectContextSaved:)
												 name:NSManagedObjectContextDidSaveNotification
											   object:context];
    
	saveBlock(context);
    
	if ([context hasChanges])
	{
        [self saveContext:context];
	}
}

- (void)saveDataInBackgroundWithContext:(void(^)(NSManagedObjectContext *context))saveBlock completion:(void(^)(void))completion
{
	dispatch_async(background_save_queue(), ^{
		[self saveDataInContext:saveBlock];
        
		dispatch_async(dispatch_get_main_queue(), ^{
			completion();
		});
	});
}

#pragma General Utility methods

- (void) saveContext: (NSManagedObjectContext *) context
{
    NSError *error = nil;
    if (context != nil) {
        if ([context hasChanges] && ![context save:&error])
        {
            NSException * exception = [[NSException alloc] initWithName:@"TTTCCoreDataError" reason:[NSString stringWithFormat:@"Error saving MOC: '%@', user info: '%@'", error, [error userInfo]] userInfo:[error userInfo]];
            [exception raise];
        }
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"StorePad" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    //
    //add the read only sqlite data file which contains the staticly generated server side content
    //

    //during normal app usage by the end user, read the content data directly from its read-only Resource bundle path
    //  this means that
    //      1) the Content.sqlite file is not copied to device's Documents directory (where it would needlessly be backed up by iCloud)
    //      2) the launch times are not hindered by initially copying sqlite file

    NSString * storeURLString = [[SPCoreDataController applicationDocumentsDirectory] stringByAppendingPathComponent:[Definitions contentDataStoreFilename]];
    NSDictionary * pscOptions = @{
                                  NSMigratePersistentStoresAutomaticallyOption: @YES,
                                  NSInferMappingModelAutomaticallyOption: @YES
                                  };

    NSURL * storeURL = [NSURL fileURLWithPath:storeURLString];
    
    NSError * error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:@"Content" URL:storeURL options:pscOptions error:&error])
    {
        NSException * coreDataException = [[NSException alloc] initWithName:@"TTTCCoreDataError" reason:[NSString stringWithFormat:@"Could not add persistent store to coordinator: %@", [error localizedDescription]] userInfo:nil];
        [coreDataException raise];
    }
    else
    {
        DLog(@"Added content core data store: %@", storeURLString);
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Generic Helper methods

- (void) createEditableCopyOfContentDatabaseIfNeeded
{
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError * error = nil;
    
	NSString * writableDocumentsPath = [[SPCoreDataController applicationDocumentsDirectory] stringByAppendingPathComponent:[Definitions contentDataStoreFilename]];
    
    //always overwrite existing content database with version from resources
	
	BOOL exists = [fileManager fileExistsAtPath:writableDocumentsPath];
    if (!exists)
    {
        NSString * readOnlyResourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[Definitions contentDataStoreFilename]];
        success = [fileManager copyItemAtPath:readOnlyResourcePath toPath:writableDocumentsPath error:&error];
        if (!success)
        {
            DLog(@"ERROR: Failed to create writable %@ file with message '%@'.", [Definitions contentDataStoreFilename], [error localizedDescription]);
        }
        
        DLog(@"%@ initially copied to app Documents directory.", [Definitions contentDataStoreFilename]);
    }
}

+ (NSString *) applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark - Public methods

//#ifdef CONTENTGEN
- (void) generateContent
{
    [self deleteAllObjectsForEntity:@"Store"];
    
    NSArray * keys = @[@"name", @"addressLine1", @"addressLine2", @"addressLine3", @"city", @"zip", @"state", @"phoneNumber", @"fax"];

//    @{
//      @"name" : @"Alameda",
//      @"addressLine1": @"1344 Park Street",
//      @"addressLine2": @"",
//      @"addressLine3": @"",
//      @"city": @"Alameda",
//      @"zip": @"94501",
//      @"state": @"CA",
//      @"phoneNumber": @"510-522-222",
//      @"fax": @"510-522-8880"
//    }
    
    NSArray * stores = @[
                         @{
                             @"name" : @"Alameda",
                             @"addressLine1": @"1344 Park Street",
                             @"city": @"Alameda",
                             @"zip": @"94501",
                             @"state": @"CA",
                             @"phoneNumber": @"510-522-222",
                             @"fax": @"510-522-8880"
                             },
                         @{
                             @"name" : @"Berkeley",
                             @"addressLine1": @"1760 Fourth Street",
                             @"city": @"Berkeley",
                             @"zip": @"94710",
                             @"state": @"CA",
                             @"phoneNumber": @"510-525-7777",
                             },
                         @{
                             @"name" : @"Burlingame",
                             @"addressLine1": @"1375 Burlingame Avenue",
                             @"city": @"Burlingame",
                             @"zip": @"94010",
                             @"state": @"CA",
                             @"phoneNumber": @"650-685-4911",
                             @"fax": @"650-685-4914"
                             },
                         @{
                             @"name" : @"Castro",
                             @"addressLine1": @"2275 Market Street",
                             @"city": @"San Francisco",
                             @"zip": @"94103",
                             @"state": @"CA",
                             @"phoneNumber": @"415-864-6777",
                             },
                         @{
                             @"name" : @"Laurel Village",
                             @"addressLine1": @"515 California Street",
                             @"city": @"San Francisco",
                             @"zip": @"94118",
                             @"state": @"CA",
                             @"phoneNumber": @"415-221-3666",
                             },
                         @{
                             @"name" : @"Marina",
                             @"addressLine1": @"2251 Chestnut Street",
                             @"city": @"San Francisco",
                             @"zip": @"94123",
                             @"state": @"CA",
                             @"phoneNumber": @"415-931-3633",
                             },
                         @{
                             @"name" : @"Mountain View",
                             @"addressLine1": @"301 Castro Street",
                             @"city": @"Mountain View",
                             @"zip": @"94041",
                             @"state": @"CA",
                             @"phoneNumber": @"650-428-1234",
                             @"fax": @"650-428-1247"
                             },
                         @{
                             @"name" : @"Opera Plaza",
                             @"addressLine1": @"601 Van Ness",
                             @"city": @"San Francisco",
                             @"zip": @"94102",
                             @"state": @"CA",
                             @"phoneNumber": @"415-776-1111",
                             },
                         @{
                             @"name" : @"Palo Alto",
                             @"addressLine1": @"855 El Camino Real #74",
                             @"city": @"Palo Alto",
                             @"zip": @"94301",
                             @"state": @"CA",
                             @"phoneNumber": @"650-321-0600",
                             @"fax": @"650-321-6069"
                             },
                         @{
                             @"name" : @"Terminal 2",
                             @"addressLine1": @"Terminal 2",
                             @"addressLine2": @"San Francisco International Airport",
                             @"city": @"San Francisco",
                             @"zip": @"94128",
                             @"state": @"CA",
                             @"phoneNumber": @"650-821-9299",
                             },
                         @{
                             @"name" : @"Terminal 3",
                             @"addressLine1": @"Terminal 3",
                             @"addressLine2": @"San Francisco International Airport",
                             @"city": @"San Francisco",
                             @"zip": @"94128",
                             @"state": @"CA",
                             @"phoneNumber": @"650-244-0610",
                             @"fax": @"650-244-0620",
                             },
                         ];
    
    [stores enumerateObjectsUsingBlock:^(NSDictionary * currentStoreDict, NSUInteger index, BOOL * stop) {
        Store * store = [NSEntityDescription insertNewObjectForEntityForName:@"Store" inManagedObjectContext:[self managedObjectContext]];
        
        [keys enumerateObjectsUsingBlock:^(NSString * currentKey, NSUInteger index, BOOL * s) {
            if ([currentStoreDict objectForKey:currentKey])
            {
                [store setValue:currentStoreDict[currentKey] forKey:currentKey];
            }
        }];
    }];
    
    [self saveContext:[self managedObjectContext]];
}

- (void) deleteAllObjectsForEntity: (NSString *) entityString
{
	NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription * entity = [NSEntityDescription entityForName:entityString inManagedObjectContext:[self managedObjectContext]];
	if (!entity)
	{
		DLog(@"ERROR: Invalid entity %@ specified.", entityString);
		return;
	}
	[fetchRequest setEntity:entity];
	
	NSError * error;
	NSMutableArray * allElements = [[[self managedObjectContext] executeFetchRequest:fetchRequest error:&error] mutableCopy];
	if (!allElements)
	{
		DLog(@"Loading %@ to delete: unresolved error %@, %@", entityString, error, [error userInfo]);
		abort();
	}
	
	for (NSManagedObject * object in allElements)
	{
		[[self managedObjectContext] deleteObject:object];
	}
	
	if (![[self managedObjectContext] save:&error])
	{
		DLog(@"Failed to delete from data store: %@", [error localizedDescription]);
		NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
		if(detailedErrors != nil && [detailedErrors count] > 0)
		{
			for(NSError* detailedError in detailedErrors) {
				DLog(@"  DetailedError: %@", [detailedError userInfo]);
			}
		}
		else
		{
			DLog(@"  %@", [error userInfo]);
		}
	}
}
//#endif

- (NSArray *) fetchAllStoreDictionaries
{
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Store" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    
    [request setResultType:NSDictionaryResultType];
    [request setPropertiesToFetch:@[@"name", @"addressLine1", @"addressLine2", @"addressLine3", @"city", @"zip", @"state", @"phoneNumber", @"fax"]];
    
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    
    NSError * error = nil;
    NSArray * results = [[self managedObjectContext] executeFetchRequest:request error:&error];
    
    return results;
}

@end
