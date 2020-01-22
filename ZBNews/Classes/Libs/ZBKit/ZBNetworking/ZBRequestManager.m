//
//  ZBRequestManager.m
//  ZBNetworkingDemo
//
//  Created by NQ UEC on 2017/8/17.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBRequestManager.h"
#import "ZBCacheManager.h"
#import "ZBURLRequest.h"
#import "NSString+ZBUTF8Encoding.h"

NSString *const _isCache =@"_isCache";
NSString *const _cacheKey =@"_cacheKey";
@implementation ZBRequestManager

#pragma mark - 配置请求
+ (void)setupBaseConfig:(void(^)(ZBConfig *config))block{
    [[ZBRequestEngine defaultEngine] setupBaseConfig:block];
}

+ (void)requestProcessHandler:(ZBRequestProcessBlock)requestHandler responseProcessHandler:(ZBResponseProcessBlock)responseHandler{
    [ZBRequestEngine defaultEngine].requestProcessHandler=requestHandler;
    [ZBRequestEngine defaultEngine].responseProcessHandler = responseHandler;
}

+ (NSUInteger)requestWithConfig:(ZBRequestConfigBlock)config success:(ZBRequestSuccessBlock)success{
    return [self requestWithConfig:config progress:nil success:success failure:nil finished:nil];
}

+ (NSUInteger)requestWithConfig:(ZBRequestConfigBlock)config failure:(ZBRequestFailureBlock)failure{
    return [self requestWithConfig:config progress:nil success:nil failure:failure finished:nil];
}

+ (NSUInteger)requestWithConfig:(ZBRequestConfigBlock)config finished:(ZBRequestFinishedBlock)finished{
    return [self requestWithConfig:config progress:nil success:nil failure:nil finished:finished];
}

+ (NSUInteger)requestWithConfig:(ZBRequestConfigBlock)config success:(ZBRequestSuccessBlock)success failure:(ZBRequestFailureBlock)failure{
    return [self requestWithConfig:config progress:nil success:success failure:failure finished:nil];
}

+ (NSUInteger)requestWithConfig:(ZBRequestConfigBlock)config progress:(ZBRequestProgressBlock)progress success:(ZBRequestSuccessBlock)success failure:(ZBRequestFailureBlock)failure{
    return [self requestWithConfig:config progress:progress success:success failure:failure finished:nil];
}

+ (NSUInteger)requestWithConfig:(ZBRequestConfigBlock)config progress:(ZBRequestProgressBlock)progress success:(ZBRequestSuccessBlock)success failure:(ZBRequestFailureBlock)failure finished:(ZBRequestFinishedBlock)finished{
    ZBURLRequest *request=[[ZBURLRequest alloc]init];
    config ? config(request) : nil;
    return [self sendRequest:request progress:progress success:success failure:failure finished:nil];
}

+ (ZBBatchRequest *)sendBatchRequest:(ZBBatchRequestConfigBlock)config success:(ZBRequestSuccessBlock)success failure:(ZBRequestFailureBlock)failure finished:(ZBBatchRequestFinishedBlock)finished{
    return [self sendBatchRequest:config progress:nil success:success failure:failure finished:finished];
}

+ (ZBBatchRequest *)sendBatchRequest:(ZBBatchRequestConfigBlock)config progress:(ZBRequestProgressBlock)progress success:(ZBRequestSuccessBlock)success failure:(ZBRequestFailureBlock)failure finished:(ZBBatchRequestFinishedBlock)finished{
    ZBBatchRequest *batchRequest=[[ZBBatchRequest alloc]init];
    config ? config(batchRequest) : nil;
    if (batchRequest.requestArray.count==0)return nil;
    [batchRequest.requestArray enumerateObjectsUsingBlock:^(ZBURLRequest *request , NSUInteger idx, BOOL *stop) {
        [self sendRequest:request progress:progress success:success failure:failure finished:^(id responseObject, NSError *error) {
            [batchRequest requestFinishedResponse:responseObject error:error finished:finished];
        }];
    }];
    return batchRequest;
}


