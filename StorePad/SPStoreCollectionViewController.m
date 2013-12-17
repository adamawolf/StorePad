//
//  SPStoreCollectionViewController.m
//  StorePad
//
//  Created by Adam Wolf on 12/17/13.
//  Copyright (c) 2013 Adam A. Wolf. All rights reserved.
//

#import "SPStoreCollectionViewController.h"

static NSString * StoreCellIdentifier = @"SPStoreCollectionViewCell";

@interface SPStoreCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation SPStoreCollectionViewController

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
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

@end
