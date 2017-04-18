//
//  BottomView.h
//  SingleAndAllSelect
//
//  Created by Doman on 17/4/18.
//  Copyright © 2017年 doman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomView : UIView
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


+ (BottomView *)viewFromNib;

@end
