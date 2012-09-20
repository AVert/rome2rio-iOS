//
//  R2RConnection.m
//  HttpRequest
//
//  Created by Ash Verdoorn on 30/08/12.
//  Copyright (c) 2012 Ash Verdoorn. All rights reserved.
//

#import "R2RConnection.h"
#import "R2RPlace.h"

@interface R2RConnection()

@property (strong, nonatomic) NSURLConnection *connection;

@end    

@implementation R2RConnection

@synthesize responseData, connection, delegate;

-(id) initWithConnectionUrl:(NSURL *)connectionUrl delegate:(id<R2RConnectionDelegate>)r2rConnectionDelegate
{
    self = [super init];
    
    if (self != nil)
    {
        
        self.delegate = r2rConnectionDelegate;
        
        self.responseData = [NSMutableData data];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:connectionUrl];
        
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
    }
    
    return self;
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}	

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog(@"Connection failed: %@", [error localizedDescription]);
    
    [[self delegate] R2RConnectionError:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    //Is anyone listening
    //if([delegate respondsToSelector:@selector(connectionDidFinishLoading:)])
    //{
        
        [[self delegate] R2RConnectionProcessData:self];
    
    //}
}


@end
