# LBYearMonthPickerVC
```obj
LBYearMonthPickerVC *vc = [[LBYearMonthPickerVC alloc] init];
vc.eachYearDefaultLikeMonths = @{@0:@"全部"};
vc.view.layer.cornerRadius = 10;
[self presentViewController:vc animated:YES completion:nil];
vc.pickerViewSelectDate = ^(NSString * _Nonnull yearString, NSString * _Nonnull monthString) {
    NSLog(@"%@年%@月",yearString,monthString);
};
```
![](https://github.com/A1129434577/LBYearMonthPickerVC/blob/master/LBYearMonthPickerVC.png?raw=true)
