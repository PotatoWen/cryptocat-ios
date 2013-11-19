//
//  TBComposingCell.m
//  Cryptocat
//
//  Created by Thomas Balthazar on 19/11/13.
//  Copyright (c) 2013 Thomas Balthazar. All rights reserved.
//

#import "TBComposingCell.h"
#import "TBComposingCellView.h"

#define kPaddingTop     0.0
#define kPaddingBottom  10.0
#define kPaddingLeft    11.0
#define kPaddingRight   12.5

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TBComposingCell ()

@property (nonatomic, strong) TBComposingCellView *composingView;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TBComposingCell

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    _composingView = [[TBComposingCellView alloc] init];
    [self.contentView addSubview:_composingView];
  }
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGRect composingViewFrame = self.contentView.frame;
  composingViewFrame.origin.x+=kPaddingLeft;
  composingViewFrame.origin.y+=kPaddingTop;
  composingViewFrame.size.width-=(kPaddingLeft+kPaddingRight);
  composingViewFrame.size.height-=(kPaddingTop+kPaddingBottom);
  self.composingView.frame = composingViewFrame;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public Methods

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSenderName:(NSString *)senderName {
  self.composingView.senderName = senderName;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)senderName {
  return self.composingView.senderName;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setMeSpeaking:(BOOL)meSpeaking {
  self.composingView.meSpeaking = meSpeaking;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isMeSpeaking {
  return self.composingView.isMeSpeaking;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBackgroundColor:(UIColor *)backgroundColor {
  [super setBackgroundColor:backgroundColor];
  self.composingView.backgroundColor = backgroundColor;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)height {
  return 51.5;
}

@end
