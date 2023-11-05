//
//  LlamaCpp.h
//  iOS Llama Example
//
//  Created by david Chiu on 10/31/23.
//

#import <Foundation/Foundation.h>

@interface LlamaCppWrapper : NSObject {
    char* modelName;
    char* parameters[64];
}
- (void) loadModel: (const char*) modelName;

- (void)chat: (const char*)prompt completion:(void(^)(const char *))callback;

@end
