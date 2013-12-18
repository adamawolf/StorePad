//
//  SPStoreCollectionViewController.m
//  StorePad
//
//  Created by Adam Wolf on 12/17/13.
//  Copyright (c) 2013 Adam A. Wolf. All rights reserved.
//

#import "SPStoreCollectionViewController.h"
#import "SPCoreDataController.h"
#import "SPStoreCollectionViewCell.h"
#import "SPLoadingCollectionViewCell.h"

static NSString * LoadingCellIdentifier = @"SPLoadingCollectionViewCell";
static NSString * StoreCellIdentifier = @"SPStoreCollectionViewCell";

@interface SPStoreCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SPCoreDataControllerStoreLoadingDelegate>

@property (nonatomic, strong) NSArray * stores;

@end

@implementation SPStoreCollectionViewController

- (void) viewDidLoad
{
    [[self collectionView] setBackgroundColor:[Definitions viewControllerBackgroundColor]];
    
    [[SPCoreDataController sharedController] fetchAllStoreDictionariesInBackgroundWithDelegate:self];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self stores] != nil ? [[self stores] count] : 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = nil;
    
    BOOL dataLoaded = [self stores] != nil;
    
    if (dataLoaded)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:StoreCellIdentifier forIndexPath:indexPath];
    }
    else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:LoadingCellIdentifier forIndexPath:indexPath];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void) configureCell: (UICollectionViewCell *) cell atIndexPath: (NSIndexPath *) indexPath
{
    if ([cell isKindOfClass:[SPStoreCollectionViewCell class]])
    {
        NSDictionary * storeDictionary = [self stores][indexPath.row];
        
        SPStoreCollectionViewCell * storeCell = (SPStoreCollectionViewCell *)cell;
        [storeCell setStoreDictionary:storeDictionary];
    }
    else if ([cell isKindOfClass:[SPLoadingCollectionViewCell class]])
    {
        SPLoadingCollectionViewCell * loadingCell = (SPLoadingCollectionViewCell *)cell;
        [loadingCell configureCell];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL dataLoaded = [self stores] != nil;
    
    CGSize size;
    
    if (dataLoaded)
    {
        size = CGSizeMake(145.0f, 145.0f);
    }
    else
    {
        size = CGSizeMake(self.view.frame.size.width - 20.0f, self.view.frame.size.height - (64.0f + 20.0f));
    }
    
    return size;
}

#pragma mark - SPCoreDataControllerStoreLoadingDelegate methods

- (void) coreDataController: (SPCoreDataController *) coreDataController didLoadAllStoreDictionaries: (NSArray *) storeDictionaries
{
    [self setStores:storeDictionaries];
    [[self collectionView] reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

@end
