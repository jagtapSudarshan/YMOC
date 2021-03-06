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
#import "NIDropDown.h"
#import "SWRevealViewController.h"
#import "AppConstant.h"
#import <QuartzCore/QuartzCore.h>
#import "AddressListViewController.h"
#define kOFFSET_FOR_KEYBOARD 80.0
@interface AddDeliveryAddressViewController ()<NIDropDownDelegate>{
  AppDelegate *appDelegate;
  BOOL isUpdate;
  NSArray *statesArray;
  NIDropDown *dropDown;
}

@end

@implementation AddDeliveryAddressViewController
@synthesize data;
- (void)viewDidLoad {
    [super viewDidLoad];
  [self getStates];
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
    [self.doneUpdateBtn setTitle:@"ADD" forState:UIControlStateNormal];
    
    
  }
  UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
  [keyboardDoneButtonView sizeToFit];
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStylePlain target:self
                                                                action:@selector(TBdoneClicked:)];
  [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
  self.contactNoTxtFld.keyboardType = UIKeyboardTypeNumberPad;
  self.zipCodeTxtFld.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
  self.contactNoTxtFld.inputAccessoryView = keyboardDoneButtonView;
  self.zipCodeTxtFld.inputAccessoryView = keyboardDoneButtonView;
}


- (IBAction)TBdoneClicked:(id)sender
{
  NSLog(@"Done Clicked.");
  [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self animateTextField:textField up:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
  BOOL retval = NO;
  if (textField == self.stateTxtFld) {
    if(dropDown == nil) {
      CGFloat f = 200;
      dropDown = [[NIDropDown alloc]showDropDown:self.stateTxtFld :&f :statesArray :nil :@"down"];
      dropDown.delegate = self;
    }
    else {
      [dropDown hideDropDown:self.stateTxtFld];
      [self rel];
    }
    retval = NO;
  }else{
    retval = YES;
  }
  return retval;
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
  UIImageView *imgViewForDropDown = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, self.stateTxtFld.frame.size.height)];
  imgViewForDropDown.image = [UIImage imageNamed:@"drop2.png"];
  [imgViewForDropDown.layer setBorderColor: [[UIColor blackColor] CGColor]];
  [imgViewForDropDown.layer setBorderWidth: 1.0];
  self.stateTxtFld.rightView = imgViewForDropDown;
  self.stateTxtFld.rightViewMode = UITextFieldViewModeAlways;
  self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = YES;
}

