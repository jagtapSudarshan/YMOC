//
//  CartViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/30/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseUtility.h"
@interface CartViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;

//@property(nonatomic,strong)NSString *selectedRestName;
@property (weak, nonatomic) IBOutlet UILabel *deliveryFeePriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderModeLbl;
//@property (nonatomic,strong)UserFiltersResponse *selectedUfrespo;

@property (weak, nonatomic) IBOutlet UILabel *salesTaxPriceLbl;
@property (weak, nonatomic) IBOutlet UITableView *tblVw;
@property (weak, nonatomic) IBOutlet UILabel *subTotalPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLbl;
@property (weak, nonatomic) IBOutlet UITextField *couponTextFld;
@property (weak, nonatomic) IBOutlet UIButton *checkOutBtn;
@property (weak, nonatomic) IBOutlet UILabel *couponAmountLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *fscrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coupOrderTop;
@property (weak, nonatomic) IBOutlet UILabel *orderScheduleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderScheduleDateTimeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDeliveryFeeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintOrderModeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constriantOrderScheduleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cosntraintCouponAmountHeight;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHacktop;

@end
