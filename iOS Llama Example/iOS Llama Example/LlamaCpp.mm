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


int llama_main(int argc, char ** argv, void (*callback)(const char*));

using namespace std;

char* chatBuffer = nullptr;
const int MODEL_NAME_LENGTH = 512;

typedef void (^ llamaHandlerType)(const char*);
static llamaHandlerType _llamaHandler;

@implementation LlamaCppWrapper {
    NSMutableDictionary* classifiers;
}

-(void) loadModel: (const char*) modelName {
    self->modelName = (char*)malloc(sizeof(char)*MODEL_NAME_LENGTH);
    strcpy(self->modelName, modelName);
}

void  llamaCallback(const char* ret) {
    printf("%s", ret);
    strcat(chatBuffer, ret);
    _llamaHandler(chatBuffer);
    
}

- (void) chat: (const char*)prompt completion:(void (^)(const char *))callback {
    if(chatBuffer == nullptr) {
        chatBuffer = (char*)malloc(sizeof(char)*2048);
        chatBuffer[0] = NULL;
    } else {
        chatBuffer[0] = NULL;
    }
    _llamaHandler = [callback copy];
    char *args[10];
    std::string params[] = {" ./main", "-m", "-p"};
    const char args_const[][128]={"./main", "-m", "models/mistral-7b-instruct-v0.1.Q4_K_M.gguf", "-p", "what date is today", "-n", "-2", "-i", "-e"};
    int argc = 9 ;//sizeof(args_const);
    for(int i=0;i<argc;i++) {
        args[i] = (char*)malloc(sizeof(char)*128);
            if(i==2){
                strcpy(args[2], "models/");
                strcat(args[2], modelName);
            }
            if(i==3){
                strcpy(args[3], "-p");
            }
            if(i==4){
                strcpy(args[4], prompt);
            }
        else {
            strcpy(args[i], args_const[i]);
        }
    }
    //strcpy(args[4], "what date is today");

    //printf("%s", args[1]);
    llama_main(5, (char**)args, &llamaCallback);
}

@end

