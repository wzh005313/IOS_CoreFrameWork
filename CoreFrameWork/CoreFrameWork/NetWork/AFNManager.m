//
//  AFNManager.m
//  CoreFrameWork
//
//  Created by wzh on 2016/12/8.
//  Copyright © 2016年 wzh. All rights reserved.
//

#import "AFNManager.h"
#import "AFNetworking.h"
#import "BaseModel.h"

@implementation AFNManager

#pragma mark - 最常用的GET和POST

+ (void)getDataWithAPI:(NSString *)apiName
          andDictParam:(NSDictionary *)dictParam
             modelName:(Class)modelName
      requestSuccessed:(RequestSuccessed)requestSuccessed
        requestFailure:(RequestFailure)requestFailure
              progress:(Progress)pro
{
    NSString *url = kResPathAppBaseUrl;
        [self requestByUrl:url
                   withAPI:apiName
             andArrayParam:nil
              andDictParam:dictParam
              andBodyParam:nil
                 modelName:modelName
               requestType:RequestTypeGET
          requestSuccessed:requestSuccessed
            requestFailure:requestFailure
                  progress:pro
         ];
}

+ (void)postDataWithAPI:(NSString *)apiName
           andDictParam:(NSDictionary *)dictParam
              modelName:(Class)modelName
       requestSuccessed:(RequestSuccessed)requestSuccessed
         requestFailure:(RequestFailure)requestFailure
               progress:(Progress)pro
{
    NSString *url = kResPathAppBaseUrl;
    [self requestByUrl:url withAPI:apiName
         andArrayParam:nil
          andDictParam:dictParam
          andBodyParam:nil
             modelName:modelName
           requestType:RequestTypePOST
      requestSuccessed:requestSuccessed
        requestFailure:requestFailure
              progress:pro
     ];
}


#pragma mark - 自定义url前缀的GET和POST

+ (void)getDataFromUrl:(NSString *)url
               withAPI:(NSString *)apiName
          andDictParam:(NSDictionary *)dictParam
             modelName:(Class)modelName
      requestSuccessed:(RequestSuccessed)requestSuccessed
        requestFailure:(RequestFailure)requestFailure
              progress:(Progress)pro
{
    [self requestByUrl:url withAPI:apiName
         andArrayParam:nil andDictParam:dictParam
          andBodyParam:nil modelName:modelName
           requestType:RequestTypeGET
      requestSuccessed:requestSuccessed
        requestFailure:requestFailure
              progress:pro
     ];
}

+ (void)postDataToUrl:(NSString *)url
              withAPI:(NSString *)apiName
         andDictParam:(NSDictionary *)dictParam
            modelName:(Class)modelName
     requestSuccessed:(RequestSuccessed)requestSuccessed
       requestFailure:(RequestFailure)requestFailure
             progress:(Progress)pro
{
    [self requestByUrl:url withAPI:apiName
         andArrayParam:nil andDictParam:dictParam
          andBodyParam:nil modelName:modelName
           requestType:RequestTypePOST
      requestSuccessed:requestSuccessed
        requestFailure:requestFailure
              progress:pro
     ];
}


#pragma mark - 通用的GET和POST（只返回BaseModel的Data内容）

/**
 *  发起get & post网络请求
 *
 *  @param url              接口前缀 最后的'/'可有可无
 *  @param apiName          方法名称 前面不能有'/'
 *  @param arrayParam       数组参数，用来组装url/param1/param2/param3，参数的顺序很重要
 *  @param dictParam        字典参数，key-value
 *  @param modelName        模型名称字符串
 *  @param requestType      RequestTypeGET 和 RequestTypePOST
 *  @param requestSuccessed 请求成功的回调
 *  @param requestFailure   请求失败的回调
 */
+ (void)requestByUrl:(NSString *)url
             withAPI:(NSString *)apiName
       andArrayParam:(NSArray *)arrayParam
        andDictParam:(NSDictionary *)dictParam
        andBodyParam:(NSString *)bodyParam
           modelName:(Class)modelName
         requestType:(RequestType)requestType
    requestSuccessed:(RequestSuccessed)requestSuccessed
      requestFailure:(RequestFailure)requestFailure
            progress:(Progress)pro
{
    
        [self   requestByUrl:url
                     withAPI:apiName
               andArrayParam:arrayParam
                andDictParam:dictParam
                andBodyParam:bodyParam
                   imageData:nil
                 requestType:requestType
            requestSuccessed: ^(id responseObject)
            {
                BaseModel *baseModel = (BaseModel *)responseObject;
                if (1 == baseModel.state)
                {  //接口访问成功
                    NSObject *dataModel = baseModel.data;
                    JSONModelError *initError = nil;
                    if ( [NSString isNotEmpty:modelName] && [modelName isSubclassOfClass:[BaseDataModel class]])
                    {
                        if ([dataModel isKindOfClass:[NSArray class]])
                        {
                            dataModel = [modelName arrayOfModelsFromDictionaries:(NSArray *)dataModel error:&initError];
                        }
                        else if ([dataModel isKindOfClass:[NSDictionary class]])
                        {
                            dataModel = [[modelName alloc] initWithDictionary:(NSDictionary *)dataModel error:&initError];
                        }
                }
                
                //针对转换映射后的处理
                if (initError)
                {
                    if (requestFailure)
                    {
                        requestFailure(1101, initError.localizedDescription);
                    }
                }
                else
                {
                    if (requestSuccessed)
                    {
                        requestSuccessed(dataModel);//注意：这里dataModel为nil也让它返回
                    }
                }
            }
            else
            {
                if (requestFailure)
                {
                    requestFailure(baseModel.state, baseModel.message);
                }
            }
        }
              requestFailure:requestFailure
                    progress:pro
     ];
}


