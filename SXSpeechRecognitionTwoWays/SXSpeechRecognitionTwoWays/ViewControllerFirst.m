//
//  ViewControllerFirst.m
//  SpeechRecognition
//
//  Created by 丁诗瑶 on 2017/3/5.
//  Copyright © 2017年 Sankuai. All rights reserved.
//

#import "ViewControllerFirst.h"
#import "ViewController.h"
#import "constants.h"
extern NSInteger Number;
@interface ViewControllerFirst ()<UIPickerViewDelegate>
@property (nonatomic, strong) IBOutlet UIPickerView *pickLanguageView;
@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic,strong)NSArray *languages;//保存要展示的语言

@end

@implementation ViewControllerFirst

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self.confirmBtn addTarget:self action:@selector(gotoView:) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBtn setTitle:@"Confirm" forState:UIControlStateNormal];
    self.pickLanguageView.delegate = self;
    
    // Do any additional setup after loading the view.
}
//button触发事件
 - (void) gotoView:(UIButton*) sender
{
    
    Number = [self.pickLanguageView selectedRowInComponent:0];
    NSLog(@"%ld", (long)Number);
    //跳转到另一个viewcontroller

}

-(void)loadData{
    //展示的语言类型
    self.languages = @[@"German",@"English",@"中文"];
    
}
//指定有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
//指定每个表盘有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.languages.count;
}
//指定每行要展示的数据
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    return self.languages[row];
}




@end
