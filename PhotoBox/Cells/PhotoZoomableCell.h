//
//  PhotoZoomableCell.h
//  PhotoBox
//
//  Created by Nico Prananta on 9/1/13.
//  Copyright (c) 2013 Touches. All rights reserved.
//

#import "PhotoCell.h"

@protocol PhotoZoomableCellDelegate <NSObject>

- (void)didClosePhotosHorizontalViewController;
- (void)didCancelClosingPhotosHorizontalViewController;
- (void)didDragDownWithPercentage:(float)progress;
- (void)willStartClosingPhotosHorizontalViewController;


@end

@interface PhotoZoomableCell : PhotoCell <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *thisImageview;
@property (nonatomic, weak) id<PhotoZoomableCellDelegate> delegate;

- (void)loadOriginalImage;
- (BOOL)hasDownloadedOriginalImage;
- (BOOL)isDownloadingOriginalImage;
- (UIImage *)originalImage;

@end
