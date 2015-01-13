//
//  XEUserInfo.m
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#import "XEUserInfo.h"
#import "JSONKit.h"
#import "XEEngine.h"

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
    if ([dic objectForKey:@"topicNum"]) {
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
        _address = [dic objectForKey:@"address"];
    }
    if ([dic objectForKey:@"phone"]) {
        _phone = [dic objectForKey:@"phone"];
    }
    if ([dic objectForKey:@"avatar"]) {
        _avatar = [dic objectForKey:@"avatar"];
    }
    if ([dic objectForKey:@"avatarId"]) {
        _avatarId = [dic objectForKey:@"avatarId"];
    }
    if ([dic objectForKey:@"babyNick"]) {
        _babyNick = [dic objectForKey:@"babyNick"];
    }
    if ([dic objectForKey:@"babyAvatarId"]) {
        _babyAvatarId = [dic objectForKey:@"babyAvatarId"];
    }
    if ([dic objectForKey:@"babyGender"]) {
        _babyGender = [dic objectForKey:@"babyGender"];
    }
    if ([dic objectForKey:@"birthdayDate"]) {
        _birthdayDate = [dic objectForKey:@"birthdayDate"];
    }
    if ([dic objectForKey:@"birthdayString"]) {
        _birthdayString = [dic objectForKey:@"birthdayString"];
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

+ (NSString*)getAvatarUrlWithUid:(NSString*)uid avatarId:(NSString*)avatarId size:(int)size{
    
    return [NSString stringWithFormat:@"%@/avatar/%@/%@/0/%d", [[XEEngine shareInstance] baseUrl], uid, avatarId, size];
}

- (NSString*)getAvatarUrlWithSize:(int)size{
    if (_avatarId == nil) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@/avatar/%@/%@/0/%d", [[XEEngine shareInstance] baseUrl], _uid, _avatarId, size];
}

- (NSURL *)smallAvatarUrl {
    if (_avatarId == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/avatar/%@/%@/0/%d", [[XEEngine shareInstance] baseUrl], _uid, _avatarId, 70]];
}

- (NSURL *)mediumAvatarUrl{
    if (_avatarId == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/avatar/%@/%@/0/%d", [[XEEngine shareInstance] baseUrl], _uid, _avatarId, 110]];
}

- (NSURL *)largeAvatarUrl{
    if (_avatarId == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/avatar/%@/%@/0/%d", [[XEEngine shareInstance] baseUrl], _uid, _avatarId, 140]];
}

- (NSURL *)originalAvatarUrl {
    if (_avatarId == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/avatar/%@/%@/0/%d", [[XEEngine shareInstance] baseUrl], _uid, _avatarId, 0]];
}

- (NSString*)getSmallAvatarUrl{
    return [self getAvatarUrlWithSize:70];
}

- (NSString*)getMediumAvatarUrl{
    return [self getAvatarUrlWithSize:110];
}

- (NSString*)getlargeAvatarUrl{
    return [self getAvatarUrlWithSize:140];
}

- (void)setBirthdayDate:(NSDate *)birthdayDate{
    _birthdayDate = birthdayDate;
    if (birthdayDate) {
        NSCalendar * calender = [NSCalendar currentCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit |
        NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
        NSDateComponents *comps = [calender components:unitFlags fromDate:birthdayDate];
        _birthdayString = [NSString stringWithFormat:@"%ld-%ld-%ld", comps.year, comps.month, comps.day];
    }
    
}
- (void)setBirthdayString:(NSString *)birthdayString{
    
    NSArray* items = [birthdayString componentsSeparatedByString:@"-"];
    if (items.count != 3) {
        return;
    }
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:[[items objectAtIndex:2] integerValue]];
    [comps setMonth:[[items objectAtIndex:1] integerValue]];
    [comps setYear:[[items objectAtIndex:0] integerValue]];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:comps];
    
    _birthdayDate = date;
    _birthdayString = birthdayString;
}

+ (NSString*)getBirthdayByDate:(NSDate*)date{
    NSCalendar * calender = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *comps = [calender components:unitFlags fromDate:date];
    return [NSString stringWithFormat:@"%ld-%ld-%ld", comps.year, comps.month, comps.day];
}



@end
