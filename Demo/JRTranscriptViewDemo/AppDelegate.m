#import "AppDelegate.h"
#import "JRTranscriptView.h"

@interface MyWindowController : UIViewController
@property(nonatomic, strong)  JRTranscriptView  *textView;
@end

//-----------------------------------------------------------------------------------------

@implementation MyWindowController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:CGRectZero];
    
    JRTranscriptView *textView = [JRTranscriptView new];
    [self.view addSubview:textView];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:clearButton];
    clearButton.translatesAutoresizingMaskIntoConstraints = NO;
    [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [clearButton addTarget:self
                    action:@selector(clearTranscript:)
          forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *viewDictionary = @{
                                     @"textView": textView,
                                     @"clearButton": clearButton,
                                     @"topLayoutGuide": self.topLayoutGuide,
                                     };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[textView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[clearButton]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][clearButton][textView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    
    [textView appendString:@"line1\nline2\nline3\nline4\nline5\nline6\nline7\nline8\nline9\nline10\n"];
    [textView appendString:@"line10\nline12\nline13\nline14\nline15\nline16\nline17\nline18\nline19\nline20\n"];
    
    self.textView = textView;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(addLine:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)addLine:(NSTimer*)timer {
    [self.textView appendString:[NSString stringWithFormat:@"%@\n", NSDate.new.description]];
}

- (void)clearTranscript:(UIButton*)sender {
    [self.textView clear];
}

@end

//-----------------------------------------------------------------------------------------

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application
didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [MyWindowController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end