#import <UIKit/UIKit.h>


@interface ViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL modal;
@property (nonatomic, assign) BOOL nested;


- (UIButton*) buildButtonWithFrame:(CGRect)frame andTitle:(NSString*)title;


@end
