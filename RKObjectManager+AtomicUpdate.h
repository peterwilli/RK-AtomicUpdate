//
//  RKObjectManager+AtomicUpdate.h
//  i54ops
//
//  Created by Peter Willemsen on 5/14/13.
//  Copyright (c) 2013 CodeBuffet. All rights reserved.
//

#import <RestKit/RestKit.h>

@interface RKObjectManager (AtomicUpdate)

@property (nonatomic, retain) NSArray *updateForceKeys;

- (void) atomicPatchObject:(NSManagedObject*)object path:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

@end
