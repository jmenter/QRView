/*
 MIT License
 
 Copyright (c) 2018 Jeff Menter
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "QRView.h"
#import <AVFoundation/AVFoundation.h>

@implementation QRView

- (void)setMessage:(NSString *)message; { _message = message.copy; [self setNeedsDisplay]; }
- (void)setCorrectionLevel:(NSString *)correctionLevel; { _correctionLevel = correctionLevel.copy; [self setNeedsDisplay]; }

- (UIImage *)qrImage;
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:[self.message ?: @"" dataUsingEncoding:NSISOLatin1StringEncoding] forKey:@"inputMessage"];
    [filter setValue:([@[@"H", @"L", @"Q"] containsObject:self.correctionLevel.uppercaseString]) ? self.correctionLevel.uppercaseString : @"M" forKey:@"inputCorrectionLevel"];
    return [UIImage imageWithCIImage:filter.outputImage];
}

- (void)drawRect:(CGRect)rect;
{
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationNone);
    [self.qrImage drawInRect:AVMakeRectWithAspectRatioInsideRect(CGSizeMake(1, 1), rect)];
}

@end
