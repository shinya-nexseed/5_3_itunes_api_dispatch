//
//  ViewController.m
//  4_4_itunes_api
//
//  Created by Shinya Hirai on 2015/07/30.
//  Copyright (c) 2015年 Shinya Hirai. All rights reserved.
//

#import "ViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface ViewController () {
    NSArray *_musicList;
    NSMutableArray *_musicPlay;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [SVProgressHUD show];
    
    self.myCollectionView.dataSource = self;
    self.myCollectionView.delegate = self;
    
    // 非同期処理 (dispatch)
    dispatch_queue_t global_q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); // 裏側で処理を動かすキューを作成
    dispatch_queue_t mail_q = dispatch_get_main_queue(); // globalなキューが終了した際に呼ばれるキューを作成
    
    dispatch_async(global_q, ^{
        // 重たい処理をさせる
        // apiを叩く処理 → 時間のかかる重たい処理
        NSString *urlString = @"https://itunes.apple.com/search?term=Taylor+Swift&country=jp&lang=ja_jp&limit=50";
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSError *error = nil;
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        NSLog(@"%@",jsonObject);
        
        _musicList = jsonObject[@"results"];

        dispatch_async(mail_q, ^{
            // globalの処理が終わった際にやりたい処理
            [self.myCollectionView reloadData];
            [SVProgressHUD dismiss];
        });
    });

    
    
    self.audioPlayer = nil;
    
    
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _musicList.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    // 非同期処理 (dispatch)
//    dispatch_queue_t global_q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); // 裏側で処理を動かすキューを作成
//    dispatch_queue_t mail_q = dispatch_get_main_queue(); // globalなキューが終了した際に呼ばれるキューを作成
//    
//    dispatch_async(global_q, ^{
//        // 重たい処理をさせる
//        // apiを叩く処理 → 時間のかかる重たい処理
//        NSString *str = _musicList[indexPath.row][@"artworkUrl60"];
//        NSURL *url = [NSURL URLWithString:str];
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        UIImage *image = [UIImage imageWithData:data];
//
//        dispatch_async(mail_q, ^{
//            // globalの処理が終わった際にやりたい処理
//            cell.textLabel.text = _musicList[indexPath.row][@"trackName"];
//            cell.imageView.image = image;
//        });
//    });
//
//    
//    
//    
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSError *error = nil;
//    
//    // 音源を取得
//    NSURL *url = [NSURL URLWithString:_musicList[indexPath.row][@"previewUrl"]];
//    
//    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
//    
//    // セット
//    if (_audioPlayer == nil) {
//        // 初期化
//        _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
//        
//        // エラーの場合
//        if (error != nil) {
//            NSLog(@"Error = %@",[error localizedDescription]);
//        } else {
//            // selfをデリゲートに指定
//            self.audioPlayer.delegate = self;
//            [_musicPlay addObject:self.audioPlayer];
//        }
//    }
//    
//    // 再生、停止処理
//    if (_audioPlayer.playing) {
//        [_audioPlayer stop];
//        _audioPlayer = nil;
//    } else {
//        [_audioPlayer play];
//    }
//}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _musicList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    imageView.alpha = 0.6;
    
    UILabel *label = (UILabel *)[cell viewWithTag:3];
    label.text = _musicList[indexPath.row][@"trackName"];

    // 非同期処理 (dispatch)
    dispatch_queue_t global_q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); // 裏側で処理を動かすキューを作成
    dispatch_queue_t mail_q = dispatch_get_main_queue(); // globalなキューが終了した際に呼ばれるキューを作成
    
    dispatch_async(global_q, ^{
        // 重たい処理をさせる
        // apiを叩く処理 → 時間のかかる重たい処理
        
        NSString *str = _musicList[indexPath.row][@"artworkUrl100"];
        NSURL *url = [NSURL URLWithString:str];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        
        dispatch_async(mail_q, ^{
            // globalの処理が終わった際にやりたい処理
            
            imageView.image = image;
        });
    });

    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
