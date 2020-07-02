//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"

static NSString * const baseURLString = @"https://api.twitter.com";
static NSString * const consumerKey = @"jxt1hULOn09iaKqih1S9CQzBq";// Enter your consumer key here
static NSString * const consumerSecret = @"9bcTYqbARB9e4s3fS77xe65k8XoDllKANnQ9QgWM5bYaIUC8EX";// Enter your consumer secret here

@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *key = consumerKey;
    NSString *secret = consumerSecret;
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    
    [self GET:@"1.1/statuses/home_timeline.json"
   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
        NSMutableArray *tweets = [Tweet tweetsWithArray:tweetDictionaries];
        completion(tweets, nil);
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSArray *tweetDictionaries = nil;
       // Fetch tweets from cache if possible
       NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"hometimeline_tweets"];
       if (data != nil) {
           tweetDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:data];
       }
       
       completion(tweetDictionaries, error);
   }];
}

- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *tweet, NSError *error))completion{
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": text};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *_Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion{
    NSString *url = @"1.1/favorites/create.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary  *_Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweet.idStr];
    //NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary  *_Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
    
}

- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion{
    NSString *url = @"1.1/favorites/destroy.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary  *_Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
        completion(tweet, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
    
}

- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/unretweet/%@.json", tweet.idStr];
    //NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary  *_Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
    
}

- (void)getUser:(NSString *)idStr completion:(void (^)(User *, NSError *))completion{
    
    NSDictionary *parameters = @{@"user_id": idStr};
    
    [self GET:@"https://api.twitter.com/1.1/users/lookup.json" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary  *_Nullable dictionary) {
        User *user = [[User alloc] initWithDictionary:dictionary];
        completion(user, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)getMe:(void (^)(User *, NSError *))completion{
    [self GET:@"https://api.twitter.com/1.1/account/verify_credentials.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary  *_Nullable dictionary) {
        User *user = [[User alloc] initWithDictionary:dictionary];
        completion(user, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

@end
