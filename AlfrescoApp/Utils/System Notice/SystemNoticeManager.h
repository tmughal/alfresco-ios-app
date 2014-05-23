//
//  SystemNoticeManager.h
//

#import "SystemNotice.h"

@interface SystemNoticeManager : NSObject

+ (SystemNoticeManager *)sharedManager;

- (void)queueSystemNotice:(SystemNotice *)systemNotice;
- (void)systemNoticeDidDisappear:(SystemNotice *)systemNotice;

@end
