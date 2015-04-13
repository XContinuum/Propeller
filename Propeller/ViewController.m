//
//  ViewController.m
//  Propeller
//
//  Created by Michel Balamou on 18/03/2015.
//  Copyright (c) 2015 Michel Balamou. All rights reserved.
//

#import "ViewController.h"

#define LOGIN 0
#define REGISTER 1
#define AUTHENTICATION 2
#define FORGET_PASS 3
#define RESET_PASS 4
#define CHECK_TOKEN 5
#define DELETE_TOKEN 6
#define CHANGE_PASS 7

#define rgb(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]

#define HIDE_KEYBOARD(a) [self hideKeyboard:a Touch:touch]

#define ID_TO_STRING(a) [[NSString alloc] initWithData:a encoding:NSUTF8StringEncoding]

@interface ViewController ()

@end

@implementation ViewController


@synthesize Err_Internet;

//Free memory+++
@synthesize Background;
//Logo+++
@synthesize Logo_animation;

//Login+++
@synthesize indicator;

@synthesize LOG_Box;
@synthesize PROP_Error_msg;

@synthesize PROP_Email;
@synthesize PROP_Pass;
//login

//Register+++
@synthesize REG_Box;

@synthesize REG_Error_msg;

@synthesize REG_Email;
@synthesize REG_Username;
@synthesize REG_Pass;
@synthesize REG_Pass_Con;
//--

//Fraud box+++
@synthesize Fraud_Box;
//Fraud box---

//Load previous usernames+++
@synthesize logs_list;
//Load previous usernames---


//Forget pass+++
@synthesize FORGET_Box;
@synthesize FORGET_Email;

@synthesize FORGET_MAIN_box;
    //0x10
    @synthesize FORGET_0x10;
    @synthesize FORGET0_ReEmail;

    //User Box
    @synthesize FORGET_UserBox;
    @synthesize FORGET_DisplayUsername;
    @synthesize FORGET_Email_Target;

    //Email Box
    @synthesize FORGET_EmailFound_Box;
    @synthesize FORGET_SHOW_TARGET_em;

    //Success
    @synthesize FORGET_Success;
//Forget pass---

//Reset pass+++
@synthesize RESET_PASS_box;

@synthesize RESET_New_Password;
@synthesize RESET_ConfirmNew_Password;
@synthesize RESET_Error;
@synthesize RESET_Indicator;
//Reset pass---



- (void)viewDidLoad
{
    [super viewDidLoad];
   
    URL=@"howtopoo.com";
    serv=[[Connection alloc]init:URL];
    
    
    __weak typeof(self) weakSelf = self;
    
    //Status bar+++
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)]; // iOS 7
    else
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide]; //iOS 6
    
    [self setNeedsStatusBarAppearanceUpdate];
    //Status bar---
    
    maxWidth=self.view.bounds.size.width;
    
    [self PingAnimation];
    
    
    //Links+++
    Links=@[@"Propeller_Main/prop_login.php",
            @"Propeller_Main/prop_sign_up.php",
            @"Propeller_Main/prop_authentication.php",
            
            @"Propeller_Main/prop_forget_pass.php",
            @"Propeller_Main/prop_reset_pass.php",
            @"Propeller_Main/prop_check_token.php",
            
            @"Propeller_Main/prop_delete_token.php",
            @"Propeller_Main/prop_change_pass.php"];
    
    resetting=false;
    [self openReset]; //check if tokens are valid
    
    
    //Load cookies+++
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    cookies=[prefs objectForKey:@"Cookies"];
    ID=[prefs objectForKey:@"ID"];
    //Load cookies---
    
    //Internet connection+++
     [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
    {
        if ([weakSelf isInternetOn])
        {
            NSLog(@"Internet on!");
            
            CGRect r=CGRectMake(Err_Internet.frame.origin.x,-Err_Internet.frame.size.height , Err_Internet.frame.size.width, Err_Internet.frame.size.height);
            
            [UIView animateWithDuration:0.2 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
                Err_Internet.frame = r;} completion:NULL];
        }
        else
        {
            NSLog(@"Internet off!");
            
            //Animation+++
            CGRect r=CGRectMake(Err_Internet.frame.origin.x, 0, Err_Internet.frame.size.width, Err_Internet.frame.size.height);
            
            [UIView animateWithDuration:0.3 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
                Err_Internet.frame = r;} completion:NULL];
        }
    }];
    
    resized_once=false;
    
    //Name logs
    loaded_logs=false;
    done_unroll=true;
    
}


