//
//  HeaderView.m
//  SingleAndAllSelect
//
//  Created by Doman on 17/4/18.
//  Copyright © 2017年 doman. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (void)awakeFromNib {
    
    self.tap = [[UITapGestureRecognizer alloc] init];
    [self addGestureRecognizer:_tap];
    
}

@end
