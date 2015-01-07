//
//  XEUserInfo.m
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#import "XEUserInfo.h"
#import "JSONKit.h"

@implementation XEUserInfo

- (void)doSetUserInfoByJsonDic:(NSDictionary*)dic {
    //....
    if ([dic objectForKey:@"account"]) {
        _account = [dic objectForKey:@"account"];
    }
    if ([dic objectForKey:@"district"]) {
        _district = [dic objectForKey:@"district"];
    }
    if ([dic objectForKey:@"email"]) {
        _email = [dic objectForKey:@"email"];
    }
    if ([dic objectForKey:@"fansNum"]) {
        _fansNum = [[dic objectForKey:@"fansNum"] intValue];
    }
    if ([dic objectForKey:@"isExpert"]) {
        _isExpert = [[dic objectForKey:@"isExpert"] intValue];
    }
    if ([dic objectForKey:@"modifyTime"]) {
        _modifyTime = [dic objectForKey:@"modifyTime"];
    }
    if ([dic objectForKey:@"name"]) {
        _name = [dic objectForKey:@"name"];
    }
    if ([dic objectForKey:@"registerTime"]) {
        _registerTime = [dic objectForKey:@"registerTime"];
    }
    if ([dic objectForKey:@"title"]) {
        _title = [dic objectForKey:@"title"];
    }
    if ([dic objectForKey:@"name"]) {
        _topicNum = [[dic objectForKey:@"topicNum"] intValue];
        
    }
    if ([dic objectForKey:@"gender"]) {
        _gender = [dic objectForKey:@"gender"];
    }
    if ([dic objectForKey:@"nickName"]) {
        _nickName = [dic objectForKey:@"nickName"];
    }
    if ([dic objectForKey:@"region"]) {
        _region = [dic objectForKey:@"region"];
    }
    if ([dic objectForKey:@"address"]) {
        _region = [dic objectForKey:@"address"];
    }
    if ([dic objectForKey:@"phone"]) {
        _region = [dic objectForKey:@"phone"];
    }
    if ([dic objectForKey:@"avatarId"]) {
        _region = [dic objectForKey:@"avatarId"];
    }
    if ([dic objectForKey:@"babyNick"]) {
        _region = [dic objectForKey:@"babyNick"];
    }
    if ([dic objectForKey:@"babyAvatarId"]) {
        _region = [dic objectForKey:@"babyAvatarId"];
    }
    if ([dic objectForKey:@"babyGender"]) {
        _region = [dic objectForKey:@"babyGender"];
    }
    if ([dic objectForKey:@"birthdayDate"]) {
        _region = [dic objectForKey:@"birthdayDate"];
    }
    if ([dic objectForKey:@"birthdayString"]) {
        _region = [dic objectForKey:@"birthdayString"];
    }
}

- (void)setUserInfoByJsonDic:(NSDictionary*)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _userInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    _uid = [[dic objectForKey:@"id"] description];
    
    @try {
        [self doSetUserInfoByJsonDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####XEUserInfo setUserInfoByJsonDic exception:%@", exception);
    }
    
    self.jsonString = [_userInfoByJsonDic JSONString];
}



@end
