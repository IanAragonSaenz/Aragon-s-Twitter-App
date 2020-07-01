//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self fetchTweets];
    
}

- (void)fetchTweets{
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            
            self.tweets = (NSMutableArray *)tweets;
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    composeController.delegate = self;
    
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    cell.tweet = self.tweets[indexPath.row];
    
    cell.createdAt.text = cell.tweet.createdAtString;
    cell.favoriteCount.text = [NSString stringWithFormat:@"%d", cell.tweet.favoriteCount];
    cell.name.text = cell.tweet.user.name;
    cell.screenName.text = cell.tweet.user.screenName;
    cell.retweetCount.text = [NSString stringWithFormat:@"%d", cell.tweet.retweetCount];
    cell.text.text = cell.tweet.text;
    cell.replies.text = @"124";
    
    //sets the buttons to correct image
    cell.retweetCount.text = [NSString stringWithFormat:@"%d", cell.tweet.retweetCount];
    UIImage *buttonImage = [UIImage imageNamed:(cell.tweet.retweeted)? @"retweet-icon-green":@"retweet-icon"];
    [cell.retweetButton setImage:buttonImage forState:UIControlStateNormal];
    
    cell.favoriteCount.text = [NSString stringWithFormat:@"%d", cell.tweet.favoriteCount];
    buttonImage = [UIImage imageNamed:(cell.tweet.favorited)? @"favor-icon-red":@"favor-icon"];
    [cell.favoriteButton setImage:buttonImage forState:UIControlStateNormal];
    
    //gets the profile picture of the tweet
    NSString *profileImageURL = [cell.tweet.user.profileImageUrlHttps stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *profileImage = [NSURL URLWithString:profileImageURL];
    
    NSURLRequest *profileImageRequest = [NSURLRequest requestWithURL:profileImage];
    
    [cell.posterImage setImageWithURLRequest:profileImageRequest placeholderImage:nil success:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        cell.posterImage.image = image;
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        //failure
    }];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}


- (void)didTweet:(nonnull Tweet *)tweet {
    [self fetchTweets];
    [self.tableView reloadData];
}


@end
