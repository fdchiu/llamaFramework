//
//  LlamaCpp.h
//  iOS Llama Example
//
//  Created by david Chiu on 10/31/23.
//

#import <Foundation/Foundation.h>

@interface LlamaCpp : NSObject {
}
+ (void)start: (const char*)prompt completion:(void(^)(const char *))callback;

@end
