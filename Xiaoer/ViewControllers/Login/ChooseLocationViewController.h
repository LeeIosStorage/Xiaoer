//
//  ChooseLocationViewController.h
//  Xiaoer
//
//  Created by KID on 15/1/12.
//
//

#import "XESuperViewController.h"


typedef enum ChooseLoactionType {
    
    ChooseLoactionTypeCountry = 0,
    ChooseLoactionTypeProvince,
    ChooseLoactionTypeLocal
} ChooseLoactionType;

@protocol ChooseLocationDelegate <NSObject>

-(void) didSelectLocation:(NSDictionary *) location;

@end

@interface ChooseLocationViewController : XESuperViewController

@property (nonatomic,strong) NSArray *dataArray;
@property (strong,nonatomic) NSString *searchLocationCode;
@property (nonatomic,weak) UIViewController<ChooseLocationDelegate> *delegate;

-(id) initWithLoactionType:(ChooseLoactionType) type WithCode:(NSString *) code;

@end
