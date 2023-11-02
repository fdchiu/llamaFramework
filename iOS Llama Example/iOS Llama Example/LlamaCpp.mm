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


int llama_main(int argc, char ** argv);

using namespace std;

@implementation LlamaCpp {
    NSMutableDictionary* classifiers;
        
}


+ (void) start: (const char*)prompt{
    char *args[10];
    const char args_const[6][128]={" ./main", "-m", "models/mistral-7b-instruct-v0.1.Q4_K_M.gguf", "-p", "what date is today", "-e"};
    for(int i=0;i<6;i++) {
        args[i] = (char*)malloc(sizeof(char)*128);
        strcpy(args[i], args_const[i]);
    }
    //strcpy(args[4], "what date is today");

    printf("%s", args[1]);
    llama_main(5, (char**)args);
}

@end

