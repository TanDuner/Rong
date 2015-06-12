//
//  LeShowButton.h
//  图标
//
//  Created by xusc on 13-10-30.
//  Copyright (c) 2013年 xusc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LeShowButtonItem.h"
//#import "UIImage+Addition.h"
//#import <TBUI/TBImageViewDelegate.h>
typedef enum{
   LeShowBtnModeCenterTitle = 0,
   LeshowBtnModeBottomTitle,
   LeShowbtnModeOverBounceTitle,
}LeShowBtnMode;



@protocol leShowButtonDelegete;
@interface LeShowButton : UIView
{
    UIImage *backImage;
    NSString *titleText;
    BOOL isEditing;
    UIButton *deleteButton;
    UIButton *button;
    NSInteger index;
    CGPoint point;
    UILongPressGestureRecognizer *longPress;
}
@property(nonatomic) BOOL isEditing;
@property(nonatomic) NSInteger index;
@property (nonatomic,retain) NSString *indexStr;
@property(nonatomic,assign) id<leShowButtonDelegete>delegate;
@property(nonatomic,assign) BOOL isCanEdit;
@property (nonatomic) LeShowBtnMode titleStyle;
@property (nonatomic,retain) LeShowButtonItem *item;
@property (nonatomic,retain) UIImageView *topImageView;
@property (nonatomic,retain) UIImageView *bottomImageView;


- (void) enableEditing;
- (void) disableEditing;
- (id) initWithItem:(LeShowButtonItem *)item andFrame:(CGRect)frame titleStyle:(LeShowBtnMode)myTitleStyle andDelegate:(id)delegate;
@end

@protocol leShowButtonDelegete <NSObject>
@optional
- (void) leShowButtonDidClicked:(LeShowButton *) leShowButton;
- (void) leShowButtonDidEnterEditingMode:(LeShowButton *) leShowButton;
- (void) leShowButtonDidDeleted:(LeShowButton *) leShowButton atIndex:(NSInteger)index;
- (void) leShowButtonDidMoved:(LeShowButton *) leShowButton withLocation:(CGPoint)point moveGestureRecognizer:(UILongPressGestureRecognizer*)recognizer;
- (void) leShowButtonDidEndMoved:(LeShowButton *) leShowButton withLocation:(CGPoint)point moveGestureRecognizer:(UILongPressGestureRecognizer*) recognizer;

-(void)leshowButtonDidLoadImage:(LeShowButton*)button;
@end
