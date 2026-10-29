#import <Foundation/Foundation.h>
#include "fn.inc"

static int fails = 0;

static void check(NSString *in, NSString *want) {
  NSString *got = DLCTRedactUrls(in);
  if (![got isEqualToString:want]) {
    fails++;
    printf("FAIL: [%s] -> [%s] want [%s]\n", in.UTF8String, got.UTF8String, want.UTF8String);
  }
}

int main(void) {
  @autoreleasepool {
    check(nil, @"");
    check(@"Cannot remove an observer <AudioPlayer 0x1> for the key path \"status\" from <IndexedPlayerItem 0x2> because it is not registered as an observer.",
          @"Cannot remove an observer <AudioPlayer 0x1> for the key path \"status\" from <IndexedPlayerItem 0x2> because it is not registered as an observer.");
    check(@"bad item https://x.supabase.co/storage/v1/object/sign/narration/a.mp3?token=eyJabc.def done",
          @"bad item <url> done");
    check(@"src=\"file:///var/mobile/a.mp3\" and asset:///b", @"src=\"<url>\" and <url>");
    printf(fails ? "PROBE FAILED (%d)\n" : "PROBE PASS\n", fails);
    return fails;
  }
}
