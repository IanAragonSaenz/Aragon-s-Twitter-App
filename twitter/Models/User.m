//
//  User.m
//  twitter
//
//  Created by Ian Andre Aragon Saenz on 29/06/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageUrlHttps = dictionary[@"profile_image_url_https"];
        self.desc = dictionary[@"description"];
        self.followersCount = [dictionary[@"followers_count"] intValue];
        self.friendsCount = [dictionary[@"friends_count"] intValue];
        self.listedCount = [dictionary[@"listed_count"] intValue];
    }
    return self;
}

@end
