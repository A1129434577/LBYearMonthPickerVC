//
//  ViewController.m
//  LBTextFieldDemo
//
//  Created by 刘彬 on 2019/9/24.
//  Copyright © 2019 刘彬. All rights reserved.
//

#import "ViewController.h"
#import "LBYearMonthPickerVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"LBYearMonthPickerVC";
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self showPicker];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showPicker];
}
-(void)showPicker{
    LBYearMonthPickerVC *vc = [[LBYearMonthPickerVC alloc] init];
    vc.eachYearDefaultLikeMonths = @{@1:@"全部"};
    vc.view.layer.cornerRadius = 10;
    [self presentViewController:vc animated:YES completion:nil];
    vc.pickerViewSelectDate = ^(NSString * _Nonnull yearString, NSString * _Nonnull monthString) {
        NSLog(@"%@年%@月",yearString,monthString);
    };
}
@end
