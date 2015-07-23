//
//  SearchListViewController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/22.
//
//

#import "XESuperViewController.h"

@interface SearchListViewController : XESuperViewController
//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

//@property (strong, nonatomic) IBOutlet UIView *searchView;
//@property (weak, nonatomic) IBOutlet UILabel *searchHeaderLable;
@property (weak, nonatomic) IBOutlet UITableView *searchTab;
@property (strong, nonatomic) IBOutlet UIView *searchHeader;
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *searchBackLab;

@end
