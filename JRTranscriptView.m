// JRTranscriptView.m semver:1.1
//   Copyright (c) 2014 Jonathan 'Wolf' Rentzsch: http://rentzsch.com
//   Some rights reserved: http://opensource.org/licenses/mit
//   https://github.com/rentzsch/JRTranscriptView

#import "JRTranscriptView.h"

@interface JRTextContainerView : UIView
@property(nonatomic, strong)  NSTextStorage  *textStorage;

- (void)resizeHeightToWidth:(CGFloat)width;
@end

//-----------------------------------------------------------------------------------------

@interface JRTranscriptView ()
@property(nonatomic, strong)  UIScrollView         *scrollView;
@property(nonatomic, strong)  JRTextContainerView  *textView;
@end

@implementation JRTranscriptView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self commonInitForJRTranscript];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self commonInitForJRTranscript];
    return self;
}

- (void)commonInitForJRTranscript {
    _scrollView = [UIScrollView new];
    [self addSubview:_scrollView];
    
    _textView = [JRTextContainerView new];
    [_scrollView addSubview:_textView];
    
    _defaultFont = [UIFont fontWithName:@"Menlo" size:10];
}

- (void)appendString:(NSString*)string {
    NSDictionary *monospaceFontAttribute = @{NSFontAttributeName: self.defaultFont};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string
                                                                           attributes:monospaceFontAttribute];
    [self appendAttributedString:attributedString];
}

- (void)appendAttributedString:(NSAttributedString*)attributedString {
    [self.textView.textStorage appendAttributedString:attributedString];
    [self setNeedsLayout];
}

- (void)clear {
    [self.textView.textStorage deleteCharactersInRange:(NSRange){0, self.textView.textStorage.length}];
    [self setNeedsLayout];
}

- (BOOL)needScrolling {
    return self.scrollView.contentSize.height > self.scrollView.bounds.size.height;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    BOOL wasScrolledToBottom;
    if ([self needScrolling]) {
        wasScrolledToBottom = self.scrollView.contentOffset.y
            == self.scrollView.contentSize.height - self.scrollView.bounds.size.height;
    } else {
        wasScrolledToBottom = YES;
    }
    
    self.textView.frame = (CGRect){CGPointZero, CGSizeZero};
    [self.textView resizeHeightToWidth:self.bounds.size.width];
    
    self.scrollView.frame = (CGRect){CGPointZero, self.bounds.size};
    self.scrollView.contentSize = self.textView.bounds.size;
    
    if ([self needScrolling]) {
        if (wasScrolledToBottom) {
            // Was already scrolled to bottom, autoscroll to new bottom.
            self.scrollView.contentOffset = (CGPoint){0,
                self.scrollView.contentSize.height - self.scrollView.bounds.size.height
            };
        } else {
            // Wasn't scrolled to bottom, respect current scroll position.
        }
    } else {
        // Doesn't need scrolling at all. Reset scroll position.
        self.scrollView.contentOffset = CGPointZero;
    }
}

@end

//-----------------------------------------------------------------------------------------

@interface JRTextContainerView ()

@property(nonatomic, strong)  NSLayoutManager  *layoutManager;
@property(nonatomic, strong)  NSTextContainer  *textContainer;
@end

@implementation JRTextContainerView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        
        _layoutManager = [NSLayoutManager new];
        _textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
        [_layoutManager addTextContainer:_textContainer];
        _textStorage = [NSTextStorage new];
        [_textStorage addLayoutManager:_layoutManager];
    }
    return self;
}

- (void)setTextStorage:(NSTextStorage*)textStorage {
    _textStorage = textStorage;
    [self.textStorage addLayoutManager:self.layoutManager];
    [self setNeedsDisplay];
}

- (void)resizeHeightToWidth:(CGFloat)width {
    if (self.textStorage) {
        self.textContainer.size = (CGSize){width, FLT_MAX};
        NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:self.textContainer];
        CGRect boundingRect = [self.layoutManager boundingRectForGlyphRange:glyphRange
                                                            inTextContainer:self.textContainer];
        self.frame = CGRectIntegral((CGRect){self.frame.origin, (CGSize){width, boundingRect.size.height}});
    } else {
        self.frame = CGRectIntegral((CGRect){self.frame.origin, (CGSize){width, 0}});
    }
}

- (CGFloat)calculatedContentHeight {
    if (!self.textStorage) return 0;
    
    self.textContainer.size = CGSizeMake(self.bounds.size.width, FLT_MAX);
    NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:self.textContainer];
    CGRect boundingRect = [self.layoutManager boundingRectForGlyphRange:glyphRange
                                                        inTextContainer:self.textContainer];
    return boundingRect.size.height;
}

- (void)drawRect:(CGRect)rect {
    if (!self.textStorage) return;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    self.textContainer.size = CGSizeMake(self.bounds.size.width, FLT_MAX);
    NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:self.textContainer];
    [self.layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:CGPointZero];
    [self.layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:CGPointZero];
    
    CGContextRestoreGState(ctx);
}

@end
