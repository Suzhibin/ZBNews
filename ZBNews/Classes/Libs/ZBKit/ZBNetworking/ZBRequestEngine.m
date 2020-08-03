//
//  ZBRequestEngine.m
//  ZBNetworkingDemo
//
//  Created by NQ UEC on 2017/8/17.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBRequestEngine.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "ZBURLRequest.h"
#import "NSString+ZBUTF8Encoding.h"

NSString *const _successBlock =@"_successBlock";
NSString *const _failureBlock =@"_failureBlock";
NSString *const _finishedBlock =@"_finishedBlock";
NSString *const _progressBlock =@"_progressBlock";
@interface ZBRequestEngine ()
@property (nonatomic, copy, nullable) NSString *baseURLString;
@property (nonatomic, strong, nullable) NSMutableDictionary<NSString *, id> *baseParameters;
@property (nonatomic, strong, nullable) NSMutableDictionary<NSString *, NSString *> *baseHeaders;
@property (nonatomic, strong, nullable) NSDictionary *baseUserInfo;
@property (nonatomic, strong, nullable) NSMutableArray *baseFiltrationCacheKey;
@property (nonatomic, assign) NSTimeInterval baseTimeoutInterval;
@property (nonatomic, assign) NSUInteger baseRetryCount;
@property (nonatomic,assign) ZBRequestSerializerType baseRequestSerializer;
@property (nonatomic,assign) ZBResponseSerializerType baseResponseSerializer;
@property (nonatomic, assign)BOOL consoleLog;

@end

@implementation ZBRequestEngine{
    NSMutableDictionary * _requestDic;
}