#pragma mark - 发起请求
+ (NSUInteger)sendRequest:(ZBURLRequest *)request progress:(ZBRequestProgressBlock)progress success:(ZBRequestSuccessBlock)success failure:(ZBRequestFailureBlock)failure finished:(ZBRequestFinishedBlock)finished{
    
    if([request.URLString isEqualToString:@""]||request.URLString==nil)return 0;
    
    [self configBaseWithRequest:request progress:progress success:success failure:failure finished:finished];
    
    id obj=nil;
    if ([ZBRequestEngine defaultEngine].requestProcessHandler&&request.keepType==ZBResponseKeepNone) {
        [ZBRequestEngine defaultEngine].requestProcessHandler(request,&obj);
        if (obj) {
            [self successWithResponseObject:obj request:request];
            return 0;
        }
    }

    ZBURLRequest *originalRequest= [[ZBRequestEngine defaultEngine]objectRequestForkey:request.URLString];
    if (request.keepType==ZBResponseKeepFirst&&originalRequest) {
        return request.identifier;
    }
    if (request.keepType==ZBResponseKeepLast&&originalRequest) {
        [self cancelRequest:originalRequest.identifier];
    }
    
    request.identifier=[self startSendRequest:request];
    [[ZBRequestEngine defaultEngine]setRequestObject:request forkey:request.URLString];
    return request.identifier;
}

+ (NSUInteger)startSendRequest:(ZBURLRequest *)request{
    if (request.methodType==ZBMethodTypeUpload) {
       return [self sendUploadRequest:request];
    }else if (request.methodType==ZBMethodTypeDownLoad){
       return [self sendDownLoadRequest:request];
    }else{
       return [self sendHTTPRequest:request];
    }
}

+ (NSUInteger)sendUploadRequest:(ZBURLRequest *)request{
    request.apiType=ZBRequestTypeRefresh;
    return [[ZBRequestEngine defaultEngine] uploadWithRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        request.progressBlock?request.progressBlock(uploadProgress):nil;
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self successWithResponseObject:responseObject request:request];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self failureWithError:error request:request ];
    }];
}

+ (NSUInteger)sendDownLoadRequest:(ZBURLRequest *)request{
    request.apiType=ZBRequestTypeRefresh;
    return [[ZBRequestEngine defaultEngine] downloadWithRequest:request progress:^(NSProgress * _Nullable downloadProgress) {
        request.progressBlock?request.progressBlock(downloadProgress):nil;
    }  completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            [self failureWithError:error request:request];
        }else{
            [self successWithResponseObject:[filePath path] request:request];
        }
    }];
}

+ (NSUInteger)sendHTTPRequest:(ZBURLRequest *)request{
    NSString *key = [self keyWithParameters:request];
    if ([[ZBCacheManager sharedInstance]diskCacheExistsWithKey:key]&&request.apiType==ZBRequestTypeCache){
        [self getCacheDataForKey:key request:request];
        return 0;
    }else{
        return [self dataTaskWithHTTPRequest:request];
    }
}

+ (NSUInteger)dataTaskWithHTTPRequest:(ZBURLRequest *)request{
    return [[ZBRequestEngine defaultEngine]dataTaskWithMethod:request progress:^(NSProgress * _Nonnull zb_progress) {
        request.progressBlock ? request.progressBlock(zb_progress) : nil;
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self successWithResponseObject:responseObject request:request];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self failureWithError:error request:request];
    }];
}

+ (void)cancelRequest:(NSUInteger)identifier{
    [[ZBRequestEngine defaultEngine]cancelRequestByIdentifier:identifier];
}

+ (void)cancelBatchRequest:(ZBBatchRequest *)batchRequest{
    if (batchRequest.requestArray.count>0) {
        [batchRequest.requestArray enumerateObjectsUsingBlock:^(ZBURLRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.identifier>0) {
                [self cancelRequest:obj.identifier];
            }
        }];
    }
}

+ (void)cancelAllRequest{
    [[ZBRequestEngine defaultEngine]cancelAllRequest];
}

#pragma mark - 其他配置
+ (void)configBaseWithRequest:(ZBURLRequest *)request progress:(ZBRequestProgressBlock)progress success:(ZBRequestSuccessBlock)success failure:(ZBRequestFailureBlock)failure finished:(ZBRequestFinishedBlock)finished{
    [[ZBRequestEngine defaultEngine] configBaseWithRequest:request progressBlock:progress successBlock:success failureBlock:failure finishedBlock:finished];
}

+ (NSString *)keyWithParameters:(ZBURLRequest *)request{
    NSDictionary *newParameters;
    if (request.filtrationCacheKey.count>0) {
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:request.parameters];
        [mutableParameters removeObjectsForKeys:request.filtrationCacheKey];
        newParameters = [mutableParameters copy];
    }else{
        newParameters = request.parameters;
    }

    return [NSString zb_stringUTF8Encoding:[NSString zb_urlString:request.URLString appendingParameters:newParameters]];
}

