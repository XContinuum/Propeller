//
//  PROP_HomeView.h
//  Propeller
//
//  Created by Michel Balamou on 20/03/2015.
//  Copyright (c) 2015 Michel Balamou. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <SBJson4.h>

#import "Connection.h"


@interface PROP_HomeView : UIViewController <UIScrollViewDelegate>
{
    //HTTP+++
    NSString* URL;
    Connection* serv;
    
    bool refreshLimit;
    NSTimer* timer;
    
    NSArray* Links;
    
    NSString* cookies;
    NSString* ID;
    //HTTP---
    
    //Adjustment+++
    float maxWidth;
    bool resized_once;
    //Adjustment---
    
    
    //Home+++
    IBOutlet UIImageView* ref;
    
    NSMutableArray* HOME_Posts;
    int Last_Post_y;
    
    IBOutlet UIView* HOME_EDIT_box;
    IBOutlet UITextView* HOME_PostField;
    IBOutlet UIScrollView* HOME_Scroll;
    
    //Activate+++
    IBOutlet UIView* requestActivation;
    
    IBOutlet UIView* changeEmail;
    IBOutlet UITextField* new_email;
    
    //VIEWS+++
    IBOutlet UIView* HOME_view;
    IBOutlet UIView* MESSAGES_view;
    IBOutlet UIView* MAP_view;
    IBOutlet UIView* STATS_view;
    IBOutlet UIView* PROFILE_view;
}

- (IBAction)logOut:(id)sender; //temp

- (IBAction)WritePost:(id)sender;
- (IBAction)sencPostClick:(id)sender;

- (IBAction)cancelPost:(id)sender;


- (void)LoadPosts:(NSData*)Posts_content; //main
- (void)SendPost;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;


- (void)scrollViewDidScroll:(UIScrollView*)scrollView;
- (void)timeReload:(NSTimer *)timer;

- (IBAction)resendEmailActivation:(id)sender;
- (IBAction)changeEmail:(id)sender;

- (IBAction)cancelChangeEmail:(id)sender;
- (IBAction)changeEmail_true:(id)sender;

//Resize++
- (void)resize:(UIView *)view CoeffW:(float)cw CoeffH:(float)ch;

//Switch views
- (IBAction)home_btn:(id)sender;
- (IBAction)message_btn:(id)sender;
- (IBAction)map_btn:(id)sender;
- (IBAction)stats_btn:(id)sender;
- (IBAction)profile_btn:(id)sender;
@end
