//
//  UserViewController.m
//  twitter
//
//  Created by Ian Andre Aragon Saenz on 01/07/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetUserViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@interface TweetUserViewController ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *following;
@property (weak, nonatomic) IBOutlet UILabel *followers;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end

@implementation TweetUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.name.text = self.user.name;
    self.screenName.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    self.followers.text = [NSString stringWithFormat:@"%d", self.user.followersCount];
    self.following.text = [NSString stringWithFormat:@"%d", self.user.friendsCount];
    self.desc.text = self.user.desc;
    //urls for image
    NSString *url = [self.user.profileImageUrlHttps stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *urlImage = [NSURL URLWithString:url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlImage];
    //set image for profile picture
    [self.userImage setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        self.userImage.image = image;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
    }];
    
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
