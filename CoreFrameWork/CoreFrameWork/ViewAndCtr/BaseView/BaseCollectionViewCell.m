//
//  BaseCollectionViewCell.m
//  YSCKit
//
//  Created by yangshengchao on 14-11-4.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "BaseModel.h"
#import "BaseViewController.h"

@implementation BaseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [UIView resetFontSizeOfView:self];              //递归缩放label和button的字体大小
}

+ (CGSize)SizeOfCell {
    return AUTOLAYOUT_SIZE_WH(290, 290);
}
+ (UINib *)NibNameOfCell {
    return [UINib nibWithNibName:NSStringFromClass(self.class) bundle:nil];
}

- (void)layoutDataModel:(BaseDataModel *)dataModel {

}
- (void)layoutDataModels:(NSArray *)dataModelArray {

}

-(void)layoutDataModelN:(NSMutableArray*) layoutDataModelNArray
{
    
}

-(void)setParentCtr:(UIViewController * )viewContr
{
    
}

-(void)setBaseViewCtr:(BaseViewController *)viewCtr
{
    
}

@end
