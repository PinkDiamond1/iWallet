//
//  OCCurrency.m
//  OpenCoinWallet
//
//  Created by Gulliver on 07.01.13.
//  Copyright (c) 2013 Opencoin Team. All rights reserved.
//

#import "OCCurrency.h"
#import "OCPublicKey.h"
#import "OCHttpClient.h"

@interface OCCurrency ()

@end


@implementation OCCurrency

NSMutableArray* registeredCurrencies = nil;

+ (NSArray*) currencies
{
  if (!registeredCurrencies)
  {
    registeredCurrencies = [[NSMutableArray alloc] initWithCapacity:3];
  }
  return registeredCurrencies;
}

+ (void) registerCurrency: (NSURL*) issuerURL withCompletition:(void (^)(OCCurrency* result, NSError *error)) block
{
  OCHttpClient* client = [[OCHttpClient alloc] initWithBaseURL:issuerURL];
  
  [client getLatestCDD:^(OCCurrency *result, NSError *error) {
    if (!error)
    {
      [OCCurrency currencies];
      [registeredCurrencies addObject:result];
    }
    
    if (block)
    {
      block(result,error);
    }
  }];
}


- (id)initWithAttributes:(NSDictionary *)attributes
{
  self = [super init];
  if (!self) {
    return nil;
  }
  
  _additional_info  = [attributes valueForKeyPath:@"additional_info"];
  _cdd_expiry_date  = [attributes valueForKeyPath:@"cdd_expiry_date"];
  
  _cdd_location = [attributes valueForKeyPath:@"cdd_location"];
  _cdd_serial = [[attributes valueForKeyPath:@"cdd_serial"] integerValue];
  // TODO date conversion
  _cdd_signing_date = [NSDate date];
  // _cdd_signing_date = [attributes valueForKeyPath:@"cdd_signing_date"];
  
  _currency_divisor = [[attributes valueForKeyPath:@"currency_divisor"] integerValue];
  _currency_name = [attributes valueForKeyPath:@"currency_name"];
  _denominations =  [attributes valueForKeyPath:@"denominations"];
  
  // TODO read url list
  _info_service = [attributes valueForKeyPath:@"info_service"];
  // TODO read url list
  _invalidation_service = [attributes valueForKeyPath:@"invalidation_service"];
  
  _issuer_cipher_suite = [attributes valueForKeyPath:@"issuer_cipher_suite"];
  
  // TODO implement its subkeys
  _issuer_public_master_key = [[OCPublicKey alloc] initWithAttributes:[attributes valueForKeyPath:@"issuer_public_master_key"]];
  _protocol_version = [attributes valueForKeyPath:@"protocol_version"];
  _renewal_service = [attributes valueForKeyPath:@"renewal_service"];
  _validation_service = [attributes valueForKeyPath:@"validation_service"];
  
  return self;
  
}

@end
