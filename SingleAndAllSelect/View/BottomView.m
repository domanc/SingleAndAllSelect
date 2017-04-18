//
//  BottomView.m
//  SingleAndAllSelect
//
//  Created by Doman on 17/4/18.
//  Copyright © 2017年 doman. All rights reserved.
//

#import "BottomView.h"

@implementation BottomView

+ (BottomView *)viewFromNib
{
    BottomView *bottomView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    
    return bottomView;
}




@end
