#import "Headers.h"

#define isCurrentApp(string) [[[NSBundle mainBundle] bundleIdentifier] isEqual : string]
#define PreferencesFilePath [NSString stringWithFormat:@"/var/mobile/Library/Preferences/com.ivanc.accentpreferences.plist"]
#define PreferencesChangedNotification "com.ivanc.preferenceschanged"

//Storing colors in a NSDictionary
static NSDictionary *myColors;

static NSDictionary* preferences;
static BOOL enabled;
NSString* color;
UIColor *newColor;

void setColor() {
    /*  Switching from NSUserdefaults to logging method because it doesn't work inside sandboxed application
        Check iPhoneDevWiki to know more (https://iphonedevwiki.net/index.php/PreferenceBundles#Loading_Preferences) */
    // preferences = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.ivanc.accentpreferences"];
    preferences = [[NSDictionary alloc] initWithContentsOfFile:PreferencesFilePath];

    myColors = @{
        @"Blue" : [UIColor colorWithRed:0.00 green:0.48 blue:1.00 alpha:1.0],
        @"Purple" : [UIColor colorWithRed:0.69 green:0.32 blue:0.87 alpha:1.0],
        @"Pink" : [UIColor colorWithRed:1.00 green:0.47 blue:0.60 alpha:1.0],
        @"Red" : [UIColor colorWithRed:1.00 green:0.23 blue:0.19 alpha:1.0],
        @"Orange" : [UIColor colorWithRed:1.00 green:0.58 blue:0.00 alpha:1.0],
        @"Yellow" : [UIColor colorWithRed:1.00 green:0.80 blue:0.00 alpha:1.0],
        @"Green" : [UIColor colorWithRed:0.16 green:0.80 blue:0.25 alpha:1.0],
        @"Gray" : [UIColor colorWithRed:0.56 green:0.56 blue:0.58 alpha:1.0],
    };

    color = [preferences valueForKey:@"isColor"];

    if([myColors objectForKey:color] != nil) {
        newColor = [myColors objectForKey:color];
    } else {
        //If its nil use whatever color from the dictionary
        newColor = [myColors objectForKey:@"Pink"];
    }


    if ([preferences objectForKey:@"isEnabled"] != nil) {
        enabled = [[preferences valueForKey:@"isEnabled"] boolValue];
    }
    else {
        enabled = YES;
    }
}

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    setColor(); // Just need this in my case. Could add more later
}

%ctor
{
    // Causes weird artifacts, so commenting first line
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("com.ivanc.accentpreferences"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR(PreferencesChangedNotification), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    setColor();
}

// iOS default colors

%hook UIColor

+(id)systemBlueColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

+(id) systemRedColor {
    if (enabled && (isCurrentApp(@"com.apple.mobilecal") || isCurrentApp(@"com.apple.mobiletimer")) ) {
        return newColor;
    }
    else {
        return %orig;
    }
}

    +(id)systemGreenColor{
    if(enabled )
      return newColor;
    else
      return %orig;
    }

+(id) systemOrangeColor {
    if (enabled  && ! isCurrentApp(@"com.apple.mobilemail")) {
        return newColor;
    }
    else {
        return %orig;
    }
}

+(id) systemYellowColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

+(id) systemTealColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

+(id) systemPinkColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

+(id) _systemInteractionTintColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

+(id) _systemSelectedColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

+(id) systemDarkRedColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

+(id) systemDarkGreenColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

+(id) systemDarkBlueColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

+(id) systemDarkOrangeColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

+(id) systemDarkTealColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

+(id) systemDarkPinkColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

+(id) systemDarkYellowColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

+(id) externalSystemTealColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

+(id) externalSystemRedColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

+(id) externalSystemGreenColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

+(id) tableCellBlueTextColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

+(id) twitterColorTwitterBlue {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

%end

%hook UIApplication

-(id)keyWindow {
    UIWindow* o = %orig;
    if (enabled  && ! isCurrentApp(@"com.apple.weather")) {
        if (isCurrentApp(@"com.apple.camera") || isCurrentApp(@"com.apple.facetime") || isCurrentApp(@"com.apple.Passbook") || isCurrentApp(@"com.apple.compass")) {       //[o.tintColor isEqual:[UIColor systemTealColor]] || [o.tintColor isEqual:[UIColor systemYellowColor]])
            [o setTintColor:newColor];
        }
        else {
            [o setTintColor:newColor];
        }
    }
    return o;
}

%end

%hook UISwitch

-(void)layoutSubviews {
    %orig;
    [self setOnTintColor:newColor];
}
-(void) setOnTintColor:(id)col {
    %orig(newColor);
}

%end

//  GC

%hook GKColorPalette

- (id)emphasizedTextColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}
-(id) emphasizedTextOnDarkBackgroundColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

-(id) systemInteractionColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}

%end

%hook GKUITheme

- (id)tabbarIconChallengesSelected : (BOOL)arg1 {
    return [%orig imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

-(id) tabbarIconFriendsSelected:(BOOL)arg1 {
    return [%orig imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

-(id) tabbarIconGamesSelected:(BOOL)arg1 {
    return [%orig imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

-(id) tabbarIconMeSelected:(BOOL)arg1 {
    return [%orig imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

-(id) tabbarIconTurnsSelected:(BOOL)arg1 {
    return [%orig imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

%end

//  iTunes

%hook SUApplication
-(id)interactionTintColor {
    if (enabled) {
        return newColor;
    }
    else {
        return %orig;
    }
}
%end

%ctor {
    setColor();
    %init;
}