# SBAlertView
高度可定制，高兼容，多标准样式，支持Alert 和 Sheet
# 怎样写一个通用的Alert
## 起源
    开发过程中都会遇到Alert的需求，通常我们会采用UIKit封装实现的Alert，8.0以前的alertview，和以后的alertcontroller，但是系统的alert面对有复杂需求的时候往往束手无策。下面列举特定的需求：

    1.需要一个弹出一个时间选择框，并且添加自定义的控制按钮；

    2.特定排版的富媒体信息，需要文字，图片，甚至视频；

    这个时候系统是一定满足不了我们的，每次去费时费力的单独定制一个又会感觉心累（本人早期就有过这样惨痛的经历），思考写一个通用Alert势在必行了。

## 构思 
    前期的构思非常重要，需要考察Alert需求的方方面面一下是我主要考察方面:
    * 普遍的适应性，因为想要一劳永逸，所以普适行就很关键。
    * 强大的扩展能力，普适性的扩展。
    * 丰富的样式，包括支持sheet和Alert， controller 和 window
    * 支持多Alert叠加，稳定优雅，代码质量方面的考量。
	从这几点出发去量身设计这个框架，首先我们确定需要进行代码的分层设计，分层的好处是显然的，它可以以解耦的方式把我们需要的东西以层层叠加的方式组合在一起，方便扩展和后期维护。
		分层结构：
		1.AlertView，负责Alert内容的渲染和自动布局，主要包含一个自动布局的算法。需要遵守 <AlertDelegate>协议 ，方便外部调动。
		2.<AlertDelegate> ,协议层，定义了AlertView的入口和控制API。
		3.AlertController ，Alert控制器，负责整体Alert的逻辑管理。
		4.AlertQueue ，Alert叠加的缓存队列，先进先出。
	 	为体现了适应能力和扩展能力，我们设计了协议和自动布局设计，每一个自定义的AlertView都应当遵守 <AlertDelegate>协议，供外部调用。并且alertview的内部布局应当准守我们设计的布局方式 ，通过UIView+SBAlertItem 扩展类来完成，alertView内部通过UIView+SBAlertItem提供的公告属性进行自动布局。
## 具体实现
首先看协议:  

```
@protocol SBAlertDelegate 

@required
//展示方式  ， alert 或 sheet 参照 UIAlertController
@property (nonatomic,readonly) UIAlertControllerStyle alertStyle;
//是否显示 因为Alert存在叠加情况 所以这个属性是必须的
@property (nonatomic , getter=isVisible) BOOL visible;
// 内容 item  ，alertview通过items作为内容完成自动布局
@property (nonatomic) NSArray <UIView *> *items;
//布局
- (void)reloadData;
// 消除动画和完成回调
- (void)dissmissAnimationWithCompleted:(void(^)(id <SBAlertDelegate>  alert))completedBlock;
// 展示动画和完成回调
- (void)showAnimationWithCompleted:(void(^)(id <SBAlertDelegate> alert))completedBlock;
// 手动调动 来消除这个  Alert
- (void)dissmiss;

@end
```
自己定义的AlertView遵守协议提供给外部需要的控制API。

AlertView 自动布局：  

```
- (void)reloadData{
    [self alertLayouts];
}
```    

```  
- (void)alertLayouts{
    UIView *previous = nil;
    NSArray *result = [self parallelCombination];
    UIView *baseItem = result[1];
    NSArray *layoutItems = result[0];
    //width
    CGFloat alertWidth = baseItem.sb_itemSize.width+leftDistance+rightDistance;
    alertWidth = alertWidth > ([UIScreen mainScreen].bounds.size.width - alertBoundsDistance*2) ? ([UIScreen mainScreen].bounds.size.width - alertBoundsDistance*2):alertWidth;
    for (int i = 0; i < layoutItems.count; i ++) {
        UIView *item = layoutItems[i];
        //size
        item.frame = CGRectMake(0, 0, item.sb_itemSize.width>alertWidth?alertWidth:item.sb_itemSize.width, item.sb_itemSize.height);
        //center
        //1.通过alertWidth 得到初始 center
        item.center = CGPointMake(alertWidth/2.f, CGRectGetMaxY(previous.frame)+item.sb_itemSize.height/2);
        //2.通过centerOffset 重计算 只计算x坐标
        item.center = CGPointMake(item.center.x+item.sb_centerOffset.x, item.center.y);
        //3.通过boundsInsets 重计算  只计算 自己的top和和previous 的 bottom
        item.center = CGPointMake(item.center.x, item.center.y+item.sb_boundsInsets.top+previous.sb_boundsInsets.bottom);
        //4. 如果是第一个Item
        if (previous == nil) {
            item.center = CGPointMake(item.center.x, item.center.y+topDistance);
        }
        [self addSubview:item];
        //作为previous 结束
        previous = item;
    }
    //height
    CGFloat height = CGRectGetMaxY(previous.frame)+bottomDistance+previous.sb_boundsInsets.bottom;
    if (height > [UIScreen mainScreen].bounds.size.height-140) {
        height = [UIScreen mainScreen].bounds.size.height-140;
    }
    self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-alertWidth)/2, ([UIScreen mainScreen].bounds.size.height-height)/2, alertWidth, height);
}
```
以上就是自动布局关键代码 ，具体可以看代码。^ _ ^

