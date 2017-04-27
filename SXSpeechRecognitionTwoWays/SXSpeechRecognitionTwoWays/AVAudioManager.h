//
//  AVAudioManager.h
//  SpeechRecognition
//
//  Created by 丁诗瑶 on 2017/1/20.
//  Copyright © 2017年 dsy. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface AVAudioManager : NSObject

+ (instancetype)shareManager;

- (void)start;
- (void)stop;

@end
