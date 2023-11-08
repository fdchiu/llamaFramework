//
//  LlamaCpp.h
//  iOS Llama Example
//
//  Created by david Chiu on 10/31/23.
//

#import <Foundation/Foundation.h>

@protocol LlamaCppWrapperDelegate <NSObject>
 
- (void)replyEnd;
 
@end

@interface LlamaCppWrapper : NSObject {
    char* modelName;
    char* parameters[64];
}

@property(nonatomic, weak)id <LlamaCppWrapperDelegate> delegate;

- (void) loadModel: (const char*) modelName;

- (void)chat: (const char*)prompt  response:(void(^)(const char *))callback;// complete: (void(*)(void))func;

- (void) completionHnadlerMethod;
@end
