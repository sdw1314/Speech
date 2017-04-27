//
//  ViewController.h
//  SpeechRecognition
//
//  Created by 丁诗瑶 on 2017/1/19.
//  Copyright © 2017年 dsy. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ViewController : UIViewController
/** 录音的全部内容 */
@property (nonatomic,strong) NSMutableArray * mrArray;
- (void)writefile:(NSString *)string;
@property NSInteger lanNumber;
@end