-(void)doValidateUserDetails{
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  NSString *userId=[userdictionary valueForKey:@"user_id"];
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  
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
  [utility doYMOCPostRequestfor:kDelivery_address withParameters:params onComplete:^(bool status, NSDictionary *responseDictionary){
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
        NSLog(@"address addSuccessful");
        [appDelegate hideLoadingView];
        
        if ([RequestUtility sharedRequestUtility].isThroughPaymentScreen) {
          NSString * storyboardName = @"Main";
          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
          UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"FrontHomeScreenViewControllerId"];
          UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
          [navController setViewControllers: @[vc] animated: NO ];
          [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        
        }
        else if ([RequestUtility sharedRequestUtility].isThroughGuestUser){
          AddressListViewController *obj_clvc  = (AddressListViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddressListViewControllerId"];
          
          //            obj_clvc.selectedUfrespo = ufpRespo;
          [self.navigationController pushViewController:obj_clvc animated:YES];
        
        }
        else if ([RequestUtility sharedRequestUtility].isThroughLeftMenu){
          [self.navigationController popViewControllerAnimated:YES];
        }else{
          NSString * storyboardName = @"Main";
          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
          UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"FrontHomeScreenViewControllerId"];
          UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
          [navController setViewControllers: @[vc] animated: NO ];
          [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        }
        
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
//  else if (self.address2TxtFld.text.length == 0) {
//    retval= NO;
//    [message appendString:@"Please enter address2 details"];
//  }
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
  else if (![self isValidPinCode:self.zipCodeTxtFld.text]) {
    retval= NO;
    [message appendString:@"Please enter valid zipcode"];
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

-(BOOL)isValidPinCode:(NSString*)pincode    {
  
  //For US
//  NSString *pinRegex = @"^\\d{5}(-\\d{4})?$";
//  
//  //  NSString *pinRegex = @"^[0-9]{6}$";
//  NSPredicate *pinTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pinRegex];
//  
//  BOOL pinValidates = [pinTest evaluateWithObject:pincode];
//  return pinValidates;
  
  BOOL ret = NO;
  if (pincode.length>=5) {
    ret = YES;
  }else{
    ret =NO;
  }
  return ret;
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

- (BOOL)validatePhone:(NSString *)mobileNumber
{

  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
  
  NSLog(@"%@", mobileNumber);
  
  int length = (int)[mobileNumber length];
  if(length > 10)
  {
    mobileNumber = [mobileNumber substringFromIndex: length-10];
    NSLog(@"%@", mobileNumber);
    
  }
  
    NSString *numberRegEx = @"[0-9]{10}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:mobileNumber] == YES)
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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:msgString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
  }
}

- (IBAction)NavigationBackBtnClick:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define MOB_MAX_LENGTH 10
#define ZIP_MAX_LENGTH 11
#define ZipACCEPTABLE_CHARACTERS @"0123456789-"
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
  if ([textField isEqual:self.fullNameTxtFld]) {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
  }
  else if ([textField isEqual:self.cityTxtFld]) {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
  }
  else if ([textField isEqual:self.contactNoTxtFld]){
  
    int length = (int)[self getLength:textField.text];
    //NSLog(@"Length  =  %d ",length);
    
    if(length == 10)
    {
      if(range.length == 0)
        return NO;
    }
    
    if(length == 3)
    {
      NSString *num = [self formatNumber:textField.text];
      textField.text = [NSString stringWithFormat:@"%@",num];
      
      if(range.length > 0)
        textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
    }
    else if(length == 6)
    {
      NSString *num = [self formatNumber:textField.text];
      //NSLog(@"%@",[num  substringToIndex:3]);
      //NSLog(@"%@",[num substringFromIndex:3]);
      textField.text = [NSString stringWithFormat:@"%@-%@-",[num  substringToIndex:3],[num substringFromIndex:3]];
      
      if(range.length > 0)
        textField.text = [NSString stringWithFormat:@"%@-%@",[num substringToIndex:3],[num substringFromIndex:3]];
    }
    return YES;
//    int length = (int)[self getLength:textField.text];
//    //NSLog(@"Length  =  %d ",length);
//    
//    if(length == 10)
//    {
//      if(range.length == 0)
//        return NO;
//    }
//    
//    if(length == 3)
//    {
//      NSString *num = [self formatNumber:textField.text];
//      textField.text = [NSString stringWithFormat:@"(%@) ",num];
//      
//      if(range.length > 0)
//        textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
//    }
//    else if(length == 6)
//    {
//      NSString *num = [self formatNumber:textField.text];
//      //NSLog(@"%@",[num  substringToIndex:3]);
//      //NSLog(@"%@",[num substringFromIndex:3]);
//      textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
//      
//      if(range.length > 0)
//        textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
//    }
//    return YES;
  
  }
  else if (textField==self.zipCodeTxtFld) {
//    NSString *str = [self.zipCodeTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if (str.length >= ZIP_MAX_LENGTH && range.length == 0)
//    {
//      return NO; // return NO to not change text
//    }else{return YES;}
    
    int length = (int)textField.text.length;
    //NSLog(@"Length  =  %d ",length);
    
    if(length == 11)
    {
      if(range.length == 0)
        return NO;
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ZipACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
  }
  else{
    
    return YES;
  }
  
}
//#define MOB_MAX_LENGTH 10
//#define ZIP_MAX_LENGTH 6
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//  if(textField ==self.contactNoTxtFld){
//    NSString *str = [self.contactNoTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if (str.length >= MOB_MAX_LENGTH && range.length == 0)
//    {
//      return NO; // return NO to not change text
//    }else{return YES;}
//  }
//  if (textField==self.zipCodeTxtFld) {
//    NSString *str = [self.zipCodeTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if (str.length >= ZIP_MAX_LENGTH && range.length == 0)
//    {
//      return NO; // return NO to not change text
//    }else{return YES;}
//  }
//  else
//  {return YES;}
//}
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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:msgString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
  }
}


-(void)doValidateandUpdateUserDetails{
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  NSString *userId=[userdictionary valueForKey:@"user_id"];
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  
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
  [utility doYMOCPostRequestfor:kDelivery_address withParameters:params onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      [self parseUserResponse:responseDictionary];
    }else{
      appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      [appDelegate hideLoadingView];
    }
  }];
  
}

-(void)getStates{
  
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  [params setValue:self.countryTxtFld.text forKey:@"country"];
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
  NSString *String = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSLog(@"additional info string \n = %@",String);
  
  [utility doYMOCStringPostRequest:kStates withParameters:String onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      [appDelegate hideLoadingView];
      [self parseStatesResponse:responseDictionary];
    }else{
      [appDelegate hideLoadingView];
    }
  }];
}


