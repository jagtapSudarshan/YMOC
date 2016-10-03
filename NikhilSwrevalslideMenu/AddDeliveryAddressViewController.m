//
//  AddDeliveryAddressViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 8/7/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "AddDeliveryAddressViewController.h"
#import "AppDelegate.h"
#import "RequestUtility.h"
#import "DBManager.h"
#define kOFFSET_FOR_KEYBOARD 80.0
@interface AddDeliveryAddressViewController (){
  AppDelegate *appDelegate;
  BOOL isUpdate;
}

@end

@implementation AddDeliveryAddressViewController
@synthesize data;
- (void)viewDidLoad {
    [super viewDidLoad];
  isUpdate = NO;
    // Do any additional setup after loading the view.
  if (data!=nil) {
    isUpdate = YES;
    self.fullNameTxtFld.text = data.fullName;
    self.address1TxtFld.text = data.address1;
    self.address2TxtFld.text = data.address2;
    self.cityTxtFld.text = data.city;
    self.zipCodeTxtFld.text = data.zipcode;
    self.stateTxtFld.text = data.state;
    self.countryTxtFld.text = data.country;
    self.contactNoTxtFld.text = data.contactno;
    self.titleLbl.text=@"Address";
    [self.doneUpdateBtn setTitle:@"Update" forState:UIControlStateNormal];
  }else{
    isUpdate = NO;
    self.fullNameTxtFld.text = @"";
    self.address1TxtFld.text = @"";
    self.address2TxtFld.text = @"";
    self.cityTxtFld.text = @"";
    self.zipCodeTxtFld.text = @"";
    self.stateTxtFld.text = @"";
    self.countryTxtFld.text = @"";
    self.contactNoTxtFld.text = @"";
    self.titleLbl.text=@"Add Address";
    [self.doneUpdateBtn setTitle:@"Done" forState:UIControlStateNormal];
  }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self animateTextField:textField up:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
  [self animateTextField:textField up:NO];
}


- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
  int animatedDistance;
  int moveUpValue = textField.frame.origin.y+ textField.frame.size.height;
  UIInterfaceOrientation orientation =
  [[UIApplication sharedApplication] statusBarOrientation];
  if (orientation == UIInterfaceOrientationPortrait ||
      orientation == UIInterfaceOrientationPortraitUpsideDown)
  {
    
    animatedDistance = 216-(520-moveUpValue-5);
    NSLog(@"%d",animatedDistance);
  }
  else
  {
    animatedDistance = 162-(320-moveUpValue-5);
    NSLog(@"1 == %d",animatedDistance);
  }
  
  if(animatedDistance>0)
  {
    const int movementDistance = animatedDistance;
    const float movementDuration = 0.3f;
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
  }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  
  [textField resignFirstResponder];
  return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = YES;
}
//http://ymoc.mobisofttech.co.in/android_api/delivery_address.php
-(void)doValidateUserDetails{
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  NSString *userId=[userdictionary valueForKey:@"user_id"];
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  
  NSString *url = @"http://ymoc.mobisofttech.co.in/android_api/delivery_address.php";
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  [params setValue:userId forKey:@"user_id"];
  [params setValue:[userdictionary valueForKey:@"user_name"] forKey:@"user_name"];
  [params setValue:self.fullNameTxtFld.text forKey:@"full_name"];
  [params setValue:self.address1TxtFld.text forKey:@"address_line1"];
  [params setValue:self.address2TxtFld.text forKey:@"address_line2"];
  [params setValue:self.contactNoTxtFld.text forKey:@"contact_no"];
  [params setValue:self.zipCodeTxtFld.text forKey:@"zipcode"];
  [params setValue:self.stateTxtFld.text forKey:@"state"];
  [params setValue:self.cityTxtFld.text forKey:@"city"];
  [params setValue:self.countryTxtFld.text forKey:@"country"];
  [params setValue:@"add_delivery_address" forKey:@"action"];
  NSLog(@"%@",params);
  [utility doYMOCPostRequestfor:url withParameters:params onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      [self parseUserResponse:responseDictionary];
    }else{
      appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      [appDelegate hideLoadingView];
    }
  }];
  
}

