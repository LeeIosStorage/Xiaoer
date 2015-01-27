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

@interface XEUserInfo () {
    NSMutableArray* _babys;
    NSString* _jsonString;
}
@end

@implementation XEUserInfo

- (void)doSetBabyInfoByJsonDic:(NSDictionary*)dic{

    if ([dic objectForKey:@"id"]) {
        _babyId = [dic objectForKey:@"id"];
    }
    if ([dic objectForKey:@"name"]) {
        _babyNick = [dic objectForKey:@"name"];
    }
//    if ([dic objectForKey:@"icon"]) {
//        _babyAvatar = [dic objectForKey:@"icon"];
//    }
    if ([dic objectForKey:@"icon"]) {
        _babyAvatarId = [dic objectForKey:@"icon"];
    }
    
    if ([dic objectForKey:@"gender"]) {
        _babyGender = [dic objectForKey:@"gender"];
    }
    if ([dic objectForKey:@"born"]) {
        self.birthdayString = [dic objectForKey:@"born"];
    }
//    if ([dic objectForKey:@"birthdayString"]) {
//        _region = [dic objectForKey:@"birthdayString"];
//    }
    _babyMonth = [[dic objectForKey:@"month"] intValue];
}

- (NSURL *)babySmallAvatarUrl {
    if (_babyAvatarId == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], @"small", _babyAvatarId]];
}

- (void)doSetUserInfoByJsonDic:(NSDictionary*)dic {
    //....
    if ([dic objectForKey:@"account"]) {
        _account = [dic objectForKey:@"account"];
    }
//    if ([dic objectForKey:@"district"]) {
//        _district = [dic objectForKey:@"district"];
//    }
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
    if ([dic objectForKey:@"desc"]) {
        _desc = [dic objectForKey:@"desc"];
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
    if ([dic objectForKey:@"district"]) {
        _region = [dic objectForKey:@"district"];
    }
    NSDictionary* area = [dic objectForKey:@"area"];
    if (area) {
        if ([area objectForKey:@"code"]) {
            _region = [area objectForKey:@"code"];
        }
        if ([area objectForKey:@"name"]) {
            _regionName = [area objectForKey:@"name"];
        }
    }
    if ([dic objectForKey:@"address"]) {
        _address = [dic objectForKey:@"address"];
    }
    if ([dic objectForKey:@"phone"]) {
        _phone = [dic objectForKey:@"phone"];
    }
    if ([dic objectForKey:@"avatar"]) {
//        if ([[dic objectForKey:@"avatar"] containsString:@"."]) {
//            NSString *avaStr = [[dic objectForKey:@"avatar"] stringByReplacingOccurrencesOfString:@"." withString:@""];
//            _avatar = avaStr;
//        }else{
//            _avatar = [dic objectForKey:@"avatar"];
//        }
        _avatar = [dic objectForKey:@"avatar"];
    }
    
    _babys = [[NSMutableArray alloc] init];
    for (NSDictionary*babyDic in [dic objectForKey:@"babys"]) {
        XEUserInfo* babyInfo = [[XEUserInfo alloc] init];
        [babyInfo doSetBabyInfoByJsonDic:babyDic];
        [_babys addObject:babyInfo];
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

//- (void)setUserAndBabyInfoByJsonDic:(NSDictionary*)dic{
//    if (![dic isKindOfClass:[NSDictionary class]]) {
//        return;
//    }
//    if (![[dic objectForKey:@"baby"] isKindOfClass:[NSDictionary class]] || ![[dic objectForKey:@"user"] isKindOfClass:[NSDictionary class]]) {
//        return;
//    }
//    _userAndBabyInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
//    _uid = [[[dic objectForKey:@"user"] objectForKey:@"id"] description];
//    
//    @try {
//        [self doSetUserInfoByJsonDic:[dic objectForKey:@"user"]];
//        [self doSetBabyInfoByJsonDic:[dic objectForKey:@"baby"]];
//    }
//    @catch (NSException *exception) {
//        NSLog(@"####XEUserInfo setUserAndBabyInfoByJsonDic exception:%@", exception);
//    }
//    
//    self.jsonString = [[dic objectForKey:@"user"] JSONString];
//}

+ (NSString*)getAvatarUrlWithAvatar:(NSString*)avatar size:(int)size{
    
    return [NSString stringWithFormat:@"%@/upload/%d/%@", [[XEEngine shareInstance] baseUrl], size, avatar];
}

- (NSString*)getAvatarUrlWithType:(NSString*)type{
    if (_avatar == nil) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], type, _avatar];
}

- (NSURL *)smallAvatarUrl {
    if (_avatar == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], @"small", _avatar]];
}

- (NSURL *)mediumAvatarUrl{
    if (_avatar == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], @"middle", _avatar]];
}

- (NSURL *)largeAvatarUrl{
    if (_avatar == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], @"large", _avatar]];
}

- (NSURL *)originalAvatarUrl {
    if (_avatar == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], _avatar]];
}

- (NSString*)getSmallAvatarUrl{
    return [self getAvatarUrlWithType:@"small"];
}

- (NSString*)getMediumAvatarUrl{
    return [self getAvatarUrlWithType:@"middle"];
}

- (NSString*)getlargeAvatarUrl{
    return [self getAvatarUrlWithType:@"large"];
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
    
    NSArray* yearItems = [birthdayString componentsSeparatedByString:@" "];
    if (yearItems.count < 1) {
        return;
    }
    birthdayString = [yearItems objectAtIndex:0];
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
