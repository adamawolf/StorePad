//
//  SPWebsiteCollectionViewCell.m
//  StorePad
//
//  Created by Adam Wolf on 1/6/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//

#import "SPWebsiteCollectionViewCell.h"

@implementation SPWebsiteCollectionViewCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}

- (void) setWebsiteDictionary:(NSDictionary *)websiteDictionary
{
    _websiteDictionary = websiteDictionary;
    
    NSString * imageName = [Definitions storeImageNameFromStoreName:websiteDictionary[@"name"]];
    [[self websiteImageView] setImage:[UIImage imageNamed:imageName]];
    
    [[self opacityOverlayView] setAlpha:0.6f];
    
    [[self nameLabel] setPreferredMaxLayoutWidth:self.frame.size.width - 20.0f];
    [[self nameLabel] setTextColor:[Definitions navigationBarTitleColor]];
    [[self nameLabel] setText:websiteDictionary[@"name"]];
    [[self nameLabel] sizeToFit];
    
    [self layer].cornerRadius = 20.0f;
}

#pragma mark - Action methods

- (IBAction) goButtonTapped: (id) sender
{
    [[self delegate] websiteCollectionViewCellDidTapGoButton:self];
}

@end