下面是Queue ，存放Alert的队列，队列顶部元素一般为正在显示的Alert。 
 
```
/**
 保存alert所在，可以按序列显示多个alert
 */
@interface SBAlertQueue : NSObject

+ (instancetype)sharedInstance;
// 添加 Alert
- (void)addAlert:(id)alertView;
// 移除 Alert
- (void)removeAlert:(id)alertView;
// Alert Count
- (NSInteger)alertsCount;
//队列顶部Alert
- (id)topAlert;

@end  
```
内部通过一个Array保存添加的Alert，每次显示最上层Alert，dismiss就从Queue移除，再显示最上层Alert。

AlertController  抽象的单例控制器，共有API如下：  

```
/**
 AlertView整体的控制器， 掌控所有Alert的显示和隐藏 ，本身是一个单例
 */
@interface SBAlertController : NSObject

// 是否有 Alert正在显示
@property (nonatomic , getter=isVisible) BOOL visible;
//  当前正在显示的AlertView ，没有显示时 nil
@property (nonatomic,readonly) id <SBAlertDelegate> alertView;
// 通过 style 生成Alert
+ (id <SBAlertDelegate>)alertViewWithStyle:(UIAlertControllerStyle)style;
// 单例
+ (instancetype)shareAlert;
// 展示特定的 alertview
- (void)showAlert:(id <SBAlertDelegate>)alertView;
//使正在显示的Alert消失
- (void)dissmiss;

@end
```
AlertController 内部添加一个全局公用UIWindow ，设置  

```
_alertWindow.windowLevel = UIWindowLevelAlert;
```
作为整个AlertVIew的视图容器，通过切换MainWindow和AlertWindow来实现Alert的show 和 dismiss，这里AlertWindow有大量的坑，还有许多需要注意的细节，下次单独单独的写一篇UIWindow详解。

UIView+SBAlertItem ，作为自动布局的扩展属性，每一个属性将会在自动布局当中体现。

```
@interface UIView (SBAlertItem)
//必须的属性 根据它设置相对布局
@property (nonatomic) CGSize sb_itemSize;
//中心点偏移 一般只调节横坐标 x
@property (nonatomic) CGPoint sb_centerOffset;
//边缘间距 相对于其他item 调节 y,left 和 right 只在 sb_parallelToPrevious 起作用
@property (nonatomic) UIEdgeInsets sb_boundsInsets;
//是否平行于上一个 Item  默认NO ， 为 YES  会与上一个Item平行
@property (nonatomic) BOOL sb_parallel;
// 最宽的基准 ，布局时将会以这个作为基准来设置外部Alert宽度 ，都没有找到将会以最宽item计算 默认 NO
@property (nonatomic) BOOL sb_maxWidthBase;

//#pragma mark   -  Private
//
//@property (nonatomic) NSInteger sb_alertIndex;

@end
```


## 示例
![示例目录](http://macdown.uranusjr.com/static/images/logo-160.png)
  
  这里面定义了几个项目常用的Alert样式，为了方便调用，我用分类的方式来实现了。所以调用像这样：
  
 ```
 [SBAlertController showWithMessage:@"Do any additional setup after loading the view, typically from a nib."];
 
 [SBAlertController showAlertWithTitle:@"Do any additional setup" message:@"Do any additional setup after loading the view, typically from a nib" icon:[UIImage imageNamed:@"tb_download"] completionBlock:^(NSUInteger buttonIndex, id <SBAlertDelegate> alertView) {
                if (buttonIndex == 1) {
                    NSLog(@"sure");
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
 ```
效果如下图：
![效果图1](http://macdown.uranusjr.com/static/images/logo-160.png)  
![效果图1](http://macdown.uranusjr.com/static/images/logo-160.png)  
![效果图1](http://macdown.uranusjr.com/static/images/logo-160.png)  
![效果图1](http://macdown.uranusjr.com/static/images/logo-160.png)  
![效果图1](http://macdown.uranusjr.com/static/images/logo-160.png)  

如果你的Alert将会很复杂，或者它的样式多样无法统一定制，SBAlert将会适合你。

Git地址:  <https://github.com/pubin563783417/SBAlertView>

