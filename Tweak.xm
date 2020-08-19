@interface UIKeyboard : UIView
  +(UIView*)activeKeyboard;
@end

@interface TUIPredictionView : UIView
@end

@interface TUIPredictionViewCell : UIView
@end

@interface UIKeyboardDockView : UIView
@end

static bool isDark = NO;

%hook UIKeyboard
-(void)didMoveToWindow
{
  %orig;
  if (isDark)
    self.backgroundColor = [UIColor blackColor];
}
%end

%hook TUIPredictionViewCell
-(void)didMoveToWindow
{
  %orig;
  if (isDark)
    self.backgroundColor = [UIColor blackColor];
}
%end

%hook TUIPredictionView
-(void)didMoveToWindow
{
  %orig;
  if (isDark)
    self.backgroundColor = [UIColor blackColor];
}
%end

%hook UIKeyboardDockView

  -(void)didMoveToWindow
  {
    %orig;
    if (isDark)
      self.backgroundColor = [UIColor blackColor];
  }

%end

%hook UIKBRenderConfig
    -(void)setLightKeyboard:(BOOL)arg1 {
        isDark = !arg1;
        %orig(arg1);
    }

    -(bool)lightKeyboard
    {
      bool orig = %orig;
      isDark = !orig;
      return orig;
    }
%end

%ctor
{
    NSString *processName = [NSProcessInfo processInfo].processName;
    bool isSpringboard = [@"SpringBoard" isEqualToString: processName];

		bool shouldLoad = NO;
		NSArray *args = [[NSProcessInfo processInfo] arguments];
		NSUInteger count = args.count;
		if(count != 0)
		{
			NSString *executablePath = args[0];
			if(executablePath)
			{
				NSString *processName = [executablePath lastPathComponent];
				BOOL isApplication = [executablePath rangeOfString: @"/Application/"].location != NSNotFound || [executablePath rangeOfString: @"/Applications/"].location != NSNotFound;
				BOOL isFileProvider = [[processName lowercaseString] rangeOfString: @"fileprovider"].location != NSNotFound;
				BOOL skip = [processName isEqualToString: @"AdSheet"] || [processName isEqualToString: @"CoreAuthUI"]
							|| [processName isEqualToString: @"InCallService"] || [processName isEqualToString: @"MessagesNotificationViewService"]
							|| [executablePath rangeOfString: @".appex/"].location != NSNotFound;

				if((!isFileProvider && isApplication && !skip) || isSpringboard)
					shouldLoad = YES;
			}
		}

		if(shouldLoad)
    {
      NSBundle *bundle = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/TextInputUI.framework"];
      if (!bundle.loaded) [bundle load];
      %init;
    }
}
