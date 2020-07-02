//
//  DetailViewController.m
//  twitter
//
//  Created by Ian Andre Aragon Saenz on 02/07/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *createdAt;
@property (weak, nonatomic) IBOutlet UILabel *timeAgo;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //setting all info
    self.createdAt.text = self.tweet.createdAtString;
    self.favoriteCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.name.text = self.tweet.user.name;
    self.screenName.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.text.text = self.tweet.text;
    self.timeAgo.text = self.tweet.timeAgo;
    
    //sets the buttons to correct image
    [self refreshData];
    
    //gets the profile picture of the tweet
    NSString *profileImageURL = [self.tweet.user.profileImageUrlHttps stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *profileImage = [NSURL URLWithString:profileImageURL];
    NSURLRequest *profileImageRequest = [NSURLRequest requestWithURL:profileImage];
    
    [self.profileImage setImageWithURLRequest:profileImageRequest placeholderImage:nil success:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        self.profileImage.image = image;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        //failure
    }];
}

- (void)refreshData{
   self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
   UIImage *buttonImage = [UIImage imageNamed:(self.tweet.retweeted)? @"retweet-icon-green":@"retweet-icon"];
   [self.retweetButton setImage:buttonImage forState:UIControlStateNormal];
   
   self.favoriteCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
   buttonImage = [UIImage imageNamed:(self.tweet.favorited)? @"favor-icon-red":@"favor-icon"];
   [self.favoriteButton setImage:buttonImage forState:UIControlStateNormal];
}

- (IBAction)tapRetweet:(id)sender {
    self.tweet.retweeted = !self.tweet.retweeted;

    if(self.tweet.retweeted){
        self.tweet.retweetCount += 1;
        [[APIManager shared]retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            NSLog(@"it retweeted");
        }];
    }else{
        self.tweet.retweetCount -= 1;
        [[APIManager shared]unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            NSLog(@"it unretweeted");
        }];
    }
    [self refreshData];
}

- (IBAction)tapFavorite:(id)sender {
    self.tweet.favorited = !self.tweet.favorited;
    
    if(self.tweet.favorited){
        self.tweet.favoriteCount += 1;
        [[APIManager shared]favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error == nil){
                NSLog(@"it favorited");
            }
        }];
    }else{
        self.tweet.favoriteCount -= 1;
        [[APIManager shared]unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            NSLog(@"it unfavorited");
        }];
    }
    [self refreshData];
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