+ (instancetype)defaultEngine{
    static ZBRequestEngine *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZBRequestEngine alloc]init];
    });
    return sharedInstance;
}
/*
   硬性设置：
   1.因为与缓存互通 服务器返回的数据格式 必须是二进制
   2.证书设置
   3.开启菊花
*/
- (instancetype)init {
    self = [super init];
    if (self) {
        //无条件地信任服务器端返回的证书。
        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        self.securityPolicy = [AFSecurityPolicy defaultPolicy];
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json", @"text/plain",@"text/javascript",@"text/xml",@"image/*",@"multipart/form-data",@"application/octet-stream",@"application/zip",nil];
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
         _requestDic =[[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)dealloc {
   // [self invalidateSessionCancelingTasks:YES];
}

#pragma mark - GET/POST/PUT/PATCH/DELETE
- (NSUInteger)dataTaskWithMethod:(ZBURLRequest *)request
                             progress:(void (^)(NSProgress * _Nonnull))progress
                              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{

    [self requestSerializerConfig:request];
    [self headersAndTimeConfig:request];
    [self printParameterWithRequest:request];
    
    NSString *URLString=[NSString zb_stringUTF8Encoding:request.URLString];
    NSURLSessionDataTask *dataTask=nil;
    if (request.methodType==ZBMethodTypeGET) {
        dataTask = [self GET:URLString parameters:request.parameters headers:nil progress:progress success:success failure:failure];
    }else if (request.methodType==ZBMethodTypePOST) {
        dataTask = [self POST:URLString parameters:request.parameters headers:nil progress:progress  success:success failure:failure];
    }else if (request.methodType==ZBMethodTypePUT){
        dataTask = [self PUT:URLString parameters:request.parameters headers:nil success:success failure:failure];
    }else if (request.methodType==ZBMethodTypePATCH){
        dataTask = [self PATCH:URLString parameters:request.parameters headers:nil success:success failure:failure];
    }else if (request.methodType==ZBMethodTypeDELETE){
        dataTask = [self DELETE:URLString parameters:request.parameters headers:nil success:success failure:failure];
    }else{
        dataTask = [self GET:URLString parameters:request.parameters headers:nil progress:progress success:success failure:failure];
    }
    [request setIdentifier:dataTask.taskIdentifier];
    return request.identifier;
}

#pragma mark - upload
- (NSUInteger)uploadWithRequest:(ZBURLRequest *)request
                                progress:(void (^)(NSProgress * _Nonnull))uploadProgressBlock
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    [self requestSerializerConfig:request];
    [self headersAndTimeConfig:request];
    [self printParameterWithRequest:request];
    
    NSURLSessionDataTask *uploadTask = [self POST:[NSString zb_stringUTF8Encoding:request.URLString] parameters:request.parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [request.uploadDatas enumerateObjectsUsingBlock:^(ZBUploadData *obj, NSUInteger idx, BOOL *stop) {
            if (obj.fileData) {
                if (obj.fileName && obj.mimeType) {
                    [formData appendPartWithFileData:obj.fileData name:obj.name fileName:obj.fileName mimeType:obj.mimeType];
                } else {
                    [formData appendPartWithFormData:obj.fileData name:obj.name];
                }
            } else if (obj.fileURL) {
                 NSError *fileError = nil;
                if (obj.fileName && obj.mimeType) {
                    [formData appendPartWithFileURL:obj.fileURL name:obj.name fileName:obj.fileName mimeType:obj.mimeType error:&fileError];
                } else {
                    [formData appendPartWithFileURL:obj.fileURL name:obj.name error:&fileError];
                }
                if (fileError) {
                    *stop = YES;
                }
                
            }
        }];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        uploadProgressBlock ? uploadProgressBlock(uploadProgress) : nil;
    } success:success failure:failure];
    
    [request setIdentifier:uploadTask.taskIdentifier];
    return request.identifier;
}

#pragma mark - DownLoad
- (NSUInteger)downloadWithRequest:(ZBURLRequest *)request
                                             progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                    completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler{
    [self headersAndTimeConfig:request];
    [self printParameterWithRequest:request];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString zb_stringUTF8Encoding:request.URLString]]];
    
    NSURL *downloadFileSavePath;
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:request.downloadSavePath isDirectory:&isDirectory]) {
        isDirectory = NO;
    }
    if (isDirectory) {
        NSString *fileName = [urlRequest.URL lastPathComponent];
        downloadFileSavePath = [NSURL fileURLWithPath:[NSString pathWithComponents:@[request.downloadSavePath, fileName]] isDirectory:NO];
    } else {
        downloadFileSavePath = [NSURL fileURLWithPath:request.downloadSavePath isDirectory:NO];
    }
    NSURLSessionDownloadTask *downloadTask = [self downloadTaskWithRequest:urlRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        downloadProgressBlock ? downloadProgressBlock(downloadProgress) : nil;
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return downloadFileSavePath;
    } completionHandler:completionHandler];
    
    [downloadTask resume];
    
    [request setIdentifier:downloadTask.taskIdentifier];
    return request.identifier;
}

- (NSInteger)networkReachability {
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}
//请求参数的格式
- (void)requestSerializerConfig:(ZBURLRequest *)request{
    self.requestSerializer =request.requestSerializer==ZBHTTPRequestSerializer ?[AFHTTPRequestSerializer serializer]:[AFJSONRequestSerializer serializer];
}

//请求头设置
- (void)headersAndTimeConfig:(ZBURLRequest *)request{
    if ([request.headers allKeys].count>0) {
        [request.headers enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
            [self.requestSerializer setValue:value forHTTPHeaderField:field];
        }];
    }
    self.requestSerializer.timeoutInterval=request.timeoutInterval?request.timeoutInterval:30;
}

#pragma mark - 其他配置
- (void)setupBaseConfig:(ZBConfig *)config{
    if (config.baseURL) {
        self.baseURLString=config.baseURL;
    }
    if (config.timeoutInterval) {
        self.baseTimeoutInterval=config.timeoutInterval;
    }
    if (config.parameters.count>0) {
        [self.baseParameters addEntriesFromDictionary:config.parameters];
    }
    if (config.headers.count>0) {
        [self.baseHeaders addEntriesFromDictionary:config.headers];
    }
    if (config.filtrationCacheKey) {
        [self.baseFiltrationCacheKey addObjectsFromArray:config.filtrationCacheKey];
    }
    if (config.isRequestSerializer==YES) {
        self.baseRequestSerializer=config.requestSerializer;
    }
    if (config.isResponseSerializer==YES) {
        self.baseResponseSerializer=config.responseSerializer;
    }
    if (config.retryCount) {
        self.baseRetryCount=config.retryCount;
    }
    if (config.userInfo) {
        self.baseUserInfo=config.userInfo;
    }
    self.consoleLog=config.consoleLog;
}

- (void)configBaseWithRequest:(ZBURLRequest *)request progressBlock:(ZBRequestProgressBlock)progressBlock successBlock:(ZBRequestSuccessBlock)successBlock failureBlock:(ZBRequestFailureBlock)failureBlock finishedBlock:(ZBRequestFinishedBlock)finishedBlock{
    if (successBlock) {
        [request setValue:successBlock forKey:_successBlock];
    }
    if (failureBlock) {
        [request setValue:failureBlock forKey:_failureBlock];
    }
    if (finishedBlock) {
        [request setValue:finishedBlock forKey:_finishedBlock];
    }
    if (progressBlock) {
        [request setValue:progressBlock forKey:_progressBlock];
    }
     //=====================================================
    NSURL *baseURL = [NSURL URLWithString:self.baseURLString];
            
    if ([[baseURL path] length] > 0 && ![[baseURL absoluteString] hasSuffix:@"/"]) {
                   baseURL = [baseURL URLByAppendingPathComponent:@""];
    }
     
    request.URLString= [[NSURL URLWithString:request.URLString relativeToURL:baseURL] absoluteString];
    //=====================================================
    if (self.baseTimeoutInterval) {
        NSTimeInterval timeout;
        timeout=self.baseTimeoutInterval;
        if (request.timeoutInterval) {
            timeout=request.timeoutInterval;
        }
        request.timeoutInterval=timeout;
    }
    //=====================================================
    if (self.baseParameters.count > 0) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters addEntriesFromDictionary:self.baseParameters];
        if (request.parameters.count > 0) {
            [parameters addEntriesFromDictionary:request.parameters];
        }
        request.parameters = parameters;
    }
    //=====================================================
    if (self.baseHeaders.count > 0) {
        NSMutableDictionary *headers = [NSMutableDictionary dictionary];
        [headers addEntriesFromDictionary:self.baseHeaders];
        if (request.headers) {
            [headers addEntriesFromDictionary:request.headers];
        }
        request.headers = headers;
    }
    //=====================================================
    if (self.baseFiltrationCacheKey.count>0) {
        NSMutableArray *filtrationCacheKey=[NSMutableArray array];
        [filtrationCacheKey addObjectsFromArray:self.baseFiltrationCacheKey];
        if (request.filtrationCacheKey) {
            [filtrationCacheKey addObjectsFromArray:request.filtrationCacheKey];
        }
        request.filtrationCacheKey=filtrationCacheKey;
    }
    //=====================================================
    if (request.isRequestSerializer==NO) {
        request.requestSerializer=self.baseRequestSerializer;
    }
    //=====================================================
    if (request.isResponseSerializer==NO) {
        request.responseSerializer=self.baseResponseSerializer;
    }
    //=====================================================
    if (self.baseRetryCount) {
        NSUInteger retryCount;
        retryCount=self.baseRetryCount;
        if (request.retryCount) {
            retryCount=request.retryCount;
        }
        request.retryCount=retryCount;
    }
    //=====================================================
    if (!request.userInfo && self.baseUserInfo) {
        request.userInfo = self.baseUserInfo;
    }
    //=====================================================
    request.consoleLog = self.consoleLog;
}

- (void)cancelRequestByIdentifier:(NSUInteger)identifier {
    if (identifier == 0) return;
    [self.tasks enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL *stop) {
        if (task.taskIdentifier == identifier) {
            [task cancel];
            *stop = YES;
        }
    }];
}

- (void)cancelAllRequest{
    if (self.tasks.count>0) {
        [self.tasks makeObjectsPerformSelector:@selector(cancel)];
    }
}

- (void)printParameterWithRequest:(ZBURLRequest *)request{
    if (request.consoleLog==YES) {
        NSString *address=[NSString zb_urlString:request.URLString appendingParameters:request.parameters];
        NSString *requestStr=request.requestSerializer==ZBHTTPRequestSerializer ?@"HTTP":@"JOSN";
        NSString *responseStr=request.responseSerializer==ZBHTTPResponseSerializer ?@"HTTP":@"JOSN";
        NSLog(@"\n\n------------ZBNetworking------request info------begin------\n-URLAddress-: %@ \n-parameters-:%@ \n-Header-: %@\n-userInfo-: %@\n-timeout-:%.2f\n-requestSerializer-:%@\n-responseSerializer-:%@\n------------ZBNetworking------request info-------end-------",address,request.parameters, self.requestSerializer.HTTPRequestHeaders,request.userInfo,self.requestSerializer.timeoutInterval,requestStr,responseStr);
   }
}

#pragma mark - request 生命周期管理
- (void)setRequestObject:(id)obj forkey:(NSString *)key{
    if (obj) {
        [_requestDic setObject:obj forKey:key];
    }
}

- (void)removeRequestForkey:(NSString *)key{
    if(!key)return;
    if ([self objectRequestForkey:key]) {
        [_requestDic removeObjectForKey:key];
    }
}

- (id)objectRequestForkey:(NSString *)key{
    if(!key)return nil;
    return [_requestDic objectForKey:key];
}

#pragma mark - Accessor
- (NSMutableDictionary<NSString *, id> *)baseParameters {
    if (!_baseParameters) {
        _baseParameters = [NSMutableDictionary dictionary];
    }
    return _baseParameters;
}

- (NSMutableDictionary<NSString *, NSString *> *)baseHeaders {
    if (!_baseHeaders) {
        _baseHeaders = [NSMutableDictionary dictionary];
    }
    return _baseHeaders;
}
- (NSMutableArray *)baseFiltrationCacheKey {
    if (!_baseFiltrationCacheKey) {
        _baseFiltrationCacheKey = [NSMutableArray array];
    }
    return _baseFiltrationCacheKey;
}

@end
