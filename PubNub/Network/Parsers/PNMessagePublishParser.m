/**
 @author Sergey Mamontov
 @since 4.0
 @copyright © 2009-2015 PubNub, Inc.
 */
#import "PNMessagePublishParser.h"
#import "PNDictionary.h"


@implementation PNMessagePublishParser


#pragma mark - Identification

+ (NSArray *)operations {
    
    return @[@(PNPublishOperation)];
}

+ (BOOL)requireAdditionalData {
    
    return NO;
}


#pragma mark - Parsing

+ (NSDictionary *)parsedServiceResponse:(id)response {
    
    // To handle case when response is unexpected for this type of operation processed value sent
    // through 'nil' initialized local variable.
    NSDictionary *processedResponse = nil;
    
    // Response in form of array arrive in two cases: publish successful and failed.
    // In case if no valid Foundation object has been passed it is possible what service returned
    // HTML and it should be treated as data publish error.
    if ([response isKindOfClass:[NSArray class]] || !response) {
        
        NSString *information = @"Message Not Published";
        NSNumber *timeToken = nil;
        if ([(NSArray *)response count] == 3) {
            
            information = response[1];
            timeToken = response[2];
        }
        else {
            
            timeToken = @((unsigned long long)([[NSDate date] timeIntervalSince1970] * 10000000));
        }
        
        processedResponse = @{@"information": information, @"timetoken": timeToken};
    }
    
    return processedResponse;
}

#pragma mark -


@end
