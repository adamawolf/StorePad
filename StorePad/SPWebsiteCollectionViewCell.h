//
//  SPWebsiteCollectionViewCell.h
//  StorePad
//
//  Created by Adam Wolf on 1/6/14.
//  Copyright (c) 2014 Adam A. Wolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPWebsiteCollectionViewCell;

@protocol SPWebsiteCollectionViewCellDelegate <NSObject>

- (void) websiteCollectionViewCellDidTapGoButton: (SPWebsiteCollectionViewCell *) websiteCell;

@end

@interface SPWebsiteCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<SPWebsiteCollectionViewCellDelegate> delegate;

@property (nonatomic, strong) NSDictionary * websiteDictionary;

@property (nonatomic, strong) IBOutlet UIImageView * websiteImageView;
@property (nonatomic, strong) IBOutlet UIView * opacityOverlayView;
@property (nonatomic, strong) IBOutlet UILabel * nameLabel;

- (IBAction) goButtonTapped: (id) sender;

@end