-(void)parseUserResponse:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
    dispatch_async(dispatch_get_main_queue(), ^{
      NSString *code = [ResponseDictionary valueForKey:@"code"];
//      if ([ResponseDictionary valueForKey:@"code"] == [NSNumber numberWithLong:1]) {
      if ([code isEqualToString:@"1"]) {
        NSLog(@"address add successfull");
        [appDelegate hideLoadingView];
        [self.navigationController popViewControllerAnimated:YES];
        
      }else{
        
        
        
        [appDelegate hideLoadingView];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[ResponseDictionary valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
      }
    });
    
  }
}



-(BOOL)doValidateUserTextFieldText:(NSMutableString*)message{

  BOOL retval = NO;
  if (self.fullNameTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter name details"];
  }
  else if (self.address1TxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter address1 details"];
  }
  else if (self.address2TxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter address2 details"];
  }
  else if (self.contactNoTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter contact details"];
  }
  else if (![self validatePhone:self.contactNoTxtFld.text]) {
    retval= NO;
    [message appendString:@"Please enter valid contact details"];
  }
  else if (self.cityTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter city details"];
  }
  else if (self.zipCodeTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter zipcode"];
  }
  else if (self.stateTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter state"];
  }
  else if (self.countryTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter Country"];
  }
  else{
    retval = YES;
  }
  return retval;
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
  BOOL stricterFilter = NO;
  NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
  NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
  NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  return [emailTest evaluateWithObject:checkString];
}

- (BOOL)validatePhone:(NSString *)number
{

    NSString *numberRegEx = @"[0-9]{10}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
    return TRUE;
    else
    return FALSE;
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)DoneBtnClick:(id)sender {
  
  NSMutableString *msgString = [[NSMutableString alloc]init];
  BOOL retval = [self doValidateUserTextFieldText:msgString];
  if (retval) {
    if (isUpdate) {
      [self doValidateandUpdateUserDetails];
    }else{
    [self doValidateUserDetails];
    }
    
  }else{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:msgString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
  }
}

- (IBAction)NavigationBackBtnClick:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

#define MOB_MAX_LENGTH 10
#define ZIP_MAX_LENGTH 6

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  if(textField ==self.contactNoTxtFld){
    NSString *str = [self.contactNoTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (str.length >= MOB_MAX_LENGTH && range.length == 0)
    {
      return NO; // return NO to not change text
    }else{return YES;}
  }
  if (textField==self.zipCodeTxtFld) {
    NSString *str = [self.zipCodeTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (str.length >= ZIP_MAX_LENGTH && range.length == 0)
    {
      return NO; // return NO to not change text
    }else{return YES;}
  }
  else
  {return YES;}
}
- (IBAction)doneUpdateBtnClick:(id)sender {
  NSMutableString *msgString = [[NSMutableString alloc]init];
  BOOL retval = [self doValidateUserTextFieldText:msgString];
  if (retval) {
    if (isUpdate) {
      [self doValidateandUpdateUserDetails];
    }else{
      [self doValidateUserDetails];
    }
    
  }else{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:msgString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
  }
}


-(void)doValidateandUpdateUserDetails{
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  NSString *userId=[userdictionary valueForKey:@"user_id"];
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  
  NSString *url = @"http://ymoc.mobisofttech.co.in/android_api/delivery_address.php";
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  [params setValue:userId forKey:@"user_id"];
  [params setValue:self.fullNameTxtFld.text forKey:@"full_name"];
  [params setValue:data.addID forKey:@"delivery_address_id"];
  [params setValue:self.address1TxtFld.text forKey:@"address_line1"];
  [params setValue:self.address2TxtFld.text forKey:@"address_line2"];
  [params setValue:self.contactNoTxtFld.text forKey:@"contact_no"];
  [params setValue:self.zipCodeTxtFld.text forKey:@"zipcode"];
  [params setValue:self.stateTxtFld.text forKey:@"state"];
  [params setValue:self.cityTxtFld.text forKey:@"city"];
  [params setValue:self.countryTxtFld.text forKey:@"country"];
  [params setValue:@"update_delivery_address" forKey:@"action"];
  NSLog(@"%@",params);
  [utility doYMOCPostRequestfor:url withParameters:params onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      [self parseUserResponse:responseDictionary];
    }else{
      appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      [appDelegate hideLoadingView];
    }
  }];
  
}

@end