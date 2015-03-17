//
//  XETrainInfo.m
//  xiaoer
//
//  Created by KID on 15/3/13.
//
//

#import "XETrainInfo.h"

@implementation XETrainInfo

- (void)doSetTrainInfoByJsonDic:(NSDictionary*)dic {
    if ([dic objectForKey:@"cat"]) {
        _cat = [dic objectForKey:@"cat"];
    }
    
    if ([[dic arrayObjectForKey:@"results"] count] > 0) {
        _resultsInfo = [[NSMutableArray alloc] initWithCapacity:[[dic arrayObjectForKey:@"results"] count]];
        for (NSDictionary *resultDic in [dic arrayObjectForKey:@"results"])
        {
            if ([resultDic stringObjectForKey:@"babyid"]) {
                _babyId = [resultDic stringObjectForKey:@"babyid"];
            }
            if ([resultDic stringObjectForKey:@"score"]) {
                _score = [resultDic stringObjectForKey:@"score"];
            }
            if ([resultDic stringObjectForKey:@"scoretitle"]) {
                _scoreTitle = [resultDic stringObjectForKey:@"scoretitle"];
            }
            if ([resultDic stringObjectForKey:@"stage"]) {
                _stage = [resultDic stringObjectForKey:@"stage"];
            }
            if ([resultDic stringObjectForKey:@"time"]) {
                _time = [resultDic stringObjectForKey:@"time"];
            }
            _catType = _cat;
            NSMutableDictionary *resultInfo = [[NSMutableDictionary alloc] init];
            [resultInfo setValue:_babyId forKey:@"babyid"];
            [resultInfo setValue:_score forKey:@"score"];
            [resultInfo setValue:_scoreTitle forKey:@"scoretitle"];
            [resultInfo setValue:_stage forKey:@"stage"];
            [resultInfo setValue:_catType forKey:@"catType"];
            [resultInfo setValue:_time forKey:@"time"];
            [_resultsInfo addObject:resultInfo];
        }
    }
}

-(void)setTrainInfoByJsonDic:(NSDictionary *)dic{
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _trainInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    
    @try {
        [self doSetTrainInfoByJsonDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####XETrainInfo setTrainInfoByJsonDic exception:%@", exception);
    }
}

@end
