//
//  RustLib.h
//  FulliOS
//
//  Created by Yassine Lafryhi on 31/7/2024.
//

#ifndef RustLib_h
#define RustLib_h

#include <stdint.h>

int64_t count_words(const char* text);
int64_t count_characters(const char* text);
double simple_sentiment_analysis(const char* text);

#endif /* RustLib_h */
