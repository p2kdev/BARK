@interface UIKeyboard : UIView
@end
@interface UIKeyboardDockView : UIView
@end

bool isDarkKeyboard = YES;

%hook UIKeyboard
    -(void)layoutSubviews {
        %orig;
        if (isDarkKeyboard)
          self.backgroundColor = [UIColor blackColor];
    }
%end

%hook UIKBRenderConfig
    -(void)setLightKeyboard:(BOOL)arg1 {
        isDarkKeyboard = !arg1;
        %orig(arg1);
    }
%end

%hook UIKeyboardDockView
    -(void)layoutSubviews {
        %orig;
        if (isDarkKeyboard)
          self.backgroundColor = [UIColor blackColor];
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
      %init;
    }
}
