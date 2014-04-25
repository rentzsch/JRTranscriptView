// JRTranscriptView.h semver:1.1
//   Copyright (c) 2014 Jonathan 'Wolf' Rentzsch: http://rentzsch.com
//   Some rights reserved: http://opensource.org/licenses/mit
//   https://github.com/rentzsch/JRTranscriptView

@interface JRTranscriptView : UIView
@property(nonatomic, strong)  UIFont  *defaultFont;  // Menlo 10 by default.

- (void)appendString:(NSString*)string;
- (void)appendAttributedString:(NSAttributedString*)attributedString;
- (void)clear;
@end
