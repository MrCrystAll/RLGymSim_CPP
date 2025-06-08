#pragma once

#define RS_DONT_LOG // Prevent annoying log spam
#include "RocketSim.h"
#include "Sim/GameEventTracker/GameEventTracker.h"

// Use RocketSim namespace
using namespace RocketSim;

#if defined(_MSC_VER)
// MSVC
#define RG_EXPORTED __declspec(dllexport)
#define RG_IMPORTED __declspec(dllimport)
#else
// Everything else (?)
#define RG_EXPORTED __attribute__((visibility("default")))
#define RG_IMPORTED
#endif

#ifdef WITHIN_RLGSC
#define RG_IMEXPORT RG_EXPORTED
#else
#define RG_IMEXPORT RG_IMPORTED
#endif

// Define our own log
#define RG_LOG(s) { std::cout << s << std::endl; }

#define RG_NO_COPY(className) \
className(const className&) = delete;  \
className& operator= (const className&) = delete

#define RG_ERR_CLOSE(s) { \
std::string _errorStr = RS_STR("RG FATAL ERROR: " << s); \
RG_LOG(_errorStr); \
throw std::runtime_error(_errorStr); \
exit(EXIT_FAILURE); \
}

#ifndef RG_UNSAFE
#define RG_ASSERT(cond) { if (!(cond)) { RG_ERR_CLOSE("Assertion failed: " << #cond); } }
#else
#define RG_ASSERT(cond) {}
#endif

#ifdef RG_PARANOID_MODE
#define RG_PARA_ASSERT(cond) RG_ASSERT(cond)
#else
#define RG_PARA_ASSERT(cond) {}
#endif