/*
 * TRString.h vi:ts=4:sw=4:expandtab:
 * Brain-dead Dynamic Strings
 *
 * Copyright (c) 2005 - 2007 Landon Fuller <landonf@threerings.net>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of Landon Fuller nor the names of any contributors
 *    may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#ifdef HAVE_CONFIG_H
#import <config.h>
#endif

#import <stdlib.h>

#import "TRObject.h"

@interface TRString : TRObject {
@private
    char *bytes;
    size_t numBytes;
}

+ (TRString *) stringWithFormat: (const char *) format, ...;
+ (TRString *) stringWithCString: (const char *) cString;

- (id) initWithFormat: (const char *) format arguments: (va_list) arguments;
- (id) initWithCString: (const char *) cString;
- (id) initWithString: (TRString *) string;
- (id) initWithBytes: (const char *) data numBytes: (size_t) length;

- (const char *) cString;
- (size_t) length;

- (BOOL) intValue: (int *) value;

- (size_t) indexToCString: (const char *) cString;
- (size_t) indexToCharset: (const char *) cString;

- (char) charAtIndex: (size_t) index;
- (TRString *) substringToIndex: (size_t) index;
- (TRString *) substringFromIndex: (size_t) index;
- (TRString *) substringToCString: (const char *) cString;
- (TRString *) substringFromCString: (const char *) cString;
- (TRString *) substringToCharset: (const char *) cString;
- (TRString *) substringFromCharset: (const char *) cString;

- (void) appendChar: (char) c;
- (void) appendCString: (const char *) cString;
- (void) appendString: (TRString *) string;

@end
