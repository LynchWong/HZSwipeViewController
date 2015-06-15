//
//  ViewController.m
//  HZSwipeViewControllerDemo
//
//  Created by Lynch Wong on 6/15/15.
//  Copyright (c) 2015 Nobodyknows. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "HZSwipeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reveal:(id)sender {
    NSLog(@"reveal");
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.container reveal];
}

@end
