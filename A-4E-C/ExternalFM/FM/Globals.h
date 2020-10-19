#pragma once //globals r bad
#ifndef GLOBALS_H
#define GLOBALS_H
#include <stdio.h>

extern FILE* g_log;
extern int g_safeToRun;
extern bool g_logging;

extern int isSafeContext();

#define DEBUG_CONSOLE

//Uncomment this to enable logging make sure this is commited with this commented out!!!!!!
#define LOGGING

#ifdef LOGGING
#define LOG(s, ...) if ( g_log ) fprintf(g_log, s, __VA_ARGS__);
#else
#define LOG(s, ...) /*nothing*/
#endif

#define LOG_BREAK() LOG("===================\n")

#endif
