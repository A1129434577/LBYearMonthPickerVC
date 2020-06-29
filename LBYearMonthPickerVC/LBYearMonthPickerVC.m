//
//  DatePickerViewController.m
//  QHBranch
//
//  Created by 刘彬 on 2018/12/27.
//  Copyright © 2018 BIN. All rights reserved.
//

#import "LBYearMonthPickerVC.h"
#import "LBPresentTransitions.h"

@interface LBYearMonthPickerVC ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    LBPresentTransitions *_transitions;
}
@property (nonatomic,strong)NSMutableArray<NSString *> *yearsArray;
@property (nonatomic,strong)NSMutableArray<NSArray *> *monthsOfAllYearsArray;//这些年份的所有月份
@property (nonatomic,strong)UIPickerView *datePickerView;
@end

@implementation LBYearMonthPickerVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        _transitions = [LBPresentTransitions new];
        _transitions.coverViewType = LBTransitionsCoverViewAlpha0_5;
        _transitions.contentMode = LBTransitionsContentModeBottom;
        self.transitioningDelegate = _transitions;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
        self.maximumDate = [NSDate date];
    }
    return self;
}
-(void)loadView{
    [super loadView];
    
    self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0);
    self.view.backgroundColor = [UIColor whiteColor];
    //取消
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 40, 30)];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(pickerCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    //确定
    UIButton *selectButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-CGRectGetWidth(cancelButton.frame)-15, CGRectGetMinY(cancelButton.frame), CGRectGetWidth(cancelButton.frame), CGRectGetHeight(cancelButton.frame))];
    [selectButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [selectButton setTitle:@"确定" forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(pickerSelectedDate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectButton];
    
    
    
    _datePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(selectButton.frame), CGRectGetWidth(self.view.frame), 210)];
    _datePickerView.delegate = self;
    _datePickerView.dataSource = self;
    [self.view addSubview:_datePickerView];
    
    self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetMaxY(_datePickerView.frame));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataSource];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!_selectedSimilarYear.length) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        self.selectedSimilarYear = [formatter stringFromDate:self.maximumDate];
    }
    
    [_datePickerView selectRow:[_yearsArray indexOfObject:_selectedSimilarYear] inComponent:0 animated:NO];
    
    if (self.type == LBYearMonthPickerYearAndMonth) {
        [_datePickerView reloadComponent:1];
        if (_selectedSimilarMonth.length) {
            [_datePickerView selectRow:[_monthsOfAllYearsArray[[_yearsArray indexOfObject:_selectedSimilarYear]] indexOfObject:_selectedSimilarMonth] inComponent:1 animated:NO];
        }
    }
}
    
