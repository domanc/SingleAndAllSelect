//
//  ViewController.m
//  SingleAndAllSelect
//
//  Created by Doman on 17/4/18.
//  Copyright © 2017年 doman. All rights reserved.
//

#import "ViewController.h"
#import "NoCategoryViewController.h"
#import "HaveCategoryViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)noCategroy:(id)sender {
    
    NoCategoryViewController *no = [[NoCategoryViewController alloc] init];
    [self.navigationController pushViewController:no animated:YES];
}


- (IBAction)haveCategroy:(id)sender {
    
    HaveCategoryViewController *have = [[HaveCategoryViewController alloc] init];
    [self.navigationController pushViewController:have animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
