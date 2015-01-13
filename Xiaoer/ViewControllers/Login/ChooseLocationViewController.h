//
//  ChooseLocationViewController.h
//  Xiaoer
//
//  Created by KID on 15/1/12.
//
//

#import "XESuperViewController.h"


typedef enum ChooseLoactionType {
    
    ChooseLoactionTypeProvince = 0,
    ChooseLoactionTypeLocal,
    ChooseLoactionTypeCountry
} ChooseLoactionType;

@protocol ChooseLocationDelegate <NSObject>

-(void) didSelectLocation:(NSDictionary *) location;

@end

@interface ChooseLocationViewController : XESuperViewController

@property (nonatomic,strong) NSArray *dataArray;
@property (strong,nonatomic) NSString *searchLocationCode;
@property (strong,nonatomic) NSString *searchLocationCodeName;
@property (nonatomic,weak) UIViewController<ChooseLocationDelegate> *delegate;

-(id) initWithLoactionType:(ChooseLoactionType) type WithCode:(NSString *) code;

@end
