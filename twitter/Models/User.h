//
//  User.h
//  twitter
//
//  Created by Ian Andre Aragon Saenz on 29/06/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImageUrlHttps;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic) int followersCount;
@property (nonatomic) int friendsCount;
@property (nonatomic) int listedCount;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