//resize
- (void)viewDidLayoutSubviews
{
    if (resized_once==false)
    {
    //iphone5
    CGSize result = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [UIScreen mainScreen].scale;
    result = CGSizeMake(result.width * scale, result.height * scale);
    
    int h=floor(result.height);
    
    
    if (h==1136.0f)
    {
        float resW=(640.0f/750.0f); // 640-750
        float resH=(1136.0f/1334.0f); // 1136-1334
        [self resize:self.view CoeffW:(resW) CoeffH:(resH)];
    }
    
        
    //Status bar+++
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)]; // iOS 7
        else
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide]; //iOS 6
    
    [self setNeedsStatusBarAppearanceUpdate];
    //Status bar---
    
        
    resized_once=true;
    }
}

//check cookies
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.window.rootViewController = self;
   
    if (!resetting)
    [self checkCookies];
}



//Other functions++++++++++++++++
- (BOOL)isInternetOn
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    //Log+++
    HIDE_KEYBOARD(PROP_Email);
    HIDE_KEYBOARD(PROP_Pass);
    
    //Reg+++
    HIDE_KEYBOARD(REG_Email);
    
    HIDE_KEYBOARD(REG_Username);
    HIDE_KEYBOARD(REG_Pass);
    HIDE_KEYBOARD(REG_Pass_Con);
    
    //Forget+++
    HIDE_KEYBOARD(FORGET_Email);
    HIDE_KEYBOARD(FORGET0_ReEmail);
    HIDE_KEYBOARD(FORGET_Email_Target);
    
    //Reset+++
    HIDE_KEYBOARD(RESET_New_Password);
    HIDE_KEYBOARD(RESET_ConfirmNew_Password);
    
    //Hide the list
    if ([touch view]!=logs_list && done_unroll && ![logs_list isHidden])
    {
        done_unroll=false;
        [logs_list setFrame:CGRectMake(logs_list.frame.origin.x, logs_list.frame.origin.y, logs_list.frame.size.width, 95.0f)];
        [logs_list setHidden:false];
        
        //Fold list animation
        [UIView animateWithDuration:0.5f animations:^{
            CGRect theFrame = logs_list.frame;
            theFrame.size.height= 0.0f;
            logs_list.frame = theFrame;
        } completion:^(BOOL finished)
         {
             done_unroll=true;
             [logs_list setHidden:true];
         }];
    }
    
    
    [super touchesBegan:touches withEvent:event];
}

- (void)hideKeyboard:(UITextField*)_textField Touch:(UITouch*)touch
{
    if ([_textField isFirstResponder] && [touch view] != _textField)
    [_textField resignFirstResponder];
}


//SWITCH BOXES++++
- (IBAction)switch_Forget:(id)sender
{
    [LOG_Box setHidden:false];
    [FORGET_Box setHidden:false];
    
    
    CGRect r=CGRectMake(maxWidth, LOG_Box.frame.origin.y, LOG_Box.frame.size.width, LOG_Box.frame.size.height);
    
    [UIView animateWithDuration:0.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
        LOG_Box.frame = r;} completion:NULL];
    
    r=CGRectMake(0, FORGET_Box.frame.origin.y, FORGET_Box.frame.size.width, FORGET_Box.frame.size.height);
    
    [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        FORGET_Box.frame = r;} completion:NULL];
}

- (IBAction)switch_LogForget:(id)sender
{
    [LOG_Box setHidden:false];
    [FORGET_Box setHidden:false];
    
    CGRect r=CGRectMake(0, LOG_Box.frame.origin.y, LOG_Box.frame.size.width, LOG_Box.frame.size.height);
    
    [UIView animateWithDuration:0.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
        LOG_Box.frame = r;} completion:NULL];
    
    r=CGRectMake(-maxWidth, FORGET_Box.frame.origin.y, FORGET_Box.frame.size.width, FORGET_Box.frame.size.height);
    
    [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        FORGET_Box.frame = r;} completion:NULL];
}


- (IBAction)switch_Reg:(id)sender
{
    [LOG_Box setHidden:false];
    [REG_Box setHidden:false];
    
    
    CGRect r=CGRectMake(-maxWidth, LOG_Box.frame.origin.y, LOG_Box.frame.size.width, LOG_Box.frame.size.height);
    
    [UIView animateWithDuration:0.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
                         LOG_Box.frame = r;} completion:NULL];
    
    r=CGRectMake(0, REG_Box.frame.origin.y, REG_Box.frame.size.width, REG_Box.frame.size.height);
    
    [UIView animateWithDuration:0.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
        REG_Box.frame = r;} completion:NULL];
}
- (IBAction)switch_Log:(id)sender
{
    [LOG_Box setHidden:false];
    [REG_Box setHidden:false];
    
    
    CGRect r=CGRectMake(0, LOG_Box.frame.origin.y, LOG_Box.frame.size.width, LOG_Box.frame.size.height);
    
    [UIView animateWithDuration:0.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
        LOG_Box.frame = r;} completion:NULL];
    
    r=CGRectMake(maxWidth, REG_Box.frame.origin.y, REG_Box.frame.size.width, REG_Box.frame.size.height);
    
    [UIView animateWithDuration:0.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
        REG_Box.frame = r;} completion:NULL];
}
//SWITCH BOXES---



