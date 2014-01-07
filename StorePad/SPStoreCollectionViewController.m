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
#import "SPWebsiteCollectionViewCell.h"
#import "SPLoadingCollectionViewCell.h"
#import <MapKit/MapKit.h>

static NSString * LoadingCellIdentifier = @"SPLoadingCollectionViewCell";
static NSString * StoreCellIdentifier = @"SPStoreCollectionViewCell";
static NSString * WebsiteCellIdentifier = @"SPWebsiteCollectionViewCell";

@interface SPStoreCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SPCoreDataControllerStoreLoadingDelegate, SPStoreCollectionViewCellDelegate, SPWebsiteCollectionViewCellDelegate>

@property (nonatomic, strong) NSArray * stores;

@end

@implementation SPStoreCollectionViewController

- (void) viewDidLoad
{
    [[self collectionView] setBackgroundColor:[Definitions viewControllerBackgroundColor]];
    
    [[SPCoreDataController sharedController] fetchAllStoreDictionariesInBackgroundWithDelegate:self];
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self stores] != nil ? [[self stores] count] + 1 : 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = nil;
    
    BOOL dataLoaded = [self stores] != nil;
    
    if (dataLoaded)
    {
        if ([indexPath row] < [[self stores] count])
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:StoreCellIdentifier forIndexPath:indexPath];
        }
        else
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:WebsiteCellIdentifier forIndexPath:indexPath];
        }
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
        [storeCell setDelegate:self];
    }
    else if ([cell isKindOfClass:[SPWebsiteCollectionViewCell class]])
    {
        NSDictionary * websiteDictionary = @{
                                             @"name": @"Website",
                                             @"url": @"http://www.booksinc.net"
                                             };
        
        SPWebsiteCollectionViewCell * websiteCell = (SPWebsiteCollectionViewCell *)cell;
        [websiteCell setWebsiteDictionary:websiteDictionary];
        [websiteCell setDelegate:self];
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

#pragma mark - SPStoreCollectionViewCellDelegate methods

- (void) storeCollectionViewCellDidTapCallButton: (SPStoreCollectionViewCell *) storeCell
{
    NSDictionary * storeDictionary = [storeCell storeDictionary];
    
    NSString *phoneNumber = [@"tel://" stringByAppendingString:storeDictionary[@"phoneNumber"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void) storeCollectionViewCellDidTapMapButton: (SPStoreCollectionViewCell *) storeCell
{
    NSDictionary * storeDictionary = [storeCell storeDictionary];
    NSString * addressString = [Definitions addressStringFromStoreDictionary:storeDictionary];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:addressString
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     
                     // Convert the CLPlacemark to an MKPlacemark
                     // Note: There's no error checking for a failed geocode
                     CLPlacemark *geocodedPlacemark = [placemarks objectAtIndex:0];
                     MKPlacemark *placemark = [[MKPlacemark alloc]
                                               initWithCoordinate:geocodedPlacemark.location.coordinate
                                               addressDictionary:geocodedPlacemark.addressDictionary];
                     
                     // Create a map item for the geocoded address to pass to Maps app
                     MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                     [mapItem setName:geocodedPlacemark.name];
                     
                     // Set the directions mode to "Driving"
                     // Can use MKLaunchOptionsDirectionsModeWalking instead
                     NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
                     
                     // Get the "Current User Location" MKMapItem
                     MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
                     
                     // Pass the current location and destination map items to the Maps app
                     // Set the direction mode in the launchOptions dictionary
                     [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
                     
                 }];
}

#pragma mark - SPWebsiteCollectionViewCellDelegate methods

- (void) websiteCollectionViewCellDidTapGoButton: (SPWebsiteCollectionViewCell *) websiteCell
{
    NSDictionary * websiteDictionary = [websiteCell websiteDictionary];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:websiteDictionary[@"url"]]];
}

@end
