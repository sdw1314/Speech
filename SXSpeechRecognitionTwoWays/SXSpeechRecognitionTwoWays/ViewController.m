//
//  ViewController.m
//  SpeechRecognition
//
//  Created by 丁诗瑶 on 2017/1/19.
//  Copyright © 2017年 dsy. All rights reserved.
//


#import "ViewController.h"
#import "AVAudioManager.h"
#import <Speech/Speech.h>
#import "constants.h"
#import "showDetailTbController.h"
NSInteger Number = 1;
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *showBufferText;
// 各个button
@property (weak, nonatomic) IBOutlet UIButton *restartBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (strong, nonatomic) IBOutlet UIButton *localBtn;




@property(nonatomic,strong)SFSpeechRecognizer *bufferRec;
@property(nonatomic,strong)SFSpeechAudioBufferRecognitionRequest *bufferRequest;
@property(nonatomic,strong)SFSpeechRecognitionTask *bufferTask;
@property(nonatomic,strong)AVAudioEngine *bufferEngine;
@property(nonatomic,strong)AVAudioInputNode *buffeInputNode;
@property(nonatomic,strong)NSString *bufferText;
@property(nonatomic,strong)NSString *path;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.showBufferText.numberOfLines = 0;
    

    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        // 对结果枚举的判断
        if(status != SFSpeechRecognizerAuthorizationStatusAuthorized){
            NSLog(@"Force Quit");
            [@[] objectAtIndex:1];
        }
    }];
    [[AVAudioManager shareManager] start];
}

// 重新录音
- (IBAction)restartBufferR:(id)sender {

    [self startBufferR:sender];
    
}

// 开始录音
- (IBAction)startBufferR:(UIButton *)sender {

    switch (Number) {//根据pickview中的选项选择语言
        case 0:
            self.bufferRec = [[SFSpeechRecognizer alloc]initWithLocale:[NSLocale localeWithLocaleIdentifier:@"de-DE"]];//德语
            break;
        case 1:
            self.bufferRec = [[SFSpeechRecognizer alloc]initWithLocale:[NSLocale localeWithLocaleIdentifier:@"en-US"]];
            break;
        case 2:
            self.bufferRec = [[SFSpeechRecognizer alloc]initWithLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
            break;
            
        default:
            break;
    }
   // self.bufferRec = [[SFSpeechRecognizer alloc]initWithLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    self.bufferEngine = [[AVAudioEngine alloc]init];
    self.buffeInputNode = [self.bufferEngine inputNode];
    
    if (_bufferTask != nil) {
        [_bufferTask cancel];
        _bufferTask = nil;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];

    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [audioSession setMode:AVAudioSessionModeMeasurement error:nil];
    [audioSession setActive:true error:nil];
    
    // block外的代码也都是准备工作，参数初始设置等
    self.bufferRequest = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
    self.bufferRequest.shouldReportPartialResults = true;
    __weak ViewController *weakSelf = self;
    self.bufferTask = [self.bufferRec recognitionTaskWithRequest:self.bufferRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        
        if (result != nil) {


            weakSelf.showBufferText.text = result.bestTranscription.formattedString;

            self.bufferText =weakSelf.showBufferText.text;//将textview的text存储于文本格式

        }
        if (error != nil) {
            NSLog(@"%@",error.userInfo);
        }
    }];
    
    // 监听一个标识位并拼接流文件
    AVAudioFormat *format =[self.buffeInputNode outputFormatForBus:0];
    [self.buffeInputNode installTapOnBus:0 bufferSize:1024 format:format block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [self.bufferRequest appendAudioPCMBuffer:buffer];
    }];
    
    // 准备并启动引擎
    [self.bufferEngine prepare];
    NSError *error = nil;
    if (![self.bufferEngine startAndReturnError:&error]) {
        NSLog(@"%@",error.userInfo);
    };
    weakSelf.showBufferText.text = @"I am listening.....";//录入之前的提示
}

// 结束录音
- (IBAction)stopBufferR:(id)sender {//重置buffertext
    [self.bufferEngine stop];
    [self.buffeInputNode removeTapOnBus:0];

    // 写入文件
    NSString *file = [self.bufferText substringToIndex:1];
    [self writefile:self.bufferText filename: file];


    //[self writefile:self.bufferText];
    
    self.showBufferText.text = @"";
    self.bufferRequest = nil;
    self.bufferTask = nil;
    
}

- (void)writefile:(NSString *)string filename:(NSString*)fileName
{

    // 文件路径

    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);//设置文件路径
    NSString *homePath = [paths objectAtIndex:0];//获取当前路径
  //  NSString *filePath= [homePath stringByAppendingPathComponent:@"Localplist.plist"];//获取文件路径

    NSString * filePath = [homePath stringByAppendingPathComponent:fileName];


    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![fileManager fileExistsAtPath:filePath]) {
        NSLog(@"-----文件不存在，写入文件");
        NSError * error;
        if ([string writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
            NSLog(@"-----写入文件-----success");
        }else
        {
            NSLog(@"------写入失败----fail,error=%@",error);
        }
    }
    else{ // 追加写入文件；不是覆盖
        NSLog(@"---文件存在，追加文件-----");
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        [fileHandle seekToEndOfFile]; // 节点跳到文件的末尾


        NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];

        [fileHandle writeData:stringData];

        [fileHandle closeFile];

    }


}








// 显示记录的详细信息
- (IBAction)showDetail:(UIButton *)sender {


}

// get
- (NSMutableArray *)mrArray{
    if (_mrArray==nil) {
        _mrArray = [NSMutableArray array];
    }

    return _mrArray;
}

@end
