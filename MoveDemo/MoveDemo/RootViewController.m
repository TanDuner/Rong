//
//  RootViewController.m
//  图标
//
//  Created by xusc on 13-10-30.
//  Copyright (c) 2013年 xusc. All rights reserved.
//

#import "RootViewController.h"
#import "LeShowButton.h"
#import "LeShowButtonItem.h"
//#define columns 1000
//#define rows 10000
//#define space 20
//#define gridHight 50
//#define gridWith 50
//#define unValidIndex  -1
//#define numInRow 4


#define kScreenWidth [[UIScreen mainScreen]bounds].size.width
#define kScreenHeight [[UIScreen mainScreen]bounds].size.height
#define kStatusBarHeight 20
#define kNavigationBarHeight 44
#define kTabBarHeight 40
#define kTopPadding 30

@interface RootViewController ()

@end

@implementation RootViewController
@synthesize itemArray;
@synthesize singletap;
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}



- (void)viewDidLoad
{

    

    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, kScreenHeight-kNavigationBarHeight-kStatusBarHeight )];
    backScrollView.backgroundColor = [UIColor clearColor];
    backScrollView.showsVerticalScrollIndicator = NO;
    
    self.isEditing = NO;
    self.itemArray = [NSMutableArray arrayWithCapacity:10];
    self.isCanEdit = YES;
    titleStyle = LeShowBtnModeCenterTitle;
    
    [self.view addSubview:backScrollView];
  
    singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singletap setNumberOfTapsRequired:1];
    singletap.delegate = self;
    [backScrollView addGestureRecognizer:singletap];
    centerSpaceY = 20;
    topSpace  = 0;
    
    
}

-(void)setViewLayOutParamsWithNumInRow:(NSInteger)myNumInRow leftSpace:(NSInteger)mySpace Size:(CGSize)mySize
{
    
    int width1 = 320 - mySpace *2;
    int totalCenterSpace = width1-myNumInRow *mySize.width;
    centerSpaceX = totalCenterSpace/(myNumInRow-1);
    
    self.btnArray = [NSMutableArray arrayWithCapacity:10];
    numInRow = myNumInRow;
    Space = mySpace;
    totalNum = self.itemArray.count;
    size = mySize;

    for (int i = 0; i<[self.itemArray count]; i++) {
        LeShowButtonItem *item = [self.itemArray objectAtIndex:i];
        CGRect rect ;
        if (topSpace >0) {
            rect = CGRectMake(Space+((size.width+centerSpaceX) * (i%numInRow)), topSpace+(i/numInRow)*(centerSpaceY+size.height), size.width, size.height);
        }
        else
        {
           rect = CGRectMake(Space+((size.width+centerSpaceX) * (i%numInRow)), Space+(i/numInRow)*(centerSpaceY+size.height), size.width, size.height);
        }
        LeShowButton *btn = [[LeShowButton alloc] initWithItem:item andFrame:rect titleStyle:titleStyle andDelegate:self];

        btn.isCanEdit = self.isCanEdit;
        btn.index = item.index;
        [backScrollView addSubview:btn];
        [self.btnArray addObject:btn];
        [btn release];
    }
    float rowNum = ceilf((float)totalNum/(float)numInRow);
    backScrollView.contentSize = CGSizeMake(320, rowNum*(size.height+centerSpaceY)+Space+60);
}

- (void) handleSingleTap:(UITapGestureRecognizer *) gestureRecognizer{
    if (self.isEditing) {
        for (LeShowButton *item in _btnArray) {
            [item disableEditing];
        }
    }
    self.isEditing = NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(touch.view != backScrollView){
        return NO;
    }else
        return YES;
}
#pragma -mark leShowButtonDelegate
- (void) leShowButtonDidClicked:(LeShowButton *) leShowButton
{
    NSLog(@"点击");
}

- (void) leShowButtonDidEnterEditingMode:(LeShowButton *) leShowBtn
{
    for (LeShowButton * btn in self.btnArray) {
        [btn enableEditing];
    }
    self.isEditing = YES;
}

- (void)leShowButtonDidDeleted:(LeShowButton *) leShowButton atIndex:(NSInteger)index
{
      LeShowButton *btn = [self.btnArray objectAtIndex:index];
    if (self.btnArray.count > 0&&self.itemArray.count>0) {
        [self.btnArray removeObjectAtIndex:index];
        [self.itemArray removeObjectAtIndex:index];
        float rowNum = ceilf((float)itemArray.count/(float)numInRow);
        backScrollView.contentSize = CGSizeMake(320, rowNum*(size.height+centerSpaceY)+Space+50);
    }
    else
    {
        return;
    }
  
    [UIView animateWithDuration:0.2 animations:^{
        CGRect lastFrame = btn.frame;
        CGRect curFrame;
        for (int i=index; i < [_btnArray count]; i++) {
            LeShowButton *temp = [_btnArray objectAtIndex:i];
            curFrame = temp.frame;
            [temp setFrame:lastFrame];
            lastFrame = curFrame;
            [temp setIndex:i];
        }
    }];
    [btn removeFromSuperview];
    btn = nil;
}

