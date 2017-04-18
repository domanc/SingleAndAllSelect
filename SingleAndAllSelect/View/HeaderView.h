//
//  HeaderView.h
//  SingleAndAllSelect
//
//  Created by Doman on 17/4/18.
//  Copyright © 2017年 doman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *jiantouImageVIew;
@property (nonatomic, strong) UITapGestureRecognizer *tap;


@end
