//
//  LeftPanelViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 8/16/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "LeftPanelViewController.h"
#import "LeftPanelTableViewCell.h"
#import "SignUpLoginViewController.h"
#import  "SWRevealViewController.h"
#import "AddressListViewController.h"
#import "OrderHistoryViewController.h"
#import "OrderTrackingViewController.h"
#import "RequestUtility.h"
#import "DBManager.h"

@interface LeftPanelViewController ()
@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) NSArray *arrayImage;
@end

@implementation LeftPanelViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  
}

-(void)viewWillAppear:(BOOL)animated{
  [self loadLeftPanel];
}


-(void)loadLeftPanel{
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  NSString *userId=[userdictionary valueForKey:@"user_id"];
  NSString *userFullName=[userdictionary valueForKey:@"user_name"];
  if (userId.length>0) {self.loginLbl.text = userFullName;}else{self.loginLbl.text=@"Login to your account";}
  if (userId.length>0) {
    self.array = @[@"Address Book",
                   @"Order History",
                   @"About Us",@"Order Tracking",@"Sign Out"];
    
    self.arrayImage = @[@"address_book",
                        @"order_history",
                        @"about",
                        @"payement",
                        @"faq",
                        @"faq",
                        @"shareapp",
                        @"about",
                        @"about"];
    [self.tableVw reloadData];
    
  }else{
    
    self.array = @[@"About Us"];
    
    self.arrayImage = @[@"about"];
    [self.tableVw reloadData];
    
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  //#warning Incomplete implementation, return the number of sections
  return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  //#warning Incomplete implementation, return the number of rows
  
  return [self.array count];;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *cellIdentifier = @"LeftPanelTableViewCell";
  
  LeftPanelTableViewCell *cell = (LeftPanelTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if(cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LeftPanelTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
  }
  
  cell.txtlbl.text = [self.array objectAtIndex:indexPath.row];
  cell.imgVw.image = [UIImage imageNamed:[self.arrayImage objectAtIndex:indexPath.row]];
  
  // Configure the cell...
  cell.backgroundColor = [UIColor clearColor];
  // Configure the cell...
  float screenWidth = [[UIScreen mainScreen] bounds].size.width;
  
  UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0.5)];/// change size as you need.
  separatorLineView.backgroundColor = [UIColor lightGrayColor];
  [cell.contentView addSubview:separatorLineView];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  NSString *userId=[userdictionary valueForKey:@"user_id"];
  if (userId.length>0) {
    NSString *storyboardName = @"Main";
    if (indexPath.row==0) {
      [RequestUtility sharedRequestUtility].isThroughLeftMenu = YES;
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
      UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"AddressListViewControllerId"];
      UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
      [navController setViewControllers: @[vc] animated: NO ];
      [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    }
    if (indexPath.row==1) {
      [RequestUtility sharedRequestUtility].isThroughLeftMenu = YES;
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
      UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryViewControllerId"];
      UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
      [navController setViewControllers: @[vc] animated: NO ];
      [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    }
    if (indexPath.row==2) {
      
      
      
    }
    if (indexPath.row==3) {
      
      [RequestUtility sharedRequestUtility].isThroughLeftMenu = YES;
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
      UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"OrderTrackingViewControllerId"];
      UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
      [navController setViewControllers: @[vc] animated: NO ];
      [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    }
    
    if (indexPath.row==4) {
      
      BOOL retval = NO;
      retval = [DBManager getSharedInstance].deleteUserData;
      if (retval) {
        [self loadLeftPanel];
      }
    }
    
    
  }else{
    
  }
  
}

- (IBAction)LoginBtnClick:(id)sender {
  
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  NSString *userId=[userdictionary valueForKey:@"user_id"];
  if (userId.length>0) {
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"YourAccountViewControllerId"];
    UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
    [navController setViewControllers: @[vc] animated: NO ];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    
  }else{
    NSLog(@"Login Clicked");
    [RequestUtility sharedRequestUtility].isThroughLeftMenu = YES;
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUpLoginViewControllerId"];
    UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
    [navController setViewControllers: @[vc] animated: NO ];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
  }
}




@end