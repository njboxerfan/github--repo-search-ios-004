//
//  FISReposDataStore.m
//  github-repo-list
//
//  Created by Joe Burgess on 5/5/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISReposDataStore.h"
#import "FISGithubAPIClient.h"
#import "FISGithubRepository.h"

@implementation FISReposDataStore

+ (instancetype)sharedDataStore {
    static FISReposDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[FISReposDataStore alloc] init];
    });

    return _sharedDataStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _repositories=[NSMutableArray new];
    }
    return self;
}

-(void)getRepositoriesWithCompletion:(void (^)(BOOL))completionBlock
{
    [FISGithubAPIClient getRepositoriesWithCompletion:^(NSArray *repoDictionaries) {
        for (NSDictionary *repoDictionary in repoDictionaries) {
            [self.repositories addObject:[FISGithubRepository repoFromDictionary:repoDictionary]];
        }
        completionBlock(YES);
    }];
}

- (void)checkIfRepoIsStarredWithFullName:(NSString *)fullName CompletionBlock:(void (^)(BOOL))completionBlock
{
    [FISGithubAPIClient checkIfRepoIsStarredWithFullName:fullName CompletionBlock:^(BOOL starred) {
        
        completionBlock(starred);
    }];
}

- (void)toggleStarForRepo:(FISGithubRepository *)repo CompletionBlock:(void (^)(BOOL))completionBlock
{
    [self checkIfRepoIsStarredWithFullName:repo.fullName CompletionBlock:^(BOOL starred) {
        
        if ( starred )
        {
            [FISGithubAPIClient unstarRepoWithFullName:repo.fullName CompletionBlock:^{
                completionBlock(NO);
            }];
        }
        else
        {
            [FISGithubAPIClient starRepoWithFullName:repo.fullName CompletionBlock:^{
                completionBlock(YES);
            }];
        }
    }];
}

-(void)searchForReposUsingCriteria:(NSString *)searchCriteria CompletionBlock:(void (^)(BOOL))completionBlock
{
    [FISGithubAPIClient searchForReposUsingCriteria:searchCriteria CompletionBlock:^(NSArray *repoDictionaries) {

        [self.repositories removeAllObjects];
        
        for (NSDictionary *repoDictionary in repoDictionaries) {
            [self.repositories addObject:[FISGithubRepository repoFromDictionary:repoDictionary]];
        }
        completionBlock(YES);
    }];
}

@end
