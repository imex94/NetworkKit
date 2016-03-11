//
//  AFAuth.h
//  OAuthTest
//
//  Created by Oliver Drobnik on 6/20/14.
//  Copyright (c) 2014 Cocoanetics. All rights reserved.
//

/**
 Controller for an OAuth 1.0a flow with 3 legs.
 
 1. Call -requestTokenWithCompletion: (leg 1)
 2. Get the -userTokenAuthorizationRequest and load it in webview, AFAuthWebViewController is provided for this (leg 2)
 3. Extract the verifier returned from the OAuth provider once the user authorizes the app, AFAuthWebViewController does that via delegate method.
 4. Call -authorizeTokenWithVerifier:completion: passing this verifier (leg 3)
 */
#import <Foundation/Foundation.h>


@interface AFAuthClient : NSObject

/**
 Dedicated initializer. Typically you register an application with service and from there you
 receive the consumer key and consumer secret.
 */
- (instancetype)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret;

/**
 @name Request Factory
 */

/**
 The initial request for a token
 */
- (NSURLRequest *)tokenRequest;

/**
 The second request to perform following -tokenRequest, you would load this request
 in a web view so that the user can authorize the app access.
 */
- (NSURLRequest *)userTokenAuthorizationRequest;

/**
 The third request to perform with the verifier value from -userTokenAuthorizationRequest.
 */
- (NSURLRequest *)tokenAuthorizationRequestWithVerifier:(NSString *)verifier;

/**
 Generates a signed OAuth Authorization header for a given request. Parameters encoded in the URL are included in the OAuth signature.
 */
- (NSString *)authenticationHeaderForRequest:(NSURLRequest *)request;

/**
 @name Performing Requests
 */

/**
 Perform the initial request for an OAuth token
 */
- (void)requestTokenWithCompletion:(void (^)(NSError *error))completion;

/**
 Perform the final request to verify a token after the user authorized the app
 */
- (void)authorizeTokenWithVerifier:(NSString *)verifier completion:(void (^)(NSError *error))completion;

/**
 @name Properties
 */

/** 
 The most recent token. You can use this to check the authorized token returned by the web view.
 @note This value is updated before the completion handler of one of the two requests.
 */
@property (nonatomic, readonly) NSString *token;


/**
 Returns yes if the bearer token was successfully exchanged for an authorization token
 */
@property (nonatomic, readonly, getter = isAuthenticated) BOOL authenticated;


#pragma mark - Endpoint URLs

/**
 The URL to request an OAuth token from
 */
@property (nonatomic, strong) NSURL *requestTokenURL;

/**
 The URL to open in a web view for authorizing a token
 */
@property (nonatomic, strong) NSURL *userAuthorizeURL;

/**
 The URL to verify an authorized token at
 */
@property (nonatomic, strong) NSURL *accessTokenURL;

@end
