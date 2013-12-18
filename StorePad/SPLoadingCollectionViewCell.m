//
//  SPLoadingCollectionViewCell.m
//  StorePad
//
//  Created by Adam Wolf on 12/17/13.
//  Copyright (c) 2013 Adam A. Wolf. All rights reserved.
//

#import "SPLoadingCollectionViewCell.h"

@implementation SPLoadingCollectionViewCell

- (void) prepareForReuse
{
    [[self spinner] stopAnimating];
}

- (void) configureCell
{
    [self setBackgroundColor:[Definitions viewControllerBackgroundColor]];
    [[self spinner] startAnimating];
}

@end
