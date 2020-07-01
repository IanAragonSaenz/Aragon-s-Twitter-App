//
//  TweetCell.m
//  twitter
//
//  Created by Ian Andre Aragon Saenz on 29/06/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshData{
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    UIImage *buttonImage = [UIImage imageNamed:(self.tweet.retweeted)? @"retweet-icon-green":@"retweet-icon"];
    [self.retweetButton setImage:buttonImage forState:UIControlStateNormal];
    
    self.favoriteCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    buttonImage = [UIImage imageNamed:(self.tweet.favorited)? @"favor-icon-red":@"favor-icon"];
    [self.favoriteButton setImage:buttonImage forState:UIControlStateNormal];
 }

- (IBAction)tapReply:(id)sender {
    //self.tweet.favorited = !self.tweet.favorited;
    //self.tweet.favoriteCount += (self.tweet.favorited)? 1:-1;
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

- (void)setTweetCell:(Tweet *)tweet{
    
    _tweet = tweet;
    //setting all info
    self.createdAt.text = self.tweet.createdAtString;
    self.favoriteCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.name.text = self.tweet.user.name;
    self.screenName.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.text.text = self.tweet.text;
    self.replies.text = @"124";
    self.timeAgo.text = self.tweet.timeAgo;
    
    //sets the buttons to correct image
    [self refreshData];
    
    //gets the profile picture of the tweet
    NSString *profileImageURL = [self.tweet.user.profileImageUrlHttps stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *profileImage = [NSURL URLWithString:profileImageURL];
    
    NSURLRequest *profileImageRequest = [NSURLRequest requestWithURL:profileImage];
    
    [self.posterImage setImageWithURLRequest:profileImageRequest placeholderImage:nil success:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        self.posterImage.image = image;
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        //failure
    }];
}

@end