#pragma mark -HTTP_Action
- (void)checkCookies //HTTP
{
    serv=[[Connection alloc]init:URL];
        
    __weak typeof(self) weakSelf = self;
    
    if (cookies!=nil && ID!=nil)
    {
        [serv postData:@{@"prop_cookies":cookies,@"prop_id":ID} URL:Links[AUTHENTICATION] Code:^(id responseObject)
         {
             NSString* result=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             NSLog(@"%@", result);
             
             if ([result isEqualToString:@"Logged"])
                [weakSelf openHome];
         }];
    }
}


-(void)fadeOutLabel:(UILabel*)labelAnim
{
    [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         labelAnim.alpha = 0.0;
                     }
                     completion:^(BOOL finished)
                    {
                        [labelAnim setHidden:true];
                        labelAnim.alpha = 1.0;
                     }];
}
-(void)fadeOutView:(UIView*)viewAnim //hide UIView
{
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut
        animations:^ {
                        viewAnim.alpha = 0.0;
                     }
    
    completion:^(BOOL finished)
     {
         
     }];
}
-(void)fadeOutView:(UIView*)viewAnim done:(void (^) (void))_code //hide UIView
{
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         viewAnim.alpha = 0.0;
                     }
     
                     completion:^(BOOL finished)
     {
         _code();
     }];
}
-(void)fadeInView:(UIView*)viewAnim done:(void (^) (void))_code //show UIView
{
    [UIView animateWithDuration:0.5
                          delay:0.5  /* starts the animation after 0.5 second */
                        options:UIViewAnimationOptionCurveEaseInOut animations:^ {viewAnim.alpha = 1.0;}
                     completion:^(BOOL finished){_code();}];
}

- (IBAction)login:(id)sender //HTTP
{
        __weak typeof(self) weakSelf = self;
        
    if ([[PROP_Email text] length]>0 && [[PROP_Pass text] length]>0)
    {
        //Show progress+++
        [self fadeOutView:LOG_Box];
        [indicator setHidden:false];
        //Show progress---
        
        NSString* prop_pass_sha=[serv SHA_2:[PROP_Pass text]];
        
        //login NEW+++
        [serv postData:@{@"prop_entry":[PROP_Email text],@"prop_pass":prop_pass_sha} URL:Links[LOGIN] Code:^(id responseObject)
         {
            NSError *error;
            NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers  error:&error];
             
             NSString* err=[NSString stringWithFormat:@"%@",[jsonArray objectForKey:@"ERROR"]];
             
             if ([err isEqualToString:@"none"])
             {
                 [PROP_Error_msg setHidden:true];
                 
                 //Save cookies & id+++
                 cookies=[NSString stringWithFormat:@"%@",[jsonArray objectForKey:@"COOKIES"]];
                 ID=[NSString stringWithFormat:@"%@",[jsonArray objectForKey:@"ID"]];
                 
                 [weakSelf saveCookies:cookies ID:ID];
                 //Save cookies & id+++
                 
                 [weakSelf save_into_logs:[PROP_Email text]];
                 
                 [weakSelf openHome];
                 
                 NSLog(@"Success!");
             }
             else
             {
                 NSLog(@"%@: %@",[jsonArray objectForKey:@"CODE"],[jsonArray objectForKey:@"ERROR"]);
                 [weakSelf ClearCookies];
                 
                 [PROP_Error_msg setText:[jsonArray objectForKey:@"ERROR"]];
                 [PROP_Error_msg setHidden:false]; //effect
                 
                 [weakSelf fadeInView:LOG_Box done:^(void)
                  {
                  [indicator setHidden:true];
                  }]; //effect
                 
             }
             
         }
         Failure:^(void)
         {
             [LOG_Box setAlpha:0.0f];
             [LOG_Box setHidden:false];
           
             [weakSelf fadeInView:LOG_Box done:^(void)
              {
                  [indicator setHidden:true];
              }];
         }
         ];
        }
        else
        {
            [PROP_Error_msg setText:@"Specified fields are empty"];
            [PROP_Error_msg setHidden:false]; //effect
        }
        
        //login NEW---
}


