//
//  NSDictionary+KCBJSONString.h
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (KCBJSONString)

- (NSString *)jsonStringWithPrettyPrint:(BOOL)prettyPrint;

@end

