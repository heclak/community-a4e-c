#ifndef GLOBALS_H
#define GLOBALS_H
#pragma once //globals r bad
#include <stdio.h>


extern FILE* g_log;

//Uncomment this to enable logging make sure this is commited with this commented out!!!!!!
//#define LOGGING

#ifdef LOGGING
#define LOG(s, ...) fprintf(g_log, s, __VA_ARGS__);
#else
#define LOG(s, ...) /*nothing*/
#endif


#endif
