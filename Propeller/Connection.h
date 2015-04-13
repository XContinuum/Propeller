//
//  Connection.h
//  Propeller
//
//  Created by Michel Balamou on 19/03/2015.
//  Copyright (c) 2015 Michel Balamou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPRequestOperation.h>


@interface Connection:NSObject <NSURLConnectionDataDelegate>
{
    NSString* domain;
}
-(id)init:(NSString*)_domain;

-(NSString*)SHA_2:(NSString*)input;

-(NSString*)sendData:(NSString*)variables URL:(NSString*)page;
-(NSData*)sendData_data:(NSString*)variables URL:(NSString*)page;



-(NSData*)postData:(NSDictionary*)parameters URL:(NSString*)page Code:(void (^) (id))_code;
-(NSData*)postData:(NSDictionary*)parameters URL:(NSString*)page Code:(void (^) (id))_code Failure:(void (^) (void))_failure;
@end