-(void)parseStatesResponse:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
    NSString *code = [ResponseDictionary valueForKey:@"code"];
    if ([code isEqualToString:@"1"]) {
      
      dispatch_async(dispatch_get_main_queue(), ^{
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate hideLoadingView];
        if ([[ResponseDictionary valueForKey:@"code"]isEqualToString:@"1"]) {
          NSLog(@"login successfull");
          NSMutableArray *listarray = [[NSMutableArray alloc]init];
          NSArray *temp = [ResponseDictionary valueForKey:@"data"];
          for (int i =0; i<temp.count; i++) {
//            NSString *stateStr = [[temp objectAtIndex:i]valueForKey:@"state"];
//            [listarray addObject:stateStr];
            NSString *codeStr = [[temp objectAtIndex:i]valueForKey:@"code"];
            NSString *stateStr = [[temp objectAtIndex:i]valueForKey:@"state"];
            NSString *displayStr = [NSString stringWithFormat:@"%@-%@",codeStr,stateStr];
            [listarray addObject:displayStr];
          }
          statesArray = [NSArray arrayWithArray:listarray];
          NSLog(@"\n\n ListArray = %@",listarray);
//          if (statesArray.count>0) {
//            self.stateTxtFld.text = [statesArray objectAtIndex:0];
//          }
          if (statesArray.count>0) {
            
            if ([statesArray containsObject:@"NJ-New Jersey"]) {
              self.stateTxtFld.text = @"NJ-New Jersey";
            }else{
              self.stateTxtFld.text = [statesArray objectAtIndex:0];
            }
          }
//          if(dropDown == nil) {
//            CGFloat f = 200;
//            dropDown = [[NIDropDown alloc]showDropDown:self.stateTxtFld :&f :statesArray :nil :@"down"];
//            dropDown.delegate = self;
//          }
//          else {
//            [dropDown hideDropDown:self.stateTxtFld];
//            [self rel];
//          }
        }
        
      });
      
    }
    
  }else{
    dispatch_async(dispatch_get_main_queue(), ^{
      appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      [appDelegate hideLoadingView];
    });
  }
}




#pragma mark drop down
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
  //  [self btnFindFood:self];
  [self rel];
}

-(void)rel{
  dropDown = nil;
}

#pragma mark phone number format


- (NSString *)formatNumber:(NSString *)mobileNumber
{
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
  
  NSLog(@"%@", mobileNumber);
  
  int length = (int)[mobileNumber length];
  if(length > 10)
  {
    mobileNumber = [mobileNumber substringFromIndex: length-10];
    NSLog(@"%@", mobileNumber);
    
  }
  
  return mobileNumber;
}

- (int)getLength:(NSString *)mobileNumber
{
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
  
  int length = (int)[mobileNumber length];
  
  return length;
}


@end
