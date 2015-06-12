//
//  RootViewController.h
//  图标
//
//  Created by xusc on 13-10-30.
//  Copyright (c) 2013年 xusc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeShowButton.h"
@interface RootViewController : UIViewController<leShowButtonDelegete,UIGestureRecognizerDelegate>
{
    UIScrollView *backScrollView;
    
    NSInteger numInRow;
    
    NSInteger Space;
    
    NSInteger topSpace;
    
    CGSize size;
    
    NSInteger totalNum;
    
    NSInteger centerSpaceX;
    
    NSInteger centerSpaceY;
    
    LeShowBtnMode titleStyle;
    
 
    
}
-(void)setViewLayOutParamsWithNumInRow:(NSInteger)myNumInRow leftSpace:(NSInteger)mySpace Size:(CGSize)mySize;

@property (nonatomic,assign) BOOL isEditing;
@property (nonatomic,retain) NSMutableArray *itemArray;
@property (nonatomic,retain) NSMutableArray *btnArray;
@property (nonatomic,retain) UITapGestureRecognizer *singletap;
@property (nonatomic,assign) BOOL isCanEdit;
@end
