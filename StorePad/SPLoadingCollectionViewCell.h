//
//  SPLoadingCollectionViewCell.h
//  StorePad
//
//  Created by Adam Wolf on 12/17/13.
//  Copyright (c) 2013 Adam A. Wolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPLoadingCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView * spinner;

- (void) configureCell;

@end