#pragma mark - 上传文件

+ (void)uploadImage:(UIImage *)image
              toUrl:(NSString *)url
            withApi:(NSString *)apiName
       andDictParam:(NSDictionary *)dictParam
   requestSuccessed:(RequestSuccessed)requestSuccessed
     requestFailure:(RequestFailure)requestFailure
           progress:(Progress)pro
{
    //TODO:resize
    [self requestByUrl:url
               withAPI:apiName
         andArrayParam:nil
          andDictParam:dictParam
          andBodyParam:nil
             imageData:UIImagePNGRepresentation(image)
           requestType:RequestTypeUploadFile
      requestSuccessed:^(id responseObject)
     {
          BaseModel *baseModel = (BaseModel *)responseObject;
          if ([baseModel isKindOfClass:[BaseModel class]])
          {
              if (1 == baseModel.state)
              {  //接口访问成功
                  NSLog(@"success message = %@", baseModel.message);
                  if (requestSuccessed)
                  {
                      requestSuccessed(baseModel);
                  }
              }
              else
              {
                  if (requestFailure)
                  {
                      requestFailure(baseModel.state, baseModel.message);
                  }
              }
          }
          else
          {
              if (requestFailure)
              {
                  requestFailure(1102, @"本地数据映射错误！");
              }
          }
          
      }
        requestFailure:^(NSInteger errorCode, NSString *errorMessage)
        {
          if (requestFailure)
          {
              requestFailure(1103, errorMessage);
          }
      }
        progress:pro
     ];
}

#pragma mark - 通用的GET和POST（返回BaseModel的所有内容）

/**
 *  发起get & post & 上传图片 请求
 *
 *  @param url              接口前缀 最后的'/'可有可无
 *  @param apiName          方法名称 前面不能有'/'
 *  @param arrayParam       数组参数，用来组装url/param1/param2/param3，参数的顺序很重要
 *  @param dictParam        字典参数，key-value
 *  @param imageData        图片资源
 *  @param requestType      RequestTypeGET 和 RequestTypePOST
 *  @param requestSuccessed 请求成功的回调
 *  @param requestFailure   请求失败的回调
 */
