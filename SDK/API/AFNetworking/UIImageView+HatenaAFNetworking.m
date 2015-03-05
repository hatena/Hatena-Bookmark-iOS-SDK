// UIImageView+HatenaAFNetworking.m
//
// Copyright (c) 2011 Gowalla (http://gowalla.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#import "UIImageView+HatenaAFNetworking.h"

@interface HatenaAFImageCache : NSCache
- (UIImage *)cachedImageForRequest:(NSURLRequest *)request;
- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request;
@end

#pragma mark -

static char kHatenaAFImageRequestOperationObjectKey;

@interface UIImageView (_HatenaAFNetworking)
@property (readwrite, nonatomic, strong, setter = af_setImageRequestOperation:) HatenaAFImageRequestOperation *af_imageRequestOperation;
@end

@implementation UIImageView (_HatenaAFNetworking)
@dynamic af_imageRequestOperation;
@end

#pragma mark -

@implementation UIImageView (HatenaAFNetworking)

- (HatenaAFHTTPRequestOperation *)af_imageRequestOperation {
    return (HatenaAFHTTPRequestOperation *)objc_getAssociatedObject(self, &kHatenaAFImageRequestOperationObjectKey);
}

- (void)af_setImageRequestOperation:(HatenaAFImageRequestOperation *)imageRequestOperation {
    objc_setAssociatedObject(self, &kHatenaAFImageRequestOperationObjectKey, imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSOperationQueue *)af_sharedImageRequestOperationQueue {
    static NSOperationQueue *_af_imageRequestOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _af_imageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [_af_imageRequestOperationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    });

    return _af_imageRequestOperationQueue;
}

+ (HatenaAFImageCache *)af_sharedImageCache {
    static HatenaAFImageCache *_af_imageCache = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _af_imageCache = [[HatenaAFImageCache alloc] init];
    });

    return _af_imageCache;
}

#pragma mark -

- (void)setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    [self cancelImageRequestOperation];

    UIImage *cachedImage = [[[self class] af_sharedImageCache] cachedImageForRequest:urlRequest];
    if (cachedImage) {
        self.af_imageRequestOperation = nil;

        if (success) {
            success(nil, nil, cachedImage);
        } else {
            self.image = cachedImage;
        }
    } else {
        if (placeholderImage) {
            self.image = placeholderImage;
        }

        HatenaAFImageRequestOperation *requestOperation = [[HatenaAFImageRequestOperation alloc] initWithRequest:urlRequest];
		
#ifdef _HatenaAFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES_
		requestOperation.allowsInvalidSSLCertificate = YES;
#endif
		
        [requestOperation setCompletionBlockWithSuccess:^(HatenaAFHTTPRequestOperation *operation, id responseObject) {
            if ([urlRequest isEqual:[self.af_imageRequestOperation request]]) {
                if (self.af_imageRequestOperation == operation) {
                    self.af_imageRequestOperation = nil;
                }

                if (success) {
                    success(operation.request, operation.response, responseObject);
                } else if (responseObject) {
                    self.image = responseObject;
                }
            }

            [[[self class] af_sharedImageCache] cacheImage:responseObject forRequest:urlRequest];
        } failure:^(HatenaAFHTTPRequestOperation *operation, NSError *error) {
            if ([urlRequest isEqual:[self.af_imageRequestOperation request]]) {
                if (self.af_imageRequestOperation == operation) {
                    self.af_imageRequestOperation = nil;
                }

                if (failure) {
                    failure(operation.request, operation.response, error);
                }
            }
        }];

        self.af_imageRequestOperation = requestOperation;

        [[[self class] af_sharedImageRequestOperationQueue] addOperation:self.af_imageRequestOperation];
    }
}

- (void)cancelImageRequestOperation {
    [self.af_imageRequestOperation cancel];
    self.af_imageRequestOperation = nil;
}

@end

#pragma mark -

static inline NSString * HatenaAFImageCacheKeyFromURLRequest(NSURLRequest *request) {
    return [[request URL] absoluteString];
}

@implementation HatenaAFImageCache

- (UIImage *)cachedImageForRequest:(NSURLRequest *)request {
    switch ([request cachePolicy]) {
        case NSURLRequestReloadIgnoringCacheData:
        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
            return nil;
        default:
            break;
    }

	return [self objectForKey:HatenaAFImageCacheKeyFromURLRequest(request)];
}

- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request
{
    if (image && request) {
        [self setObject:image forKey:HatenaAFImageCacheKeyFromURLRequest(request)];
    }
}

@end

#endif