- (void)leShowButtonDidMoved:(LeShowButton *) leShowButton withLocation:(CGPoint)point moveGestureRecognizer:(UILongPressGestureRecognizer*)recognizer
{
    CGRect frame = leShowButton.frame;
    CGPoint _point = [recognizer locationInView:backScrollView];
//    CGPoint pointInView = [recognizer locationInView:self.view];
    frame.origin.x = _point.x - point.x;
    frame.origin.y = _point.y - point.y;
    leShowButton.frame = frame;
    NSLog(@"gridItemframe:%f,%f",frame.origin.x,frame.origin.y);
    NSLog(@"move to point(%f,%f)",point.x,point.y);
    
    NSInteger toIndex = [self indexOfLocation:_point];
    NSInteger fromIndex = leShowButton.index;
    NSLog(@"fromIndex:%d toIndex:%d",fromIndex,toIndex);
    
    if (toIndex != -1 && toIndex != fromIndex) {
        LeShowButton *moveItem = [_btnArray objectAtIndex:toIndex];
        [backScrollView sendSubviewToBack:moveItem];
        [UIView animateWithDuration:0.2 animations:^{
            CGPoint origin = [self orginPointOfIndex:fromIndex];
            NSLog(@"origin:%f,%f",origin.x,origin.y);
            moveItem.frame = CGRectMake(origin.x, origin.y, moveItem.frame.size.width, moveItem.frame.size.height);
        }];
        [self exchangeItem:fromIndex withposition:toIndex];
        //移动
        
    }

}
- (void) leShowButtonDidEndMoved:(LeShowButton *) leShowButton withLocation:(CGPoint)point moveGestureRecognizer:(UILongPressGestureRecognizer*) recognizer
{
    CGPoint _point = [recognizer locationInView:backScrollView];
    NSInteger toIndex = [self indexOfLocation:_point];
    if (toIndex == -1) {
        toIndex = leShowButton.index;
    }
    CGPoint origin = [self orginPointOfIndex:toIndex];
    [UIView animateWithDuration:0.2 animations:^{
        leShowButton.frame = CGRectMake(origin.x, origin.y, leShowButton.frame.size.width, leShowButton.frame.size.height);
    }];
    
}

- (NSInteger)indexOfLocation:(CGPoint)location{
    NSInteger index;
    
    NSInteger row = location.y / (size.height+centerSpaceY)+1;
    NSInteger col = location.x / (size.width+centerSpaceX)+1;
    if (row >= 1000 || col >= 1000) {
        return  -1;
    }
    index = (row-1) *numInRow +(col-1);
    if (index >=_btnArray.count) {
        return -1;
    }
    return index;
}

- (CGPoint)orginPointOfIndex:(NSInteger)index{
    CGPoint point = CGPointZero;
    if (index > [_btnArray count] || index < 0) {
        return point;
    }else{
        NSInteger row = index/numInRow+1;
        NSInteger col = index-(row-1)*numInRow+1;
        if (topSpace>0) {
            point.x = (col-1)*(size.width+centerSpaceX)+Space;
            point.y = (row-1)*(size.height+centerSpaceY)+topSpace;
        }
       else
       {
           point.x = (col-1)*(size.width+centerSpaceX)+Space;
           point.y = (row-1)*(size.height+centerSpaceY)+Space;
       }
        return point;
    }
}

- (void)exchangeItem:(NSInteger)oldIndex withposition:(NSInteger)newIndex{
    ((LeShowButton *)[_btnArray objectAtIndex:oldIndex]).index = newIndex;
    ((LeShowButton *)[_btnArray objectAtIndex:newIndex]).index = oldIndex;
    [_btnArray exchangeObjectAtIndex:oldIndex withObjectAtIndex:newIndex];
    [self.itemArray exchangeObjectAtIndex:oldIndex withObjectAtIndex:newIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//- (void)imageView:(TBImageView *)imageView didLoadImage:(UIImage*)image
//{
////    NSLog(@"加载完成");
//
//}
//
//- (void)imageView:(TBImageView *)imageView didLoadTheLocalImage:(UIImage*)image
//{
////    NSLog(@"加载完成");
//    
//}


- (void)dealloc
{
    [backScrollView release];
    [backScrollView removeGestureRecognizer:singletap];
    self.btnArray = nil;
//    TB_RELEASE_CF_SAFELY(itemArray); // release
//    TB_RELEASE_CF_SAFELY(singletap);
    [super dealloc];
}



#pragma mark ------- delegate----------
- (void)didNetworkError:(NSDictionary *)params {
    
    [self hideLoadingView];
    [self showLoading:NO];
    
    [super didNetworkErrorDeal:params];
}





@end