- (IBAction)regtr:(id)sender //HTTP
{
    __weak typeof(self) weakSelf = self;
    
    if ([self isInternetOn])
    {
        serv=[[Connection alloc]init:URL];
        
        if ([[REG_Pass text] length]>=6)
        {
        if ([[REG_Pass text] isEqualToString:[REG_Pass_Con text]])
        {
            NSString* encoded_pass=[serv SHA_2:[REG_Pass text]];

            [serv postData:@{@"prop_email":[REG_Email text],@"prop_username":[REG_Username text],@"prop_pass":encoded_pass} URL:Links[REGISTER] Code:^(id responseObject)
             {
                 NSError *error;
                 NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers  error:&error];
                 
                 NSString* err=[NSString stringWithFormat:@"%@",[jsonArray objectForKey:@"ERROR"]];
                 
                 
                 if ([err isEqualToString:@"none"])
                 {
                     //Save cookies & id
                     cookies=[NSString stringWithFormat:@"%@",[jsonArray objectForKey:@"COOKIES"]];
                     ID=[NSString stringWithFormat:@"%@",[jsonArray objectForKey:@"ID"]];
                     
                     [weakSelf saveCookies:cookies ID:ID];
                     
                     [weakSelf openHome];
                 }
                 else
                 {
                     //Load error from JSON
                     NSString* code=[NSString stringWithFormat:@"%@",[jsonArray objectForKey:@"CODE"]];
                     NSLog(@"%@: %@",code,[jsonArray objectForKey:@"ERROR"]);
                     
                    
                     //Fraud+++
                     if ([code isEqual:@"0x08"])
                     {
                         [Fraud_Box setAlpha:0.0f];
                         [Fraud_Box setHidden:false];
                         
                         
                         [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^
                         {
                            Fraud_Box.alpha = 1.0;
                          }
                            completion:^(BOOL finished)
                          {
                              
                          }];
                     }
                    //Fraud---
                     else
                     {
                         [REG_Error_msg setHidden:false];
                         REG_Error_msg.text=err;
                         
                         [weakSelf fadeOutLabel:REG_Error_msg];
                     }
                 }
                 
                 if (error)
                 {
                     NSLog(@"JSON error: %@",error);
                 }

             
             }];
            }
            else
            {
                [REG_Error_msg setHidden:false];
                REG_Error_msg.text=@"Different passwords!";
                NSLog(@"0x09 Different passwords!");
                
                [weakSelf fadeOutLabel:REG_Error_msg];
            }
        }
        else
        {
            [REG_Error_msg setHidden:false];
            REG_Error_msg.text=@"Password must be atleast 6 characters";
            
            [weakSelf fadeOutLabel:REG_Error_msg];
            
            
             NSLog(@"0x10 Different passwords!");
        }

    }
}

- (IBAction)cancel_fraud_alert:(id)sender
{
        [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^
         {
             Fraud_Box.alpha = 0.0;
         }
                         completion:^(BOOL finished)
         {
             [Fraud_Box setHidden:true];
             
         }];
}



