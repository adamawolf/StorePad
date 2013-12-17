//
//  SPStoreCollectionViewController.m
//  StorePad
//
//  Created by Adam Wolf on 12/17/13.
//  Copyright (c) 2013 Adam A. Wolf. All rights reserved.
//

#import "SPStoreCollectionViewController.h"
#import "SPCoreDataController.h"

static NSString * StoreCellIdentifier = @"SPStoreCollectionViewCell";

@interface SPStoreCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SPCoreDataControllerStoreLoadingDelegate>

@property (nonatomic, strong) NSArray * stores;

@end

@implementation SPStoreCollectionViewController

- (void) viewDidLoad
{
    [[SPCoreDataController sharedController] fetchAllStoreDictionariesInBackgroundWithDelegate:self];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self stores] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = nil;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:StoreCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(160.0f, 160.0f);
}

#pragma mark - SPCoreDataControllerStoreLoadingDelegate methods

- (void) coreDataController: (SPCoreDataController *) coreDataController didLoadAllStoreDictionaries: (NSArray *) storeDictionaries
{
    [self setStores:storeDictionaries];
    [[self collectionView] reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

@end
