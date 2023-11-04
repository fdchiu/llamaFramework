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


int llama_main(int argc, char ** argv, void (*callback)(const char*));

using namespace std;

char* chatBuffer = nullptr;

typedef void (^ llamaHandlerType)(const char*);
static llamaHandlerType _llamaHandler;

@implementation LlamaCpp {
    NSMutableDictionary* classifiers;
}

void  llamaCallback(const char* ret) {
    printf("%s", ret);
    strcat(chatBuffer, ret);
    _llamaHandler(chatBuffer);
    
}

+ (void) start: (const char*)prompt completion:(void (^)(const char *))callback {
    if(chatBuffer == nullptr) {
        chatBuffer = (char*)malloc(sizeof(char)*2048);
        chatBuffer[0] = NULL;
    } else {
        chatBuffer[0] = NULL;
    }
    _llamaHandler = [callback copy];
    char *args[10];
    const char args_const[6][128]={" ./main", "-m", "models/mistral-7b-instruct-v0.1.Q4_K_M.gguf", "-p", "what date is today", "-e"};
    for(int i=0;i<6;i++) {
        args[i] = (char*)malloc(sizeof(char)*128);
        strcpy(args[i], args_const[i]);
    }
    //strcpy(args[4], "what date is today");

    printf("%s", args[1]);
    llama_main(5, (char**)args, &llamaCallback);
}

@end