+ (void)storeObject:(NSObject *)object request:(ZBURLRequest *)request{
    NSString * key= [self keyWithParameters:request];
    [[ZBCacheManager sharedInstance] storeContent:object forKey:key isSuccess:nil];
}

+ (id)responsetSerializerConfig:(ZBURLRequest *)request responseObject:(id)responseObject{
    if (request.responseSerializer==ZBHTTPResponseSerializer||request.methodType==ZBMethodTypeDownLoad||![responseObject isKindOfClass:[NSData class]]) {
        return responseObject;
    }else{
        NSError *serializationError = nil;
        NSData *data = (NSData *)responseObject;
        // Workaround for behavior of Rails to return a single space for `head :ok` (a workaround for a bug in Safari), which is not interpreted as valid input by NSJSONSerialization.
        // See https://github.com/rails/rails/issues/1742
        BOOL isSpace = [data isEqualToData:[NSData dataWithBytes:" " length:1]];
        if (data.length > 0 && !isSpace) {
            id result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializationError];
            return result;
        } else {
            return nil;
        }
    }
}

+ (void)successWithResponseObject:(id)responseObject request:(ZBURLRequest *)request {
    id result=[self responsetSerializerConfig:request responseObject:responseObject];
    NSError *processError = nil;
    if ([ZBRequestEngine defaultEngine].responseProcessHandler) {
        [ZBRequestEngine defaultEngine].responseProcessHandler(request, result,&processError);
        if (processError) {
            [self failureWithError:processError request:request];
            return;
        }
    }
    if (request.apiType == ZBRequestTypeRefreshAndCache||request.apiType == ZBRequestTypeCache) {
        [self storeObject:responseObject request:request];
    }
    [request setValue:@(NO) forKey:_isCache];
    request.successBlock?request.successBlock(result, request):nil;
    request.finishedBlock?request.finishedBlock(result, nil):nil;
    [request cleanAllBlocks];
    [[ZBRequestEngine defaultEngine] removeRequestForkey:request.URLString];
}

+ (void)failureWithError:(NSError *)error request:(ZBURLRequest *)request{
    if (request.consoleLog==YES) {
        [self printfailureInfoWithError:error request:request];
    }
    if (request.retryCount > 0) {
        request.retryCount --;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self dataTaskWithHTTPRequest:request];
        });
        return;
    }
    request.failureBlock?request.failureBlock(error):nil;
    request.finishedBlock?request.finishedBlock(nil,error):nil;
    [request cleanAllBlocks];
    [[ZBRequestEngine defaultEngine] removeRequestForkey:request.URLString];
}

+ (void)getCacheDataForKey:(NSString *)key request:(ZBURLRequest *)request{
    [[ZBCacheManager sharedInstance]getCacheDataForKey:key value:^(NSData *data,NSString *filePath) {
        if (request.consoleLog==YES) {
            [self printCacheInfoWithkey:key filePath:filePath request:request];
        }
        id result=[self responsetSerializerConfig:request responseObject:data];
        [request setValue:key forKey:_cacheKey];
        [request setValue:@(YES) forKey:_isCache];
        request.successBlock?request.successBlock(result, request):nil;
        request.finishedBlock?request.finishedBlock(result, nil):nil;
        [request cleanAllBlocks];
    }];
}

+ (BOOL)isNetworkReachable {
    return [ZBRequestEngine defaultEngine].networkReachability != 0;
}

#pragma mark - 打印log
+ (void)printCacheInfoWithkey:(NSString *)key filePath:(NSString *)filePath request:(ZBURLRequest *)request{
    NSString *responseStr=request.responseSerializer==ZBHTTPResponseSerializer ?@"HTTP":@"JOSN";
    NSLog(@"\n------------ZBNetworking------cache info------begin------\n-cachekey-:%@\n-cacheFileSource-:%@\n-responseSerializer-:%@\n------------ZBNetworking------cache info-------end-------",key,filePath,responseStr);
}

+ (void)printfailureInfoWithError:(NSError *)error request:(ZBURLRequest *)request{
    NSLog(@"\n------------ZBNetworking------error info------begin------\n-URLAddress-:%@\n-retryCount-%ld\n-error info-:%@\n------------ZBNetworking------error info-------end-------",request.URLString,request.retryCount,error);
}

@end