#pragma mark -FORGET
- (void)SearchForInfo:(NSString*)info Hide:(BOOL)hide //HTTP
{
if ([self isInternetOn])
{
    __weak typeof(self) weakSelf = self;
    
    if ([info length]>0)
    {
        //Show the view+++
        if (hide)
        {
            [FORGET_MAIN_box setHidden:false];
            [FORGET_MAIN_box setAlpha:0.0f];
            [weakSelf fadeInView:FORGET_MAIN_box done:^(void){}];
        }
        //Show the view---
        
        
        //login NEW+++
        [serv postData:@{@"prop_info":info} URL:Links[FORGET_PASS] Code:^(id responseObject)
         {
             NSError *error;
             NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers  error:&error];
             
             NSString* err=[NSString stringWithFormat:@"%@",jsonArray[@"ERROR"]];
             
             if ([err isEqualToString:@"none"])
             {
                 if (jsonArray[@"USERNAME"]!=nil)
                 {
                     //Enter your email
                     NSLog(@"%@",jsonArray[@"USERNAME"]);
                     [FORGET_DisplayUsername setText:[[NSString stringWithFormat:@"@%@",info] lowercaseString]];
                     
                     [FORGET_UserBox setHidden:false];
                     [FORGET_UserBox setAlpha:0.0f];
                     [weakSelf fadeInView:FORGET_UserBox done:^(void){}];
                 }
                 else
                 if (jsonArray[@"EMAIL"]!=nil)
                 {
                     //show account
                     
                     //Submit
                     NSLog(@"%@",jsonArray[@"EMAIL"]);
                     
                     [FORGET_SHOW_TARGET_em setText:[info lowercaseString]];
                     [FORGET_EmailFound_Box setHidden:false];
                     [FORGET_EmailFound_Box setAlpha:0.0f];
                     [weakSelf fadeInView:FORGET_EmailFound_Box done:^(void){}];
                 }
             }
             else
             {
                 NSLog(@"%@ %@",jsonArray[@"CODE"],jsonArray[@"ERROR"]);
                 
                 if ([jsonArray[@"CODE"] isEqualToString:@"0x10"])
                 {
                     //We couldn't find your account with that information
                     
                     [FORGET_SHOW_TARGET_em setText:[info lowercaseString]];
                     //Show the view+++
                     [FORGET_0x10 setHidden:false];
                     [FORGET_0x10 setAlpha:0.0f];
                     [weakSelf fadeInView:FORGET_0x10 done:^(void){}];
                     //Show the view---
                 }
             }
         }
               Failure:^()
         {
             //Hide the main view+++
             [FORGET_MAIN_box setHidden:false];
             [FORGET_MAIN_box setAlpha:1.0f];
             
             [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut
                              animations:^ {
                                  FORGET_MAIN_box.alpha = 0.0;
                              }
              
                              completion:^(BOOL finished)
              {
                  [FORGET_MAIN_box setHidden:true];
              }];
             //Hide the main view---
             
         }
         ];
    }
}
}

- (void)submitEmailToReset:(NSString*)email //HTTP
{
    if ([self isInternetOn])
    {
        //__weak typeof(self) weakSelf = self;
        
        if ([email length]>0)
        {
            [serv postData:@{@"prop_email":email} URL:Links[RESET_PASS] Code:^(id responseObject)
             {
                 NSError *error;
                 NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers  error:&error];
                 
                 NSString* err=[NSString stringWithFormat:@"%@",jsonArray[@"ERROR"]];
                 
                 if ([err isEqualToString:@"none"])
                 {
                     [FORGET_Success setHidden:false];
                     [FORGET_UserBox setHidden:true];
                     [FORGET_EmailFound_Box setHidden:true];
                     [FORGET_0x10 setHidden:true];
                     
                     [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut
                                      animations:^ {
                                          FORGET_MAIN_box.alpha = 0.0;
                                      }
                                      completion:^(BOOL finished)
                      {
                          [FORGET_Success setHidden:true];
                          [FORGET_MAIN_box setHidden:true];
                          
                          [FORGET0_ReEmail resignFirstResponder];
                          [FORGET0_ReEmail setText:@""];
                          [FORGET_Email_Target resignFirstResponder];
                          [FORGET_Email_Target setText:@""];
                          [FORGET_DisplayUsername setText:@""];
                      }];
                 }
                 else
                 {
                     NSLog(@"%@ %@",jsonArray[@"CODE"],jsonArray[@"ERROR"]);
                 }
             }
                   Failure:^()
             {
                 //Hide the main view+++
                 [FORGET_MAIN_box setHidden:false];
                 [FORGET_MAIN_box setAlpha:1.0f];
                 
                 [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut
                                  animations:^ {
                                      FORGET_MAIN_box.alpha = 0.0;
                                  }
                  
                                  completion:^(BOOL finished)
                  {
                      [FORGET_MAIN_box setHidden:true];
                  }];
                 //Hide the main view---
                 
             }

             ];
        }
    }
}

- (IBAction)forget:(id)sender //HTTP
{
    [FORGET_Email resignFirstResponder];
    [self SearchForInfo:[FORGET_Email text] Hide:TRUE];
}



//0x10
- (IBAction)forget_search:(id)sender
{
    //Do the same as (forget)^
    [FORGET_0x10 setHidden:true];
    [FORGET0_ReEmail resignFirstResponder];
    [self SearchForInfo:[FORGET0_ReEmail text] Hide:FALSE];
    [FORGET_MAIN_box setAlpha:1.0f];
}

- (IBAction)cancel_forget_pass:(id)sender
{
    //Show the view+++
    [FORGET_MAIN_box setHidden:false];
    [FORGET_MAIN_box setAlpha:1.0f];
    
    [FORGET0_ReEmail resignFirstResponder];
    [FORGET_Email_Target resignFirstResponder];
  
    
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut
        animations:^ {
                         FORGET_MAIN_box.alpha = 0.0;
                     }
     
        completion:^(BOOL finished)
            {
                [FORGET_0x10 setHidden:true];
                [FORGET_MAIN_box setHidden:true];
                [FORGET_UserBox setHidden:true];
                [FORGET_EmailFound_Box setHidden:true];
                
                [FORGET0_ReEmail setText:@""];
                [FORGET_Email_Target setText:@""];
                [FORGET_DisplayUsername setText:@""];
            }];
    //Show the view---
}
//+++



