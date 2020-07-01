//
//  TweetCell.m
//  twitter
//
//  Created by Ian Andre Aragon Saenz on 29/06/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

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
        [[APIManager shared]unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            NSLog(@"it unfavorited");
        }];
    }
    
    [self refreshData];
}

@end
