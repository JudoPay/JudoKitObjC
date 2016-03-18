//
//  JPInputField.m
//  JudoKitObjC
//
//  Copyright (c) 2016 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "JPInputField.h"

#import "JPTheme.h"

#import "FloatingTextField.h"
#import "CardLogoView.h"

@interface JPInputField ()

@property (nonatomic, strong, readwrite) NSString *hintLabelText;

@property (nonatomic, strong) UIView *logoContainerView;

@property (nonatomic, strong) UIView *redBlock;

@end

@implementation JPInputField

- (instancetype)initWithTheme:(JPTheme *)theme {
	self = [super init];
	if (self) {
        self.theme = theme;
        [self setupView];
	}
	return self;
}

- (void)setupView {
    self.backgroundColor = self.theme.judoInputFieldBackgroundColor;
    self.clipsToBounds = YES;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.layer.borderColor = self.theme.judoInputFieldBorderColor.CGColor;
    self.layer.borderWidth = 0.5;
    
    self.textField.delegate = self;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    
    [self addSubview:self.textField];
    [self addSubview:self.redBlock];
    
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.textField.textColor = self.theme.judoInputFieldTextColor;
    self.textField.tintColor = self.theme.tintColor;
    self.textField.font = [UIFont boldSystemFontOfSize:14];
    [self.textField addTarget:self action:@selector(textFieldDidChangeValue:) forControlEvents:UIControlEventEditingChanged];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[text]|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:@{@"text":self.textField}]];
    
    [self setActive:false];
    
    [self.textField setPlaceholder:[self title] floatingTitle:[self title]];
    
    if ([self containsLogo]) {
        UIView *logoView = [self logoView];
        logoView.frame = CGRectMake(0, 0, 42, 27);
        [self addSubview:self.logoContainerView];
        self.logoContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        self.logoContainerView.clipsToBounds = YES;
        self.logoContainerView.layer.cornerRadius = 2;
        [self.logoContainerView addSubview:logoView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoContainerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        
        [self.logoContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.logoContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:27.0]];
        
    }
    
    NSString *visualFormat = [self containsLogo] ? @"|-13-[text][logo(42)]-13-|" : @"|-13-[text]-13-|";
    
    NSDictionary *views = @{@"text": self.textField, @"logo": self.logoContainerView};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views]];
}

- (void)errorAnimation:(BOOL)showRedBlock {
    void (^blockAnimation)(BOOL) = ^void(BOOL didFinish) {
        CAKeyframeAnimation *contentViewAnimation = [CAKeyframeAnimation animation];
        contentViewAnimation.keyPath = @"position.x";
        contentViewAnimation.values = @[@0, @10, @(-8), @6, @(-4), @2, @0];
        contentViewAnimation.keyTimes = @[@0, @(1 / 11.0), @(3 / 11.0), @(5 / 11.0), @(7 / 11.0), @(9 / 11.0), @1];
        contentViewAnimation.duration = 0.4;
        contentViewAnimation.additive = YES;
        
        [self.layer addAnimation:contentViewAnimation forKey:@"wiggle"];
        
        [self layoutIfNeeded];
    };
    
    if (showRedBlock) {
        self.redBlock.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 4.0);
        
        [UIView animateWithDuration:0.2 animations:^{
            self.redBlock.frame = CGRectMake(0, self.bounds.size.height - 4, self.bounds.size.width, 4.0);
            self.textField.textColor = self.theme.judoRedColor;
        } completion:blockAnimation];
    } else {
        blockAnimation(YES);
    }
}

- (void)updateCardLogo {
    CardLogoView *logoView = [self logoView];
    logoView.frame = CGRectMake(0, 0, 42, 27);
    CardLogoView *oldLogoView = self.logoContainerView.subviews.firstObject;
    if (oldLogoView.type != logoView.type) {
        [UIView transitionFromView:oldLogoView toView:logoView duration:0.3 options:UIViewAnimationOptionTransitionFlipFromBottom completion:nil];
    }
}

- (void)setActive:(BOOL)active {
    self.textField.alpha = active ? 1.0 : 0.5;
}

- (void)dismissError {
    if (self.redBlock.bounds.origin.y < self.bounds.size.height) {
        [UIView animateWithDuration:0.4 animations:^{
            self.redBlock.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 4.0f);
            self.textField.textColor = self.theme.judoDarkGrayColor;
        } completion:^(BOOL finished) {
            [self layoutIfNeeded];
        }];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self setActive:YES];
    [self.delegate judoPayInputDidChangeText:self];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self setActive:(textField.text.length > 0)];
}

- (BOOL)isValid {
    return false;
}

- (void)didChangeInputText {
    [self.delegate judoPayInputDidChangeText:self];
}

- (void)textFieldDidChangeValue:(UITextField *)textField {
    [self dismissError];
}

- (NSAttributedString *)placeHolder {
    return [NSAttributedString new];
}

- (BOOL)containsLogo {
    return NO;
}

- (CardLogoView *)logoView {
    return nil;
}

- (NSString *)title {
    return @"";
}

- (CGFloat)titleWidth {
    return 50.0f;
}

- (NSString *)hintLabelText {
    return @"";
}

#pragma mark - Lazy Loading

- (FloatingTextField *)textField {
    if (!_textField) {
        _textField = [FloatingTextField new];
        _textField.floatingLabelYPadding = 6.0f;
        _textField.floatingLabelFont = [UIFont systemFontOfSize:12.0f];
        _textField.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textField;
}

- (UIView *)redBlock {
    if (!_redBlock) {
        _redBlock = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 48.0f, 0.0f, 0.0f)];
        _redBlock.backgroundColor = self.theme.judoRedColor;
    }
    return _redBlock;
}

- (UIView *)logoContainerView {
    if (!_logoContainerView) {
        _logoContainerView = [UIView new];
        _logoContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _logoContainerView;
}

@end