//User box+++
- (IBAction)for_submit_email:(id)sender //FIX
{
    [self submitEmailToReset:[FORGET_Email_Target text]];
}
- (IBAction)for_cancel:(id)sender
{
    [self performSelector:@selector(cancel_forget_pass:) withObject:sender];
}

- (IBAction)not_my_account:(id)sender
{
    [self performSelector:@selector(cancel_forget_pass:) withObject:sender];
}
//User box---


//Email confirmed+++
-(IBAction)for_submit:(id)sender
{
    [self submitEmailToReset:[FORGET_SHOW_TARGET_em text]];
}

-(IBAction)for_cancel_email:(id)sender
{
  [self performSelector:@selector(cancel_forget_pass:) withObject:sender];
}
//Email confirmed---

//HTTP ACTION---


#pragma mark -ResetPass
- (void)openReset //View did load
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    __weak typeof(self) weakSelf = self;
    
    token=[prefs objectForKey:@"Reset_token"];
    identifier=[prefs objectForKey:@"identifier"];
    
    if (token!=nil && identifier!=nil)
    {
        if ([token length]>0 && [identifier length]>0)
        {
            [serv postData:@{@"prop_token":token,@"prop_id":identifier} URL:Links[CHECK_TOKEN] Code:^(id responseObject)
             {
                 NSString* result=ID_TO_STRING(responseObject);
                 
                 NSLog(@"Token: %@",result); //temp
                 
                 if ([result isEqualToString:@"VALID"])
                 {
                     //Show reset pass+++
                     resetting=true;
                     [weakSelf ClearCookies];
                     [RESET_PASS_box setHidden:false];
                     [LOG_Box setHidden:true];
                     //Show reset pass---
                 }
                 
                 [prefs setValue:@"" forKey:@"Reset_token"];
                 [prefs setValue:@"" forKey:@"identifier"];
             }];
        }
        
    }
}

- (IBAction)cancelReseting:(id)sender //HTTP
{
    [RESET_New_Password resignFirstResponder];
    [RESET_ConfirmNew_Password resignFirstResponder];
    
    //Delete PROP_Reset_Token+++
    if (token!=nil && identifier!=nil)
    {
    if ([token length]>0 && [identifier length]>0)
    {
    [serv postData:@{@"prop_token":token,@"prop_id":identifier} URL:Links[DELETE_TOKEN] Code:^(id responseObject)
     {
         NSLog(@"%@", ID_TO_STRING(responseObject));
         token=@"";
         identifier=@"";
         
         NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
         [prefs setValue:@"" forKey:@"Reset_token"];
         [prefs setValue:@"" forKey:@"identifier"];
     }];
    }
    }
    //Delete PROP_Reset_Token---
    
    __weak typeof(self) weakSelf = self;
    
    //Hide reset box+++
    [self fadeOutView:RESET_PASS_box done:^(void)
    {
        [RESET_PASS_box setHidden:true];
        [RESET_PASS_box setAlpha:1.0f];
        
        [LOG_Box setAlpha:0.0f];
        [LOG_Box setHidden:false];
        
        [weakSelf fadeInView:LOG_Box done:^(void){}];
    }];
}

