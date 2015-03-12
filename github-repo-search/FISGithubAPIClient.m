//
//  FISGithubAPIClient.m
//  github-repo-list
//
//  Created by Joe Burgess on 5/5/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISGithubAPIClient.h"
#import "FISConstants.h"
#import <AFNetworking.h>

@implementation FISGithubAPIClient
NSString *const GITHUB_API_URL=@"https://api.github.com";

+(void)getRepositoriesWithCompletion:(void (^)(NSArray *))completionBlock
{
    NSString *githubURL = [NSString stringWithFormat:@"%@/repositories?client_id=%@&client_secret=%@",GITHUB_API_URL,GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager GET:githubURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
    }];
}

+(void)checkIfRepoIsStarredWithFullName:(NSString *)fullName CompletionBlock:(void (^)(BOOL))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.github.com/user/starred/%@?access_token=430c69abcf737ba32574671b0fdb6e24b5aab3b1",fullName];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock(YES);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(NO);
    }];
}

+(void)starRepoWithFullName:(NSString *)fullName CompletionBlock:(void (^)())completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.github.com/user/starred/%@?access_token=430c69abcf737ba32574671b0fdb6e24b5aab3b1",fullName];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager PUT:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock();
    }];
}

+(void)unstarRepoWithFullName:(NSString *)fullName CompletionBlock:(void (^)())completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.github.com/user/starred/%@?access_token=430c69abcf737ba32574671b0fdb6e24b5aab3b1",fullName];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager DELETE:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock();
    }];
}

+(void)searchForReposUsingCriteria:(NSString *)searchCriteria CompletionBlock:(void (^)(NSArray *))completionBlock
{
    NSString *escapedSearchCriteria = [searchCriteria stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@&access_token=430c69abcf737ba32574671b0fdb6e24b5aab3b1",escapedSearchCriteria];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *repoDictionary = responseObject;
        NSArray *repoArray = repoDictionary[@"items"];
        
        completionBlock(repoArray);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
    }];
}

@end
