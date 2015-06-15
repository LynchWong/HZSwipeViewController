//
//  SAContainerViewController.h
//  AccountingObjectiveC
//
//  Created by Lynch Wong on 5/19/15.
//  Copyright (c) 2015 Nobodyknows. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZSwipeViewController : UIViewController

- (instancetype)initWithRearController:(UIViewController *)rearController contentController:(UIViewController *)contentController;

- (void)changeContentController:(UIViewController *)contentController;
- (void)reveal;

@end
