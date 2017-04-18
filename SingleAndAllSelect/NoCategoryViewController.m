//
//  NoCategoryViewController.m
//  SingleAndAllSelect
//
//  Created by Doman on 17/4/18.
//  Copyright © 2017年 doman. All rights reserved.
//

#import "NoCategoryViewController.h"
#import "HeaderView.h"
#import "BottomView.h"
#import "ChooseCell.h"


#define SCREEN [UIScreen mainScreen].bounds.size
static NSString * const ReuseIdentifierHeader = @"header";
static NSString * const ReuseIdentifierCell = @"chooseCell";

@interface NoCategoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView         *chooseTable;
@property (nonatomic, strong) BottomView          *bottomView;

@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSArray             *dataArray;
@property (nonatomic, strong) NSMutableArray      *allList;

@property (nonatomic, strong) NSMutableArray      *selectArray;//记录选择的所有选项
@property (nonatomic, assign) NSInteger           allListCount;//所有数据个数

@end

@implementation NoCategoryViewController

- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _dataDic;
}

- (NSMutableArray *)allList {
    if (!_allList) {
        _allList = [NSMutableArray arrayWithCapacity:0];
    }
    return _allList;
}

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"无分类选择";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpTableView];
    [self setUpBottomView];
    [self getDateSource];
    // Do any additional setup after loading the view.
}

- (void)setUpTableView
{
    self.chooseTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.chooseTable.frame = CGRectMake(0, 0, SCREEN.width, SCREEN.height - 50);
    self.chooseTable.backgroundColor = self.view.backgroundColor;
    self.chooseTable.delegate = self;
    self.chooseTable.dataSource = self;
    [self.view addSubview:self.chooseTable];
    [self.chooseTable registerNib:[UINib nibWithNibName:@"ChooseCell" bundle:nil] forCellReuseIdentifier:ReuseIdentifierCell];

}

- (void)setUpBottomView
{
    self.bottomView = [BottomView viewFromNib];
    self.bottomView.frame = CGRectMake(0, SCREEN.height - 50, SCREEN.width, 50);
    self.bottomView.backgroundColor = [UIColor lightGrayColor];
    self.bottomView.nameLabel.text = @"全选";
    [self.bottomView.selectButton addTarget:self action:@selector(chooseAllMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomView];
}
- (void)getDateSource
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"role" ofType:@"plist"];
    NSMutableArray *ary = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    NSLog(@"ary---%@",ary);
  
    for (int i = 0; i <ary.count; i++) {
        
        NSLog(@"ary[i]---%@",ary[i]);
        
        NSArray *list = [ary[i] objectForKey:@"list"];
        
        NSLog(@"list---%@",list);
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (int j = 0; j < list.count; j ++) {
            
            NSLog(@"[list objectAtIndex:j]------%@",[list objectAtIndex:j]);
          
            [array addObject:[list objectAtIndex:j]];
            
        }
        [self.dataDic setObject:array forKey:[ary[i] objectForKey:@"name"]];

    }
    
    NSLog(@"dataDic----%@",self.dataDic);
    
    self.dataArray = [self.dataDic allKeys];
    
    NSLog(@"dataArray---%@",self.dataArray);
   
    for (NSString *key in self.dataArray) {
        
        NSArray *arrays = self.dataDic[key];
        [self.allList addObjectsFromArray:arrays];
    }
    self.allListCount = self.allList.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allListCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *name = self.allList[indexPath.row];
    
    ChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierCell forIndexPath:indexPath];
    
    if ([self.selectArray containsObject:name]) {
        cell.selectBtn.selected = YES;
    }else {
        cell.selectBtn.selected = NO;
    }
    
    cell.nameLabel.text = name;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *name = self.allList[indexPath.row];
    
    if ([self.selectArray containsObject:name]) {
        [self.selectArray removeObject:name];
    }else {
        [self.selectArray addObject:name];
    }
    
    [self isAllSelected];
    
    [self.chooseTable reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)isAllSelected{
    
    if (self.selectArray.count == self.allListCount) {
        
        self.bottomView.selectButton.selected = YES;
    }
    else
    {
        self.bottomView.selectButton.selected = NO;
    }
}
- (void)chooseAllMethod:(UIButton *)sender {
    
    for (NSString *key in self.dataArray) {
        
        NSArray *array = self.dataDic[key];
        
        if (self.bottomView.selectButton.selected) {
            [self.selectArray removeObjectsInArray:array];
        }else {
            [self.selectArray addObjectsFromArray:array];
        }
    }
    
    self.bottomView.selectButton.selected = !self.bottomView.selectButton.selected;
    
    [self.chooseTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