+ (void)requestByUrl:(NSString *)url
             withAPI:(NSString *)apiName
       andArrayParam:(NSArray *)arrayParam
        andDictParam:(NSDictionary *)dictParam
        andBodyParam:(NSString *)bodyParam
           imageData:(NSData *)imageData
         requestType:(RequestType)requestType
    requestSuccessed:(RequestSuccessed)requestSuccessed
      requestFailure:(RequestFailure)requestFailure
            progress:(Progress)pro
{
    if (NO == [ReachabilityManager sharedInstance].reachable) {
        requestFailure(-1, @"网络错误！");
        return;
    }
    
    //1. url合法性判断
    if (![NSString isUrl:url]) {
        requestFailure(1005, [NSString stringWithFormat:@"传递的url[%@]不合法！", url]);
        return;
    }
    
    //2. 组装完整的url地址(去掉url最后的'/'字符,去掉apiName前面的'/'字符     )
    NSString *urlString = [[NSString replaceString:url byRegex:@"/+$" to:@""] stringByAppendingFormat:@"/%@",
                           [NSString replaceString:apiName byRegex:@"^/+" to:@""]];
    
    //3. 组装数组参数
    NSMutableString *newUrlString = [NSMutableString stringWithString:urlString];
    for (NSObject *param in arrayParam) {
        [newUrlString appendString:@"/"];
        [newUrlString appendFormat:@"%@",param];
    }
    
    //4. 对提交的dict添加一个加密的参数'signature'
    NSMutableDictionary *newDictParam = [NSMutableDictionary dictionaryWithDictionary:dictParam];
    
    //#if IsNeedSignParams
    NSString *signature = [self signatureWithParam:newDictParam];
    NSLog(@"signature newstring is %@\n",signature);
    
    if ([NSString isNotEmpty:signature]) {//当加密字符串不为空的时候就新增一个参数'signature'
        [newDictParam removeAllObjects];
        [newDictParam setValue:signature forKey:kParamSignature];
    }
    //#endif
    
    //5. 发起网络请求
    // new method for afn 3.0
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//TODO:针对返回数据不规范的情况
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    manager.requestSerializer.timeoutInterval = kDefaultAFNTimeOut;//设置POST和GET的超时时间
    //解决返回的Content-Type始终是application/xml问题！
    [manager.requestSerializer setValue:@"application/xml" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:kParamVersionValue forHTTPHeaderField:kParamVersion];
    [manager.requestSerializer setValue:@"default udid of ios" forHTTPHeaderField:kParamUdid];
    [manager.requestSerializer setValue:kParamFromValue forHTTPHeaderField:kParamFrom];
    
    
    //   定义返回成功的block
    void (^requestSuccessed1)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        //如果返回的数据是编过码的，则需要转换成字符串，方便输出调试
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        }
        responseObject = [NSString replaceString:responseObject byRegex:@"[\r\n\t]" to:@""];
        NSLog(@"request success! \r\n task=%@\r\nresponseObject=%@", task, responseObject);
        JSONModelError *initError;
        BaseModel *baseModel = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            baseModel = [[BaseModel alloc] initWithDictionary:responseObject error:&initError];
        }
        else if ([responseObject isKindOfClass:[NSString class]]) {
            baseModel = [[BaseModel alloc] initWithString:responseObject error:&initError];
        }
        
        if ([NSObject isNotEmpty:baseModel]) {
            if (requestSuccessed) {
                requestSuccessed(baseModel);
            }
        }
        else {
            if (initError) {
                if (requestFailure) {
                    requestFailure(1001, initError.localizedDescription);
                }
                
            }
            else {
                if (requestFailure) {
                    requestFailure(1002, @"本地对象映射出错！");
                }
            }
        }
    };
    
    //   定义返回失败的block
    void (^requestFailure1)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"request failed! \r\no task=%@\r\nerror=%@", task, error);
        NSHTTPURLResponse * response = (NSHTTPURLResponse*)task.response;
        if (200 != response.statusCode) {
            if (401 == response.statusCode) {
                if (requestFailure) {
                    requestFailure(1003, @"401啦");
                }
            }
            else {
                if (requestFailure) {
                    requestFailure(1004, @"网络错误！");
                }
            }
        }
        else {
            if (requestFailure) {
                requestFailure(response.statusCode, error.localizedDescription);
            }
        }
    };

    void (^progress1)(NSProgress * prg) = ^(NSProgress * prg){
        int64_t total       = prg.totalUnitCount;
        int64_t completed   = prg.completedUnitCount;
        
        if (pro) {
            pro(total,completed);
        }
    };
    
    NSLog(@"requestType = %ld, newDictParam = %@", (long)requestType, newDictParam);
    
    // new method for afn 3.0
    if (RequestTypeGET == requestType) {
        NSLog(@"getting data...");
        
        [manager GET:newUrlString
          parameters:newDictParam
            progress:progress1
             success:requestSuccessed1
             failure:requestFailure1];
    }
    else if (RequestTypePOST == requestType) {
        NSLog(@"posting data...");
        [manager POST:newUrlString
           parameters:newDictParam
             progress:progress1
              success:requestSuccessed1
              failure:requestFailure1];
    }
    else if (RequestTypeUploadFile == requestType) {
        NSLog(@"uploading data...");
        [manager POST:newUrlString
           parameters:newDictParam
            constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                [formData appendPartWithFileData:imageData name:@"file" fileName:@"avatar.png" mimeType:@"application/octet-stream"];
            }
             progress:progress1
              success:requestSuccessed1
              failure:requestFailure1];
        
    }
}

/**
 *  对参数进行签名
 *
 *  @param param oldDict
 *
 *  @return signature
 */
+ (NSString *)signatureWithParam:(NSMutableDictionary *)param {
    NSArray *keys = [[param allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    //2. 按照字典顺序拼接url字符串
    NSLog(@"param = %@", param);
    NSMutableString *joinedString = [NSMutableString string];
    for (NSString *key in keys) {
        NSObject *value = param[key];
        if ([kParamSignature isEqualToString:key]) {//不对signature进行加密
            continue;
        }
        //去掉key和value的前后空格字符
        NSString *newKey = Trim(key);
        NSString *newValue = [NSString stringWithFormat:@"%@", [NSObject isEmpty:value] ? @"" : value];
        [joinedString appendFormat:@"%@=%@", newKey, Trim(newValue)];
    }
    
    NSLog(@"joinedString string is now %@",joinedString);
    
    //3. 对参数进行md5加密
    NSString *newString;
    return [[NSString MD5Encrypt:[NSString UTF8Encoded:newString]] lowercaseString];
}

@end
