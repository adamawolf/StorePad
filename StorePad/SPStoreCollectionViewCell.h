//
//  SPStoreCollectionViewCell.h
//  StorePad
//
//  Created by Adam Wolf on 12/17/13.
//  Copyright (c) 2013 Adam A. Wolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPStoreCollectionViewCell;

@protocol SPStoreCollectionViewCellDelegate <NSObject>

- (void) storeCollectionViewCellDidTapCallButton: (SPStoreCollectionViewCell *) storeCell;
- (void) storeCollectionViewCellDidTapMapButton: (SPStoreCollectionViewCell *) storeCell;

@end

@interface SPStoreCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<SPStoreCollectionViewCellDelegate> delegate;

@property (nonatomic, strong) NSDictionary * storeDictionary;

@property (nonatomic, strong) IBOutlet UIImageView * storeImageView;
@property (nonatomic, strong) IBOutlet UIView * opacityOverlayView;
@property (nonatomic, strong) IBOutlet UILabel * nameLabel;

- (IBAction) callButtonTapped: (id) sender;
- (IBAction) mapButtonTapped: (id) sender;

@end
