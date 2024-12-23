#import "ManageUpgradesPlugin.h"
#if __has_include(<manageupgrades/manageupgrades-Swift.h>)
#import <manageupgrades/manageupgrades-Swift.h>
#else
#import "manageupgrades-Swift.h"
#endif

@implementation ManageUpgradesPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftManageUpgradesPlugin registerWithRegistrar:registrar];
}
@end
