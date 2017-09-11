//
//  ViewController.m
//  KYStackViewAnimationDemo
//
//  Created by Jordon on 2017/9/11.
//
//

#import "ViewController.h"

#import "UIStackView+Animation.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UITextField *removeIndex;
@property (weak, nonatomic) IBOutlet UITextField *insertIndex;
@property (weak, nonatomic) IBOutlet UITextField *replaceIndex;
@property (weak, nonatomic) IBOutlet UITextField *reloadIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.removeIndex addTarget:self action:@selector(done:) forControlEvents:(UIControlEventEditingDidEndOnExit)];
    [self.insertIndex addTarget:self action:@selector(done:) forControlEvents:(UIControlEventEditingDidEndOnExit)];
    [self.replaceIndex addTarget:self action:@selector(done:) forControlEvents:(UIControlEventEditingDidEndOnExit)];
    [self.reloadIndex addTarget:self action:@selector(done:) forControlEvents:(UIControlEventEditingDidEndOnExit)];
}

- (UILabel *)testLabel {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [self randomColor];
    label.text = [self randomText];
    return label;
}

- (NSString *)randomText {
    return @(arc4random()%1000000000000000000).stringValue;
}

- (UIColor *)randomColor {
    CGFloat red = arc4random()%256 / 255.0;
    CGFloat green = arc4random()%256 / 255.0;
    CGFloat blue = arc4random()%256 / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

#pragma mark -

- (void)done:(UITextField *)sender {
}

- (IBAction)add:(id)sender {
    [self.stackView addArrangedSubview:[self testLabel] animated:YES];
}
- (IBAction)remove:(id)sender {
    UIView *view = [self.stackView.arrangedSubviews objectAtIndex:self.removeIndex.text.integerValue];
    if (view) {
        [self.stackView removeArrangedSubview:view animated:YES];
    }
}
- (IBAction)insert:(id)sender {
    [self.stackView insertArrangedSubview:[self testLabel] atIndex:self.insertIndex.text.integerValue animated:YES];
}
- (IBAction)replace:(id)sender {
    UIView *view = [self.stackView.arrangedSubviews objectAtIndex:self.replaceIndex.text.integerValue];
    if (view) {
        [self.stackView replaceArrangedSubview:view withView:[self testLabel] animated:YES completion:^(id replacedView) {
            //do something with replaced view
        }];
    }
    
}
- (IBAction)reload:(id)sender {
    UIView *view = [self.stackView.arrangedSubviews objectAtIndex:self.reloadIndex.text.integerValue];
    if (view) {
        [self.stackView reloadArrangedSubview:view animated:YES withReloadConfiguration:^(UILabel * arrangedSubview) {
            arrangedSubview.text = [self randomText];
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
