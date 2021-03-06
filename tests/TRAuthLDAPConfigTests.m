/*
 * TRAuthLDAPConfig.m vi:ts=4:sw=4:expandtab:
 * TRAuthLDAPConfig Unit Tests
 *
 * Author: Landon Fuller <landonf@threerings.net>
 *
 * Copyright (c) 2006 Three Rings Design, Inc.
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

#import <string.h>

#import "PXTestCase.h"
#import "TRAuthLDAPConfig.h"

#import "tests.h"

/* Data Constants */
#define TEST_LDAP_URL    "ldap://ldap1.example.org"
#define TEST_LDAP_TIMEOUT    15
#define TEST_LDAP_BASEDN "ou=People,dc=example,dc=com"

@interface TRAuthLDAPConfigTests : PXTestCase @end

@implementation TRAuthLDAPConfigTests

- (void) test_initWithConfigFile {
    TRAuthLDAPConfig *config;
    TRString *string;

    config = [[TRAuthLDAPConfig alloc] initWithConfigFile: AUTH_LDAP_CONF];
    fail_if(config == NULL, "-[[TRAuthLDAPConfig alloc] initWithConfigFile:] returned NULL");

    /* Validate the parsed settings */
    string = [config url];
    fail_if(!string, "-[TRAuthLDAPConfig url] returned NULL");
    fail_unless(strcmp([string cString], TEST_LDAP_URL) == 0, "-[TRAuthLDAPConfig url] returned incorrect value. (Expected %s, Got %s)", TEST_LDAP_URL, [string cString]);

    fail_unless([config timeout] == TEST_LDAP_TIMEOUT);

    fail_unless([config tlsEnabled]);

    fail_if([config ldapGroups] == nil);
    fail_if([[config ldapGroups] lastObject] == nil);

#ifdef HAVE_PF
    fail_unless([config pfEnabled]);
#endif

    [config release];
}

- (void) test_initWithIncorrectlyNamedSection {
    TRAuthLDAPConfig *config;

    config = [[TRAuthLDAPConfig alloc] initWithConfigFile: AUTH_LDAP_CONF_NAMED];
    fail_if(config != NULL, "-[[TRAuthLDAPConfig alloc] initWithConfigFile:] accepted a named LDAP section.");

    [config release];
}

- (void) test_initWithMismatchedSection {
    TRAuthLDAPConfig *config;

    config = [[TRAuthLDAPConfig alloc] initWithConfigFile: AUTH_LDAP_CONF_MISMATCHED];
    fail_if(config != NULL, "-[[TRAuthLDAPConfig alloc] initWithConfigFile:] accepted a mismatched section closure.");

    [config release];
}

- (void) test_initWithDuplicateKeys {
    TRAuthLDAPConfig *config;

    config = [[TRAuthLDAPConfig alloc] initWithConfigFile: AUTH_LDAP_CONF_MULTIKEY];
    fail_if(config != NULL, "-[[TRAuthLDAPConfig alloc] initWithConfigFile:] accepted duplicate keys.");

    [config release];
}

- (void) test_initWithMissingKey {
    TRAuthLDAPConfig *config;

    config = [[TRAuthLDAPConfig alloc] initWithConfigFile: AUTH_LDAP_CONF_REQUIRED];
    fail_if(config != NULL, "-[[TRAuthLDAPConfig alloc] initWithConfigFile:] accepted a missing required key.");

    [config release];
}

- (void) test_initWithMissingTrailingNewline {
    TRAuthLDAPConfig *config;
    TRString *baseDN;

    config = [[TRAuthLDAPConfig alloc] initWithConfigFile: AUTH_LDAP_CONF_MISSING_NEWLINE];
    fail_if(config == NULL, "-[[TRAuthLDAPConfig alloc] initWithConfigFile:] did not parse a file missing a trailing newline");

    /* Verify that the final section was parsed */
    baseDN = [config baseDN];
    fail_unless(strcmp([baseDN cString], TEST_LDAP_BASEDN) == 0, "-[TRAuthLDAPConfig baseDN] returned incorrect value (got '%s', expected '%s')", [[config baseDN] cString], TEST_LDAP_BASEDN);
    
    [config release];
}

- (void) test_initWithBadSection {
    TRAuthLDAPConfig *config;

    config = [[TRAuthLDAPConfig alloc] initWithConfigFile: AUTH_LDAP_CONF_BAD_SECTION];
    fail_if(config != NULL, "-[[TRAuthLDAPConfig alloc] initWithConfigFile:] accepted an invalid section.");

}

@end