-(void)dataSource{
    _yearsArray = [NSMutableArray array];
    _monthsOfAllYearsArray = [NSMutableArray array];
    //设定数据格式为xxxx-mm
    NSDateFormatter *yearMonthFormatter = [[NSDateFormatter alloc] init];
    yearMonthFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [yearMonthFormatter setDateFormat:@"yyyy-MM"];
    
    //加入当前年月
    NSDate *date = self.maximumDate;
    NSString *year = [[yearMonthFormatter stringFromDate:date] componentsSeparatedByString:@"-"].firstObject;
    NSString *month = [[yearMonthFormatter stringFromDate:date] componentsSeparatedByString:@"-"].lastObject;
    NSMutableArray *oneYearMonthsArray = [NSMutableArray array];
    [oneYearMonthsArray addObject:month];
    [_monthsOfAllYearsArray addObject:oneYearMonthsArray];
    [_yearsArray addObject:year];
    
    
    //通过日历可以直接获取前几个月的日期，所以这里直接用该类的方法进行循环获取数据
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *monthComps = [[NSDateComponents alloc] init];
    monthComps.month = -1;
    while ([date compare:self.minimumDate] != NSOrderedAscending) {
        //获取之前n个月, setMonth的参数为正则向后，为负则表示之前
        NSDate *lastDate = [calendar dateByAddingComponents:monthComps toDate:date options:0];
        if ([lastDate compare:self.minimumDate] == NSOrderedAscending) {
            [_eachYearDefaultLikeMonths enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                if (key.integerValue < 0) {
                    [oneYearMonthsArray addObject:obj];
                }else{
                    [oneYearMonthsArray insertObject:obj atIndex:key.unsignedIntegerValue];
                }
            }];

            typeof(self) __weak weakSelf = self;
            [_defaultLikeYearsAndMonths enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSDictionary<NSString *,NSArray *> * _Nonnull obj, BOOL * _Nonnull stop) {
                if (key.integerValue < 0) {
                    [weakSelf.yearsArray addObject:obj.allKeys.firstObject];
                    [weakSelf.monthsOfAllYearsArray addObject:obj.allValues.firstObject];
                }else{
                    [weakSelf.yearsArray insertObject:obj.allKeys.firstObject atIndex:key.unsignedIntegerValue];
                    [weakSelf.monthsOfAllYearsArray insertObject:obj.allValues.firstObject atIndex:key.unsignedIntegerValue];
                }
            }];
            break;
        }
        NSString *lastYear = [[yearMonthFormatter stringFromDate:lastDate] componentsSeparatedByString:@"-"].firstObject;
        NSString *lastMoth = [[yearMonthFormatter stringFromDate:lastDate] componentsSeparatedByString:@"-"].lastObject;
        
        if (![lastYear isEqualToString:[[yearMonthFormatter stringFromDate:date] componentsSeparatedByString:@"-"].firstObject]) {
            [_eachYearDefaultLikeMonths enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                if (key.integerValue < 0) {
                    [oneYearMonthsArray addObject:obj];
                }else{
                    [oneYearMonthsArray insertObject:obj atIndex:key.unsignedIntegerValue];
                }
            }];
            oneYearMonthsArray = [NSMutableArray array];
            [oneYearMonthsArray addObject:lastMoth];
            [_yearsArray addObject:lastYear];
            [_monthsOfAllYearsArray addObject:oneYearMonthsArray];
        }else{
            [oneYearMonthsArray addObject:lastMoth];
        }
        date = lastDate;
    }
    [_datePickerView reloadAllComponents];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    switch (self.type) {
        case LBYearMonthPickerYear:
            return 1;
            break;
        case LBYearMonthPickerYearAndMonth:
            return 2;
            break;
        default:
            return 0;
            break;
    }
    
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.yearsArray.count;
    }else{
        NSString *selectedYear = self.yearsArray[[pickerView selectedRowInComponent:0]];
        return [self.monthsOfAllYearsArray[[self.yearsArray indexOfObject:selectedYear]] count];
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.yearsArray[row];
    }else{
        NSString *selectedYear = self.yearsArray[[pickerView selectedRowInComponent:0]];
        return self.monthsOfAllYearsArray[[self.yearsArray indexOfObject:selectedYear]][row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.type == LBYearMonthPickerYearAndMonth) {
        if (component == 0) {
            [pickerView reloadComponent:1];
        }
    }
}

-(void)pickerCancel{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)pickerSelectedDate{
    typeof(self) __weak weakSelf = self;
    [weakSelf dismissViewControllerAnimated:YES completion:^{
        weakSelf.selectedSimilarYear = weakSelf.yearsArray[[weakSelf.datePickerView selectedRowInComponent:0]];
        weakSelf.selectedSimilarMonth = weakSelf.monthsOfAllYearsArray[[weakSelf.yearsArray indexOfObject:weakSelf.selectedSimilarYear]][[weakSelf.datePickerView selectedRowInComponent:1]];
        weakSelf.pickerViewSelectDate?
        weakSelf.pickerViewSelectDate(weakSelf.selectedSimilarYear,weakSelf.selectedSimilarMonth):NULL;
    }];
}
@end
