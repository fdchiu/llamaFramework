//
//  LlamaCpp.m
//  iOS Llama Example
//
//  Created by david Chiu on 10/31/23.
//

#import <Foundation/Foundation.h>
#import "LlamaCpp.h"
#include <stdio.h>
#include <string.h>
#include <string>


int llama_main(int argc, char ** argv, void (*callback)(const char*), void (*completion)(void));

using namespace std;

char* chatBuffer = nullptr;
const int MODEL_NAME_LENGTH = 1024;
const int CHAT_BUFFER_LENGTH = 10240; //10K BUFFER

typedef void (^ llamaHandlerType)(const char*);
static llamaHandlerType _llamaHandler;

static LlamaCppWrapper* wrapper;

@implementation LlamaCppWrapper {
    //void(*completionHandler)();
}

-(id)init {
    self = [super init];
    //completionHandler = [self completionHandlerMethod];
    wrapper = self;
    return self;
}

-(void) loadModel: (const char*) modelName {
    self->modelName = (char*)malloc(sizeof(char)*MODEL_NAME_LENGTH);
    strcpy(self->modelName, modelName);
}

void  llamaCallback(const char* ret) {
    printf("%s", ret);
    strncat(chatBuffer, ret, CHAT_BUFFER_LENGTH-strlen(chatBuffer)-1);
    _llamaHandler(chatBuffer);
    
}

void completionHandler() {
    [wrapper completionHnadlerMethod];
}

- (void) chat: (const char*)prompt response:(void (^)(const char *))callback { //complete: (void(*)(void))completionFunction;
    if(chatBuffer == nullptr) {
        chatBuffer = (char*)malloc(sizeof(char)*CHAT_BUFFER_LENGTH);
        chatBuffer[0] = NULL;
    } else {
        chatBuffer[0] = NULL;
    }
    _llamaHandler = [callback copy];
    char *args[10];
    std::string params[] = {" ./main", "-m", "-p"};
    const char args_const[][128]={"./main", "-m", "models/mistral-7b-instruct-v0.1.Q4_K_M.gguf", "-p", "what date is today", "-n", "-2", "-i", "-e", "--log-disable"};
    int argc = 10 ;//sizeof(args_const);
    for(int i=0;i<argc;i++) {
        if(i==2){
            if(modelName[0] != '/') {
                strcpy(args[2], "models/");
            }
            args[i] = (char*)malloc(sizeof(char)*(strlen(modelName)+1));
            strcat(args[i], modelName);
        }
        else if(i==3){
            args[i] = (char*)malloc(3*sizeof(char));
            strcpy(args[i], "-p");
        }
        else if(i==4){
            args[i] = (char*)malloc(sizeof(char)*(strlen(prompt)+1));
            strcpy(args[i], prompt);
        }
        else {
            args[i] = (char*)malloc(sizeof(char)*(strlen(args_const[i])+1));
            strcpy(args[i], args_const[i]);
        }
    }
    if(std::string(args[4]).empty()) {
        strcpy(args[4], "what date is today");
    }
    
    //printf("%s", args[1]);
    // this method does not work
    /*self->completionHandler = [self](void) {
        [self  completionHnadlerMethod];
    };*/
    
    int ret = llama_main(5, (char**)args, &llamaCallback, completionHandler);
    if(ret > 0) {
        [self->_delegate replyEnd];
    }
}

- (void) completionHnadlerMethod {
    [self->_delegate replyEnd];
}

@end