-(IBAction)resetPassword:(id)sender //HTTP
{
    __weak typeof(self) weakSelf = self;
   
    //show progress~
    [RESET_PASS_box setAlpha:1.0f];
    [self fadeOutView:RESET_PASS_box done:^(void){}];
    [RESET_Indicator setHidden:false];
    //show progress~
    
    if ([[RESET_New_Password text] length]>=6 && [[RESET_ConfirmNew_Password text] length]>=6)
    {
        if ([[RESET_New_Password text] isEqualToString:[RESET_ConfirmNew_Password text]])
        {
      
            
        NSString* encoded=[serv SHA_2:[RESET_New_Password text]];
            
        [serv postData:@{@"prop_id":identifier,@"prop_token":token,@"prop_new_pass":encoded} URL:Links[CHANGE_PASS] Code:^(id responseObject)
         {
             NSError *error;
             NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers  error:&error];
             
             NSString* err=[NSString stringWithFormat:@"%@",jsonArray[@"ERROR"]];
             
             if ([err isEqualToString:@"none"])
             {
                 //show success~
                 
                 //hide box~
                 [weakSelf fadeOutView:RESET_PASS_box
                  
                  done:^(void)
                  {
                      [LOG_Box setHidden:false];
                  }];
                 NSLog(@"Passwod reset!");
             }
             else
             {
                 NSLog(@"%@ %@",jsonArray[@"CODE"],jsonArray[@"ERROR"]);
                 
                 //show box
                 [weakSelf fadeInView:RESET_PASS_box done:^(void)
                 {
                     [RESET_Indicator setHidden:true];
                 }];
                 
                 //show error~
                 [RESET_Error setText:jsonArray[@"ERROR"]];
                 [RESET_Error setHidden:false];
     
                 
                 //hide box~
                 [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut
                 animations:^
                 {
                    RESET_PASS_box.alpha = 0.0;
                 }
                  
                 completion:^(BOOL finished)
                 {
                    [LOG_Box setHidden:false];
                    [RESET_Error setHidden:true];
                 }];
                 
                 //reset token
                 token=@"";
                 identifier=@"";
                 
                 NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                 [prefs setValue:@"" forKey:@"Reset_token"];
                 [prefs setValue:@"" forKey:@"identifier"];
             }
             
         }];
        }
        {
            //Different passwords
            [RESET_Error setHidden:false];
            [RESET_Error setText:@"Different passwords"];
            
            //hide progress~
            [RESET_PASS_box setAlpha:0.0f];
            [self fadeInView:RESET_PASS_box done:^(void){}];
            [RESET_Indicator setHidden:true];
            //hide progress~
        }
    }
    else
    {
        //Password must be at least 6 characters
        [RESET_Error setHidden:false];
        [RESET_Error setText:@"Password must be at least 6 characters"];
        
        
        //hide progress~
        [RESET_PASS_box setAlpha:0.0f];
        [self fadeInView:RESET_PASS_box done:^(void){}];
        [RESET_Indicator setHidden:true];
        //hide progress~
    }
}

#pragma mark -COOKIES
- (void)saveCookies:(NSString*)Cookies ID:(NSString*)_ID
{
    //Save cookies+++
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:Cookies forKey:@"Cookies"];
    [prefs setObject:_ID forKey:@"ID"];
    //Save cookies---
}

-(void)ClearCookies
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"none" forKey:@"Cookies"];
    [prefs setObject:@"none" forKey:@"ID"];
}
//COOKIES---


- (void)openHome
{
    //Open home page+++
    CGSize result = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [UIScreen mainScreen].scale;
    result = CGSizeMake(result.width * scale, result.height * scale);
    
    int h=floor(result.height);
    NSString* story_board=(h==960)?@"Main_iPhone4":@"Main";
    
    //story_board=@"Main_iPhone4";
    
    UIStoryboard *storyboard =[UIStoryboard storyboardWithName:story_board bundle:nil];
    HomeView=[storyboard instantiateViewControllerWithIdentifier:@"PROP_Home"];
    
    [self presentViewController:HomeView animated:YES completion:nil];
}

-(void)dealloc //temp
{
    //Free memory+++
    Logo_animation.animationImages=nil;
    Background.image=nil;
    //Free memory---
    NSLog(@"Dealocated!");
}

//Switching animation++++
- (void)PingAnimation //change to gif
{
   // Load images
   /* NSMutableArray* imageNames=[[NSMutableArray alloc] init];
    NSString* zero=nil;
    
    for (int i=0;i<24;i++)
    {
        zero=(i+1<10)?@"0":@"";
        
        [imageNames addObject:[NSString stringWithFormat:@"Ping_%@%i@2x",zero,i+1]];
    }
    
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++)
    {
        [images addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNames[i] ofType:@"png"]]];
     //   [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    //Normal Animation
    
    
    Logo_animation.animationImages =images;
    Logo_animation.animationDuration = 1.0;
    
    
    //[Logo_animation startAnimating];*/
}

//Resize++
- (void)resize:(UIView *)view CoeffW:(float)cw CoeffH:(float)ch
{
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return; // COUNT CHECK LINE
    
    for (UIView *subview in subviews)
    {
        // List the subviews of subview
        CGRect r=CGRectMake(subview.frame.origin.x*cw, subview.frame.origin.y*ch, subview.frame.size.width*cw, subview.frame.size.height*ch);
        
        [subview.layer setFrame:r];
        [self resize:subview CoeffW:cw CoeffH:ch];
    }
}



