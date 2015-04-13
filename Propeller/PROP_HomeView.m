//
//  PROP_HomeView.m
//  Propeller
//
//  Created by Michel Balamou on 20/03/2015.
//  Copyright (c) 2015 Michel Balamou. All rights reserved.
//


#import "PROP_HomeView.h"
#import "ViewController.h"

#define dev(a) [device isEqualToString:a]
#define rgb(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define GET_POSTS 0
#define POST 1
#define RESEND 2
#define CHANGE 3

#define QUICK_BOLD(s) [UIFont fontWithName:@"Quicksand-Bold" size:s]
#define QUICK_REG(s) [UIFont fontWithName:@"Quicksand-Regular" size:s]


#define ID_TO_STRING(a) [[NSString alloc] initWithData:a encoding:NSUTF8StringEncoding]

@implementation PROP_HomeView

- (void)viewDidLoad
{
    URL=@"howtopoo.com";
    serv=[[Connection alloc]init:URL];
    
    //Home+++
    Last_Post_y=0;
    
    //Layout
    [self setNeedsStatusBarAppearanceUpdate];
    
    maxWidth=self.view.bounds.size.width;
    maxWidth=HOME_EDIT_box.bounds.size.width; //or
    
    //Other
    HOME_Scroll.delegate = self;
    
    refreshLimit=false;
    timer=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timeReload:) userInfo:nil repeats:YES];
    
    //Links
    Links=@[@"Propeller_Interface/prop_get_posts.php",
            @"Propeller_Interface/prop_post.php",
            @"Propeller_Interface/email/prop_resend_verification.php",
            @"Propeller_Interface/email/prop_change_email.php"];
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    cookies=[prefs objectForKey:@"Cookies"];
    ID=[prefs objectForKey:@"ID"];
    
    
    resized_once=false;
}


//resize
- (void)viewDidLayoutSubviews
{
    //iPhone 5
    if (resized_once==false)
    {
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
        resized_once=true;
    }
    //iPhone 5
    
    //Refresh+++
    float refHeight=(maxWidth*[ref.image size].height)/[ref.image size].width;
    
    [ref.layer setFrame:CGRectMake(0, -refHeight, maxWidth, refHeight)];
    ref.contentMode=UIViewContentModeScaleToFill;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //self.view.window.rootViewController = self;
    
    //Load
    [serv postData:@{@"prop_cookies":cookies,@"prop_id":ID} URL:Links[GET_POSTS] Code:^(id responseObject)
     {
         NSString* result =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSLog(@"%@", result);
         
         [self LoadPosts:responseObject];
     }];
    //Load
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}







