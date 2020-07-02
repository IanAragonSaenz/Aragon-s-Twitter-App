//
//  UserViewController.m
//  twitter
//
//  Created by Ian Andre Aragon Saenz on 01/07/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "UserViewController.h"
#import "APIManager.h"
#import "User.h"

@interface UserViewController ()

@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *following;
@property (weak, nonatomic) IBOutlet UILabel *followers;
@property (weak, nonatomic) IBOutlet UILabel *desc;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[APIManager shared]getMe:^(User *user, NSError *error) {
        if(error == nil){
            self.user = user;
            self.name.text = user.name;
            self.screenName.text = [NSString stringWithFormat:@"@%@", user.screenName];
            self.followers.text = [NSString stringWithFormat:@"%d", user.followersCount];
            self.following.text = [NSString stringWithFormat:@"%d", user.friendsCount];
            self.desc.text = user.desc;
        }
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
