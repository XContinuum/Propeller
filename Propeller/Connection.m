//
//  Connection.m
//  Propeller
//
//  Created by Michel Balamou on 19/03/2015.
//  Copyright (c) 2015 Michel Balamou. All rights reserved.
//

#import "Connection.h"
#import <CommonCrypto/CommonHMAC.h>

#define url(a,b) [NSString stringWithFormat:@"http://%@/%@",a,b]

@implementation Connection

-(id)init:(NSString*)_domain
{
    self=[super init];
    
    if (self)
    {
        domain=_domain;
    }
    
    return self;
}


-(NSString*)SHA_2:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}


-(NSString*)sendData:(NSString*)variables URL:(NSString*)page
{
    NSString* resultData=@"NONE_ERROR_0x1";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url(domain,page)]];
    
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"]; //original
    
    //Here you send your data
    [request setHTTPBody:[variables dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPMethod:@"POST"];
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error)
    {
        NSLog(@"HTTP: %@",error);
    }
    else
    {
        //The response is in data
        resultData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",resultData);
    }
    
    return resultData;
}

-(NSData*)sendData_data:(NSString*)variables URL:(NSString*)page
{
    NSString* resultData=@"NONE_ERROR_0x1";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url(domain,page)]];
    
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"]; //original
    
    //Here you send your data
    [request setHTTPBody:[variables dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPMethod:@"POST"];
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error)
    {
        NSLog(@"HTTP: %@", error);
    }
    else
    {
        //The response is in data
        resultData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",resultData);
    }
    
    return data;
}

-(NSData*)postData:(NSDictionary*)parameters URL:(NSString*)page Code:(void (^) (id))_code
{
    NSData* final;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    [manager POST:url(domain,page) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        _code(responseObject);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Error: %@", error);
    }];
  
    
    return final;
}


-(NSData*)postData:(NSDictionary*)parameters URL:(NSString*)page Code:(void (^) (id))_code Failure:(void (^) (void))_failure
{
    NSData* final;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager POST:url(domain,page) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         _code(responseObject);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         _failure();
     }];
    
    
    return final;
}

@end
