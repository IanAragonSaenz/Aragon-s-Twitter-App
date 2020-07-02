//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import "Tweet.h" 

@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;
- (void)postStatusWithText:(NSString *)text completion:(void(^)(Tweet *tweet, NSError *error))completion;
- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)getUser:(NSString *)idStr completion:(void (^)(User *, NSError *))completion;
- (void)getMe:(void (^)(User *, NSError *))completion;

@end