- (void)LoadPosts:(NSData*)Posts_content //CHECK
{
    serv=[[Connection alloc]init:URL];
    
    
    //Reading JSON+++
    if (Posts_content!=nil)
    {
        NSError *error;
        NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:Posts_content options:NSJSONReadingMutableContainers  error:&error];
        
        NSString* err=[NSString stringWithFormat:@"%@",[jsonArray objectForKey:@"ERROR"]];
        
        if ([err isEqualToString:@"none"])
        {
            //Delete Post Boxes+++
            for (int i=0;i<[HOME_Posts count];i++)
            {
                [HOME_Posts[i] setBackgroundColor:[UIColor redColor]];
                
                [HOME_Posts[i] setHidden:YES];
                [self.view bringSubviewToFront:HOME_Posts[i]];
                [HOME_Posts[i] removeFromSuperview];
            }
            //Delete Post Boxes---
            
            HOME_Posts=[NSMutableArray new];
            
            Last_Post_y=40;
            
            int post_height=430;
            
            NSArray* content_upload=[jsonArray objectForKey:@"CONTENT"];
            NSArray* username_upload=[jsonArray objectForKey:@"USERNAMES"];
            NSArray* time_upload=[jsonArray objectForKey:@"TIME"];
            
            int c=(int)[content_upload count];
            
            if (c>10)
                c=10;
            
            UIImage* bot=[UIImage imageNamed:@"Post_bottom@2x.png"];
            UIImage* profile=[UIImage imageNamed:@"Profile_pic@2x.png"];
            
     
            if (content_upload!=nil)
            {
                int totalHeight=0;
                
                for (int i=0;i<c;i++)
                {
                    UIView* box=[[UIView alloc]initWithFrame:CGRectMake(0, Last_Post_y, maxWidth, post_height)];
                    [box setBackgroundColor:[UIColor whiteColor]];
                    
                    //Profile pic
                    UIImageView* Profile_pic=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, [profile size].width,[profile size].height)];
                    Profile_pic.image=profile;
                    
                    [box addSubview:Profile_pic];
                    
                    //Username+++
                    UILabel* user_name=[[UILabel alloc]initWithFrame:CGRectMake(Profile_pic.frame.origin.x+profile.size.width+5, 10, 200, 30)];
                    user_name.numberOfLines=0;
                    [user_name setText:[NSString stringWithFormat:@"%@",username_upload[i]]];
                    [user_name setFont:QUICK_BOLD(16.0f)];
                    [user_name sizeToFit];
                    
                    [box addSubview:user_name];
                    //Username---
                    
                    //Text_content+++
                    UILabel* content=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, maxWidth-20, 400)];
                    content.numberOfLines=0;
                    [content setText:[NSString stringWithFormat:@"%@",content_upload[i]]];
                    [content setFont:QUICK_REG(16.0f)];
                    content.textAlignment=NSTextAlignmentJustified;
                    [content sizeToFit];
                    
                    [box addSubview:content];
                    //Text_content---
                    
                    
                    //Time_cont+++
                    UILabel* time_posted=[[UILabel alloc]initWithFrame:CGRectMake(200, 10, maxWidth, 400)];
                    time_posted.numberOfLines=0;
                    [time_posted setText:[NSString stringWithFormat:@"%@",time_upload[i]]];
                    [time_posted sizeToFit];
                    [time_posted setFont:QUICK_BOLD(15.0f)];
                    time_posted.textColor=rgb(200,200,200);
                    [time_posted.layer setFrame:CGRectMake(maxWidth-time_posted.frame.size.width-5, time_posted.frame.origin.y, time_posted.frame.size.width, time_posted.frame.size.height)];
                    
                    [box addSubview:time_posted];
                    //Time_cont---
                    
                    //Post_bottom+++
                    float h=(maxWidth*[bot size].height)/[bot size].width;
                    float newHeight=content.frame.origin.y+content.frame.size.height+20+h;
                    
                    UIImageView* bottom=[[UIImageView alloc] initWithFrame:CGRectMake(0, newHeight-h, maxWidth,h)];
                    bottom.image=bot;
                    
                    
                    [box addSubview:bottom];
                    box.contentMode=UIViewContentModeScaleToFill;
                    //Post_bottom---
                    
                    [box.layer setFrame:CGRectMake(0, Last_Post_y+20, maxWidth, newHeight)];
                    [HOME_Posts addObject:box];
                    Last_Post_y+=newHeight;
                    
                    totalHeight=Last_Post_y;
                }
                
                
                
                for (int i=0;i<[HOME_Posts count];i++)
                    [HOME_Scroll addSubview:HOME_Posts[i]];
                
                
                [HOME_Scroll setContentSize:CGSizeMake(maxWidth, totalHeight)];
            }
        }
        else
        {
            NSLog(@"%@",[jsonArray objectForKey:@"ERROR"]);
        }
        
    }
    //Reading JSON---
    

}


-(void)SendPost //CHECK
{
    if ([[HOME_PostField text] length]>0)
    {
        //++++
        serv=[[Connection alloc] init:URL];
        
        [serv postData:@{@"prop_cookies":cookies,@"prop_id":ID,@"prop_content":[HOME_PostField text]} URL:Links[POST] Code:^(id responseObject)
         {
             NSError *error;
             NSMutableDictionary *jsonArray=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers  error:&error];
             
             NSString* err=[NSString stringWithFormat:@"%@",[jsonArray objectForKey:@"ERROR"]];
             
             if ([err isEqualToString:@"none"])
             {
                 NSLog(@"Success");
             }
             else
             {
                 NSLog(@"%@",[jsonArray objectForKey:@"ERROR"]);
             }

         }];
         
         
         [HOME_EDIT_box setHidden:true];
         HOME_PostField.text=@"";
         [HOME_PostField resignFirstResponder];
    }
}



