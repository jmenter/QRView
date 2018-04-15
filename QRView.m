/*
 MIT License
 
 Copyright (c) 2018 Jeff Menter
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import "QRView.h"
#import <AVFoundation/AVFoundation.h>

@implementation QRView

- (void)setMessage:(NSString *)message;
{
    if ([message isEqualToString:_message]) { return; }
    
    _message = message.copy;
    [self setNeedsDisplay];
}

- (void)setCorrectionLevel:(NSString *)correctionLevel;
{
    if ([correctionLevel isEqualToString:_correctionLevel]) { return; }

    _correctionLevel = correctionLevel.copy;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect;
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:[self.message ?: @"" dataUsingEncoding:NSISOLatin1StringEncoding] forKey:@"inputMessage"];
    [filter setValue:([self.correctionLevel.uppercaseString isEqualToString:@"H"] ||
                      [self.correctionLevel.uppercaseString isEqualToString:@"L"] ||
                      [self.correctionLevel.uppercaseString isEqualToString:@"Q"]) ? self.correctionLevel.uppercaseString : @"M" forKey:@"inputCorrectionLevel"];
    CGImageRef image = [CIContext.new createCGImage:filter.outputImage fromRect:filter.outputImage.extent];
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationNone);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), AVMakeRectWithAspectRatioInsideRect(CGSizeMake(1, 1), rect), image);
    CGImageRelease(image);
}

@end