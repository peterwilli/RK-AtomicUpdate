//
//  RKObjectManager+AtomicUpdate.m
//  i54ops
//
//  Created by Peter Willemsen on 5/14/13.
//  Copyright (c) 2013 CodeBuffet. All rights reserved.
//

#import "RKObjectManager+AtomicUpdate.h"

@implementation RKObjectManager (AtomicUpdate)

NSArray *updateForceKeys_;

- (void) atomicPatchObject:(NSManagedObject*)object path:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    RKObjectRequestOperation *operation = [self appropriateObjectRequestOperationWithObject:object method:RKRequestMethodPATCH path:path parameters:nil];
    NSDictionary *changedValues = object.changedValues;
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.request.HTTPBody options:0 error:&error];
    NSMutableDictionary *RKParameters = [json mutableCopy];
    for (NSString *key in json) {
        if (![self.updateForceKeys containsObject:key]) {
            if (!changedValues[key]) {
                [RKParameters removeObjectForKey:key];
            }
        }
    }
    NSLog(@"New RK Parameters: %@", RKParameters);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:RKParameters
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSMutableURLRequest *mutableRequest = operation.HTTPRequestOperation.request.mutableCopy;
    mutableRequest.HTTPBody = jsonData;
    AFHTTPRequestOperation *AFOperation = [[AFHTTPRequestOperation alloc] initWithRequest:mutableRequest];
    [AFOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation_, id responseObject) {
        success(operation_);
    } failure:^(AFHTTPRequestOperation *operation_, NSError *error) {
        failure(operation_, error);
    }];
    [AFOperation start];
}

- (void) setUpdateForceKeys:(NSArray *)updateForceKeys
{
    updateForceKeys_ = updateForceKeys;
}

- (NSArray*) updateForceKeys
{
    return updateForceKeys_;
}

@end