#pragma mark -LoadUsernames
- (void)save_into_logs:(NSString*)username
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableArray* list=[[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"logs"]];
    
    if (list!=nil)
    {
        bool add=true;
        for (int i=0;i<[list count];i++)
        {
            if([list[i] isEqualToString:username])
            {
                add=false;
            }
        }
        
        
        if (add)
        {
            [list addObject:username];
            [prefs setObject:list forKey:@"logs"];
        }
    }
    else
    {
        list=[NSMutableArray new];
        [list addObject:username];
        [prefs setObject:list forKey:@"logs"];
    }
}

- (IBAction)load_logs:(id)sender
{
    if (loaded_logs==false)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSArray* list=[prefs objectForKey:@"logs"];
    
        if (list!=nil)
        {
        //Create boxes with names+++
        for (int i=0;i<[list count];i++)
        {
            UIButton* name_box=[[UIButton alloc] initWithFrame:CGRectMake(0,i*(30-1), logs_list.frame.size.width, 30)];
            [name_box setBackgroundColor:[UIColor whiteColor]];
            name_box.layer.borderColor = rgb(240,240,240).CGColor;
            name_box.layer.borderWidth = 1.0f;
            [name_box setTitle:list[i] forState:UIControlStateNormal];
            [name_box.titleLabel setText:list[i]];
            name_box.font=[UIFont fontWithName:@"Quicksand-Regular" size:17.0];
            [name_box setTitleColor:rgb(74,93,111)/*rgb(208,213,219)*/ forState:UIControlStateNormal];
            [name_box addTarget:self action:@selector(setUsernameFromLogs:) forControlEvents:UIControlEventTouchDown];
          
            //Text alignment++
            name_box.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            name_box.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            
            [logs_list addSubview:name_box];
        }
        //Create boxes with names---
        
            UIImage* clear=[UIImage imageNamed:@"Clear@2x.png"];
            UIButton* clear_logs=[[UIButton alloc] initWithFrame:CGRectMake(0,[list count]*(30-1), logs_list.frame.size.width, 35)];
            
            [clear_logs setImage:clear forState:UIControlStateNormal];
            [clear_logs setTitle:@"" forState:UIControlStateNormal];
            [clear_logs addTarget:self action:@selector(clearLogs:) forControlEvents:UIControlEventTouchDown];
            
            [logs_list setBounces:false];
            [logs_list addSubview:clear_logs];
            [logs_list setContentSize:CGSizeMake(logs_list.frame.size.width, 30*[list count]+[clear size].height)];
            
            //show list+++
            [logs_list setFrame:CGRectMake(logs_list.frame.origin.x, logs_list.frame.origin.y, logs_list.frame.size.width, 0)];
            [logs_list setHidden:false];
            done_unroll=false;
            
            //Unfold list animation
            [UIView animateWithDuration:0.5f animations:^{
                CGRect theFrame = logs_list.frame;
                theFrame.size.height= 95.0f;
                logs_list.frame = theFrame;
            }
                             completion:^(BOOL finished)
             {
                 done_unroll=true;
             }];
            //show list---
            
        loaded_logs=true;
        }
    }
    else
    if (loaded_logs==true && done_unroll)
    {
        if ([logs_list isHidden]) //show
        {
            [logs_list setFrame:CGRectMake(logs_list.frame.origin.x, logs_list.frame.origin.y, logs_list.frame.size.width, 0)];
            [logs_list setHidden:false];
            done_unroll=false;
            
            //Unfold list animation
            [UIView animateWithDuration:0.5f animations:^{
                CGRect theFrame = logs_list.frame;
                theFrame.size.height= 95.0f;
                logs_list.frame = theFrame;
            }
            completion:^(BOOL finished)
             {
                 done_unroll=true;
             }];
            
        }
        else
        if (![logs_list isHidden]) //hide
        {
            done_unroll=false;
            [logs_list setFrame:CGRectMake(logs_list.frame.origin.x, logs_list.frame.origin.y, logs_list.frame.size.width, 95.0f)];
            [logs_list setHidden:false];
            
            //Fold list animation
            [UIView animateWithDuration:0.5f animations:^{
                CGRect theFrame = logs_list.frame;
                theFrame.size.height= 0.0f;
                logs_list.frame = theFrame;
            } completion:^(BOOL finished)
             {
                 done_unroll=true;
                 [logs_list setHidden:true];
             }];
        }
    }
}

- (IBAction)setUsernameFromLogs:(id)sender
{
    UIButton* button=(UIButton*)sender;
    [PROP_Email setText:button.titleLabel.text];
    [logs_list setHidden:true];
}

- (IBAction)clearLogs:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"logs"];
    
    
    [logs_list.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [logs_list setHidden:true];
    loaded_logs=false;
}
@end
