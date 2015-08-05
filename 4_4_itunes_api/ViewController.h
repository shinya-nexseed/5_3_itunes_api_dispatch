//
//  ViewController.h
//  4_4_itunes_api
//
//  Created by Shinya Hirai on 2015/07/30.
//  Copyright (c) 2015年 Shinya Hirai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (nonatomic) AVAudioPlayer *audioPlayer;

@end

