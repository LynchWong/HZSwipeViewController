//
//  SAContainerViewController.m
//  AccountingObjectiveC
//
//  Created by Lynch Wong on 5/19/15.
//  Copyright (c) 2015 Nobodyknows. All rights reserved.
//

#import "HZSwipeViewController.h"

@interface HZSwipeViewController ()

@property (strong, nonatomic) UIViewController *contentController;
@property (strong, nonatomic) UIViewController *rearController;

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *rearView;

@end

@implementation HZSwipeViewController

- (instancetype)init {
    return [self initWithRearController:nil contentController:nil];
}

- (instancetype)initWithRearController:(UIViewController *)rearController contentController:(UIViewController *)contentController {
    if (self = [super initWithNibName:nil bundle:nil]) {
        [self displayContentController:rearController contentController:contentController];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Macro

#define kViewWidth self.view.frame.size.width
#define kViewHeight self.view.frame.size.height

#define kContainerViewX -self.view.frame.size.width * 0.7
#define kContainerViewWidth self.view.frame.size.width * 1.7

#define kContainerViewCenterX self.containerView.center.x
#define kContainerViewCenterY self.containerView.center.y

#define kHalfMoved self.view.frame.size.width * 0.35

#define kLeftLimited self.view.frame.size.width * 0.85
#define kRightLimited self.view.frame.size.width * 0.15

- (void) displayContentController:(UIViewController *)rearController contentController:(UIViewController *)contentController
{
    _rearController = rearController;
    _contentController = contentController;
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(kContainerViewX, 0.0, kContainerViewWidth, kViewHeight)];
    [self.view addSubview:_containerView];
    
    rearController.view.frame = CGRectMake(0.0, 0.0, kViewWidth, kViewHeight);
    _rearView = rearController.view;
    [self addChildViewController:rearController];
    [_containerView addSubview:_rearView];
    [rearController didMoveToParentViewController:self];
    
    contentController.view.frame = CGRectMake(kViewWidth * 0.7, 0.0, kViewWidth, kViewHeight);
    _contentView = contentController.view;
    [self addChildViewController:contentController];
    [_containerView addSubview:_contentView];
    [contentController didMoveToParentViewController:self];
}

- (void)changeContentController:(UIViewController *)contentController {
    [self.contentView removeFromSuperview];
    [self.contentController removeFromParentViewController];
    
    self.contentController = contentController;
    contentController.view.frame = CGRectMake(kViewWidth * 0.7, 0.0, kViewWidth, kViewHeight);
    _contentView = contentController.view;
    [self addChildViewController:contentController];
    [_containerView addSubview:_contentView];
    [contentController didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.containerView.center = CGPointMake(kRightLimited, kContainerViewCenterY);
    }];
}

- (void)reveal {
    if (self.containerView.center.x == kLeftLimited) {
        [UIView animateWithDuration:0.2 animations:^{
            self.containerView.center = CGPointMake(kRightLimited, kContainerViewCenterY);
        }];
    } else if (self.containerView.center.x == kRightLimited) {
        [UIView animateWithDuration:0.2 animations:^{
            self.containerView.center = CGPointMake(kLeftLimited, kContainerViewCenterY);
        }];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {

    CGPoint translation = [recognizer translationInView:self.view];
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat x = self.containerView.center.x + translation.x;
        if (x >= kLeftLimited) {
            x = kLeftLimited;
        } else if (x <= kRightLimited) {
            x = kRightLimited;
        }
        [UIView animateWithDuration:0.1 animations:^{
            self.containerView.center = CGPointMake(x, kContainerViewCenterY);
        }];
    } else if (recognizer.state == UIGestureRecognizerStateCancelled) {
        if (fabs(kContainerViewCenterX - kLeftLimited) < kHalfMoved) {
            [UIView animateWithDuration:0.1 animations:^{
                self.containerView.center = CGPointMake(kLeftLimited, kContainerViewCenterY);
            }];
        } else if (fabs(kContainerViewCenterX - kRightLimited) < kHalfMoved) {
            [UIView animateWithDuration:0.1 animations:^{
                self.containerView.center = CGPointMake(kRightLimited, kContainerViewCenterY);
            }];
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (fabs(kContainerViewCenterX - kLeftLimited) < kHalfMoved) {
            [UIView animateWithDuration:0.1 animations:^{
                self.containerView.center = CGPointMake(kLeftLimited, kContainerViewCenterY);
            }];
        } else if (fabs(kContainerViewCenterX - kRightLimited) < kHalfMoved) {
            [UIView animateWithDuration:0.1 animations:^{
                self.containerView.center = CGPointMake(kRightLimited, kContainerViewCenterY);
            }];
        }
    }
    [recognizer setTranslation:CGPointZero inView:self.view];
}

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    CGPoint previousLocation = [touch previousLocationInView:self.view];
//    CGPoint location = [touch locationInView:self.view];
//    CGFloat x = self.containerView.center.x + location.x - previousLocation.x;
//    if (x >= kLeftLimited) {
//        x = kLeftLimited;
//    } else if (x <= kRightLimited) {
//        x = kRightLimited;
//    }
//    [UIView animateWithDuration:0.1 animations:^{
//        self.containerView.center = CGPointMake(x, kContainerViewCenterY);
//    }];
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (fabs(kContainerViewCenterX - kLeftLimited) < kHalfMoved) {
//        [UIView animateWithDuration:0.1 animations:^{
//            self.containerView.center = CGPointMake(kLeftLimited, kContainerViewCenterY);
//        }];
//    } else if (fabs(kContainerViewCenterX - kRightLimited) < kHalfMoved) {
//        [UIView animateWithDuration:0.1 animations:^{
//            self.containerView.center = CGPointMake(kRightLimited, kContainerViewCenterY);
//        }];
//    }
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (fabs(kContainerViewCenterX - kLeftLimited) < kHalfMoved) {
//        [UIView animateWithDuration:0.1 animations:^{
//            self.containerView.center = CGPointMake(kLeftLimited, kContainerViewCenterY);
//        }];
//    } else if (fabs(kContainerViewCenterX - kRightLimited) < kHalfMoved) {
//        [UIView animateWithDuration:0.1 animations:^{
//            self.containerView.center = CGPointMake(kRightLimited, kContainerViewCenterY);
//        }];
//    }
//}

@end
