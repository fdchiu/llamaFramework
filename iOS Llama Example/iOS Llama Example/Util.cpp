//
//  GRTUtil.cpp
//  athena
//
//  Created by david Chiu on 3/21/22.
//  Copyright © 2022 Athena. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Util.h"
using namespace std;

char* getFilePath()
{
char* buffer = (char*)malloc(sizeof(char)*256);

//HOME is the home directory of your application
//points to the root of your sandbox
strcpy(buffer,getenv("HOME"));

//concatenating the path string returned from HOME
strcat(buffer,"/Documents");

    printf("path: %s\n", buffer);
    /*
//Creates an empty file for writing
FILE *f = fopen(buffer,"w");

//Writing something
fprintf(f, "%s %s %d", "Hello", "World", 2016);

//Closing the file
fclose(f);
     */
    return buffer;
}

char* getFileNameWithPath(const char* fileName) {
    char* name =  getFilePath();
    name = strcat(name,"/");
    return strcat(name, fileName);
}

