//
//  SPStoreCollectionViewCell.m
//  StorePad
//
//  Created by Adam Wolf on 12/17/13.
//  Copyright (c) 2013 Adam A. Wolf. All rights reserved.
//

#import "SPStoreCollectionViewCell.h"

@implementation SPStoreCollectionViewCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}

- (void) setStoreDictionary:(NSDictionary *)storeDictionary
{
    _storeDictionary = storeDictionary;
    
    DLog(@"todo: process store dict %@", [self storeDictionary]);
    
    NSString * imageName = [Definitions storeImageNameFromStoreName:storeDictionary[@"name"]];
    [[self storeImageView] setImage:[UIImage imageNamed:imageName]];
    
    [[self opacityOverlayView] setAlpha:0.6f];
    //[[self opacityOverlayView] setBackgroundColor:[Definitions navigationBarBackgroundColor]];
    
    [[self nameLabel] setPreferredMaxLayoutWidth:self.frame.size.width - 20.0f];
    [[self nameLabel] setTextColor:[Definitions navigationBarTitleColor]];
    [[self nameLabel] setText:storeDictionary[@"name"]];
    [[self nameLabel] sizeToFit];
    
    [self layer].cornerRadius = 20.0f;
}

#pragma mark - Action methods

- (IBAction) callButtonTapped: (id) sender
{
    [[self delegate] storeCollectionViewCellDidTapCallButton:self];
}

- (IBAction) mapButtonTapped: (id) sender
{
    [[self delegate] storeCollectionViewCellDidTapMapButton:self];
}

@end
