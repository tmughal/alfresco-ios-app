/*******************************************************************************
 * Copyright (C) 2005-2014 Alfresco Software Limited.
 * 
 * This file is part of the Alfresco Mobile iOS App.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *  
 *  http://www.apache.org/licenses/LICENSE-2.0
 * 
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 ******************************************************************************/
  
@interface AccountCertificate : NSObject

@property (nonatomic, readonly) SecIdentityRef identityRef;
@property (nonatomic, readonly) SecCertificateRef identityCertificateRef;
@property (nonatomic, strong, readonly) NSArray *certificateChain;
@property (nonatomic, strong, readonly) NSString *summary;
@property (nonatomic, strong, readonly) NSDate *expiryDate;
@property (nonatomic, assign, readonly) BOOL hasExpired;
@property (nonatomic, strong, readonly) NSString *certificateIssuer;

- (id)initWithIdentityData:(NSData *)data andPasscode:(NSString *)passcode;

@end
