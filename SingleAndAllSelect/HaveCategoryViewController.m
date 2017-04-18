//
//  HaveCategoryViewController.m
//  SingleAndAllSelect
//
//  Created by Doman on 17/4/18.
//  Copyright © 2017年 doman. All rights reserved.
//

#import "HaveCategoryViewController.h"
#import "BottomView.h"
#import "HeaderView.h"
#import "ChooseCell.h"

#define SCREEN [UIScreen mainScreen].bounds.size
static NSString * const ReuseIdentifierHeader = @"header";
static NSString * const ReuseIdentifierCell = @"ChooseCell";


@interface HaveCategoryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView         *chooseTable;
@property (nonatomic, strong) BottomView          *bottomView;

@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSArray             *dataArray;

@property (nonatomic, strong) NSMutableArray      *expendArray;//记录打开的分组
@property (nonatomic, strong) NSMutableArray      *selectArray;//记录选择的所有选项
@property (nonatomic, assign) NSInteger           allListCount;//所有数据个数

@end

@implementation HaveCategoryViewController

- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _dataDic;
}

- (NSMutableArray *)expendArray {
    if (!_expendArray) {
        _expendArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _expendArray;
}

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"有分类选择";
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
     [self.chooseTable registerNib:[UINib nibWithNibName:NSStringFromClass([HeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:ReuseIdentifierHeader];
    
}

- (void)setUpBottomView
{
    self.bottomView = [BottomView viewFromNib];
    self.bottomView.frame = CGRectMake(0, SCREEN.height - 50, SCREEN.width, 50);
    self.bottomView.backgroundColor = [UIColor lightGrayColor];
    self.bottomView.nameLabel.text = @"全选";
    [self.bottomView.selectButton addTarget:self action:@selector(selectAllMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomView];
}

- (void)getDateSource
{
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"role" ofType:@"plist"];
    NSMutableArray *wai = [[NSMutableArray alloc] initWithContentsOfFile:path];
    for (int i = 0; i < wai.count; i ++)
    {
        NSArray *list = [wai[i] objectForKey:@"list"];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (int j = 0; j < list.count; j ++) {
            [array addObject:[list objectAtIndex:j]];
            
        }
        [self.dataDic setObject:array forKey:[wai[i] objectForKey:@"name"]];
    }
    self.dataArray = [self.dataDic allKeys];
    
    NSMutableArray *allList = [NSMutableArray array];
    for (NSString *key in self.dataArray) {
        
        NSArray *arrays = self.dataDic[key];
        [allList addObjectsFromArray:arrays];
    }
    self.allListCount = allList.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableVie
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = self.dataArray[section];
    NSArray *array = self.dataDic[key];

    if ([self.expendArray containsObject:key]) {
        return array.count;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *key = self.dataArray[section];
    NSArray *array = self.dataDic[key];
    HeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ReuseIdentifierHeader];
    view.nameLabel.text = key;
    view.selectButton.tag = section;
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0.3)];
    lab.backgroundColor = [UIColor orangeColor];
    lab.alpha = 0.2;
    [view addSubview:lab];
    
    BOOL selectAll = YES;
    for (id object in array) {
        if (![self.selectArray containsObject:object]) {
            selectAll = NO;
        }
    }
    view.selectButton.selected = selectAll;
    [view.selectButton addTarget:self action:@selector(headerButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [view.tap addTarget:self action:@selector(headerTap:)];
    
    if ([self.expendArray containsObject:key]) {
        view.jiantouImageVIew.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else {
        view.jiantouImageVIew.transform = CGAffineTransformIdentity;
    }
    
    [self isAllSelectedAction];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.dataArray[indexPath.section];
    NSArray *array = self.dataDic[key];
    NSString *name = array[indexPath.row];
    
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
    
    NSString *key = self.dataArray[indexPath.section];
    NSArray *array = self.dataDic[key];
    NSString *name = array[indexPath.row];
    
    if ([self.selectArray containsObject:name]) {
        [self.selectArray removeObject:name];
    }else {
        [self.selectArray addObject:name];
    }
    
    [self.chooseTable reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - private methods
#pragma mark - select all
- (void)isAllSelectedAction {
    
    if (self.selectArray.count == self.allListCount) {
        
        self.bottomView.selectButton.selected = YES;
        return;
    }
    else
    {
        self.bottomView.selectButton.selected = NO;
        return;
    }
}

#pragma mark - select one class
- (void)headerButtonOnClick:(UIButton *)button {
    NSString *key = self.dataArray[button.tag];
    NSArray *array = self.dataDic[key];
    if (button.selected) {
        
        [self.selectArray removeObjectsInArray:array];
        
    }else {
        [self.selectArray addObjectsFromArray:array];
        
    }
    
    [self isAllSelectedAction];
    
    button.selected = !button.selected;
    
    [self.chooseTable reloadSections:[NSIndexSet indexSetWithIndex:button.tag] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - class tap action
- (void)headerTap:(UITapGestureRecognizer *)tap {
   
    HeaderView *view = (HeaderView *)tap.view;
    NSString *key = view.nameLabel.text;
    NSInteger index = [self.dataArray indexOfObject:key];
    
    if ([self.expendArray containsObject:key]) {
        [self.expendArray removeObject:key];
        [UIView animateWithDuration:0.1 animations:^{
            view.jiantouImageVIew.transform = CGAffineTransformIdentity;
        }];
    }else {
        [self.expendArray addObject:key];
        [UIView animateWithDuration:0.1 animations:^{
            view.jiantouImageVIew.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    }
    
    [self.chooseTable reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - select all

- (void)selectAllMethod:(UIButton *)sender {
    
    [self.selectArray removeAllObjects];
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