- (IBAction)WritePost:(id)sender
{
    [HOME_EDIT_box setHidden:false];
}

- (IBAction)sencPostClick:(id)sender
{
    [self SendPost];
}



- (IBAction)logOut:(id)sender; //Temp
{
    [self ClearCookies];
    
    UIStoryboard *storyboard = self.storyboard;
    ViewController* MainView=[storyboard instantiateViewControllerWithIdentifier:@"PROP_Main"];
    
    [self.view.window.rootViewController presentViewController:MainView animated:YES completion:nil];
    
    //[self presentViewController:MainView animated:YES completion:nil];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([HOME_PostField isFirstResponder] && [touch view] != HOME_PostField)
        [HOME_PostField resignFirstResponder];
    
    [super touchesBegan:touches withEvent:event];
}


- (IBAction)cancelPost:(id)sender
{
    [HOME_PostField setText:@"Content"];
    [HOME_EDIT_box setHidden:true];
    
    [HOME_PostField resignFirstResponder];
}


-(void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (scrollView.contentOffset.y < -60 && refreshLimit==false)
    {
        NSLog(@"Refresh");
        
        [serv postData:@{@"prop_cookies":cookies,@"prop_id":ID} URL:Links[GET_POSTS] Code:^(id responseObject)
         {
             NSString* result =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             NSLog(@"%@", result);
            
            [self LoadPosts:responseObject];
         }];
        
        
        refreshLimit = true;
    }
}

- (void)timeReload:(NSTimer *)timer
{
    refreshLimit=false;
}



- (IBAction)resendEmailActivation:(id)sender
{
    serv=[[Connection alloc]init:URL];
    
    [serv postData:@{@"prop_cookies":cookies,@"prop_id":ID} URL:Links[RESEND] Code:^(id responseObject)
     {
         NSLog(@"%@",ID_TO_STRING(responseObject));
     }];
}

- (IBAction)changeEmail:(id)sender
{
    [changeEmail setHidden:false];
}

- (IBAction)cancelChangeEmail:(id)sender
{
    [changeEmail setHidden:true];
}

- (IBAction)changeEmail_true:(id)sender
{
    serv=[[Connection alloc]init:URL];
    
    [serv postData:@{@"prop_cookies":cookies,@"prop_id":ID,@"prop_email":[new_email text]} URL:Links[CHANGE] Code:^(id responseObject)
     {
         NSLog(@"Changed");
     }];
    
    [changeEmail setHidden:true];
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

//Switch views
- (IBAction)home_btn:(id)sender
{
    [HOME_view setHidden:false];
    [MESSAGES_view setHidden:true];
    [MAP_view setHidden:true];
    [STATS_view setHidden:true];
    [PROFILE_view setHidden:true];
}
- (IBAction)message_btn:(id)sender
{
    [HOME_view setHidden:true];
    [MESSAGES_view setHidden:false];
    [MAP_view setHidden:true];
    [STATS_view setHidden:true];
    [PROFILE_view setHidden:true];
}
- (IBAction)map_btn:(id)sender
{
    [HOME_view setHidden:true];
    [MESSAGES_view setHidden:true];
    [MAP_view setHidden:false];
    [STATS_view setHidden:true];
    [PROFILE_view setHidden:true];
}
- (IBAction)stats_btn:(id)sender
{
    [HOME_view setHidden:true];
    [MESSAGES_view setHidden:true];
    [MAP_view setHidden:true];
    [STATS_view setHidden:false];
    [PROFILE_view setHidden:true];
}
- (IBAction)profile_btn:(id)sender
{
    [HOME_view setHidden:true];
    [MESSAGES_view setHidden:true];
    [MAP_view setHidden:true];
    [STATS_view setHidden:true];
    [PROFILE_view setHidden:false];
}


//Other+++
- (void)dealloc
{
    NSLog(@"Deallocated! 2");
}


-(void)ClearCookies
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"none" forKey:@"Cookies"];
    [prefs setObject:@"none" forKey:@"ID"];
    
    cookies=@"none";
    ID=@"none";
}
@end
