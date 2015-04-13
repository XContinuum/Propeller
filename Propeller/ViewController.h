//
//  ViewController.h
//  Propeller
//
//  Created by Michel Balamou on 18/03/2015.
//  Copyright (c) 2015 Michel Balamou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "PROP_HomeView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController
{
    //Reset
    BOOL resetting;
    NSString* token;
    NSString* identifier;
    //Layout
    bool resized_once;
    
    //HTTP+++
    NSString* URL;
    Connection* serv;
    
    NSArray* Links;
    
    NSString* cookies;
    NSString* ID;
    //HTTP---
    
    
    //HOME
    PROP_HomeView* HomeView;
    
    float maxWidth;
    
    //Log accounts
    bool loaded_logs;
    bool done_unroll;
}

//Free memory+++
@property (nonatomic,weak) IBOutlet UIImageView* Background;
//---

@property (nonatomic,weak) IBOutlet UIImageView* Err_Internet;

//Logo+++
@property (nonatomic,weak) IBOutlet UIImageView* Logo_animation;

//Login+++
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView* indicator;

@property (nonatomic,weak) IBOutlet UIView* LOG_Box;

@property (nonatomic,weak) IBOutlet UILabel* PROP_Error_msg;

@property (nonatomic,weak) IBOutlet UITextField* PROP_Email;
@property (nonatomic,weak) IBOutlet UITextField* PROP_Pass;
//Login---

//Register+++
@property (nonatomic,weak) IBOutlet UIView* REG_Box;

@property (nonatomic,weak) IBOutlet UILabel* REG_Error_msg;

@property (nonatomic,weak) IBOutlet UITextField* REG_Email;
@property (nonatomic,weak) IBOutlet UITextField* REG_Username;
@property (nonatomic,weak) IBOutlet UITextField* REG_Pass;
@property (nonatomic,weak) IBOutlet UITextField* REG_Pass_Con;
//Register---

//Fraud+++
@property (nonatomic,weak) IBOutlet UIView* Fraud_Box;
//Fraud---

//Load previous usernames+++
@property (nonatomic,weak) IBOutlet UIScrollView* logs_list;
//Load previous usernames---

//Forget pass+++
@property (nonatomic,weak) IBOutlet UIView* FORGET_Box;
@property (nonatomic,weak) IBOutlet UITextField* FORGET_Email;

@property (nonatomic,weak) IBOutlet UIView* FORGET_MAIN_box;
    //0x10
    @property (nonatomic,weak) IBOutlet UIView* FORGET_0x10;
    @property (nonatomic,weak) IBOutlet UITextField* FORGET0_ReEmail; //re_ender_email

    //User box
    @property (nonatomic,weak) IBOutlet UIView* FORGET_UserBox;
    @property (nonatomic,weak) IBOutlet UILabel* FORGET_DisplayUsername;
    @property (nonatomic,weak) IBOutlet UITextField* FORGET_Email_Target;

    //Email box
    @property (nonatomic,weak) IBOutlet UIView* FORGET_EmailFound_Box;
    @property (nonatomic,weak) IBOutlet UILabel* FORGET_SHOW_TARGET_em;

    //Success
    @property (nonatomic,weak) IBOutlet UIImageView* FORGET_Success;
//Forget pass---

//Reset pass+++
@property (nonatomic,weak) IBOutlet UIView* RESET_PASS_box;

@property (nonatomic,weak) IBOutlet UITextField* RESET_New_Password;
@property (nonatomic,weak) IBOutlet UITextField* RESET_ConfirmNew_Password;
@property (nonatomic,weak) IBOutlet UILabel* RESET_Error;
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView* RESET_Indicator;
//Reset pass---


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)hideKeyboard:(UITextField*)_textField Touch:(UITouch*)touch;

//Internet+++
- (BOOL)isInternetOn;

//HTTP action+++
- (void)fadeOutLabel:(UILabel*)labelAnim;
- (void)fadeOutView:(UIView*)viewAnim; //hide UIView
- (void)fadeOutView:(UIView*)viewAnim done:(void (^) (void))_code; //hide UIView
- (void)fadeInView:(UIView*)viewAnim done:(void (^) (void))_code; //show UIView

- (IBAction)login:(id)sender;
- (IBAction)regtr:(id)sender;
- (IBAction)cancel_fraud_alert:(id)sender;

//FORGET+++++++++++++++++++++++++++++++
- (void)SearchForInfo:(NSString*)info Hide:(BOOL)hide;
- (void)submitEmailToReset:(NSString*)email;


- (IBAction)forget:(id)sender; //Search for email/username to reset pass

//0x10
- (IBAction)cancel_forget_pass:(id)sender; //dissmiss FORGET_BOX
- (IBAction)forget_search:(id)sender; //click to research your email/username to reset pass

//User box+++
- (IBAction)for_submit_email:(id)sender;
- (IBAction)for_cancel:(id)sender;
- (IBAction)not_my_account:(id)sender;

//Email confirmed+++
- (IBAction)for_submit:(id)sender;
- (IBAction)for_cancel_email:(id)sender;
//FORGET------------------------------------


//Reset password+++
- (void)openReset;
- (IBAction)cancelReseting:(id)sender;
- (IBAction)resetPassword:(id)sender; //HTTP
//Reset passsword---


- (void)saveCookies:(NSString*)Cookies ID:(NSString*)_ID;
- (void)ClearCookies;

//Autentication+++
- (void)openHome;
- (void)checkCookies;

//Switching animation+++
- (IBAction)switch_Reg:(id)sender;
- (IBAction)switch_Log:(id)sender;
- (IBAction)switch_Forget:(id)sender;

- (void)PingAnimation;

//Resize+++
- (void)resize:(UIView *)view CoeffW:(float)cw CoeffH:(float)ch;

//Load previous usernames+++
- (void)save_into_logs:(NSString*)username;
- (IBAction)load_logs:(id)sender;

- (IBAction)setUsernameFromLogs:(id)sender;
- (IBAction)clearLogs:(id)sender;
@end


