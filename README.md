# GXTimeSliderView
GXTimeSliderView支持双向调节时间（时间刻度为1小时）

### 创建

```swift
    let sliderView = GXTimeSliderView.init(frame: CGRect(x: 20, y: 100, width: kScreenW - 40, height: 80))
    sliderView.backgroundColor = UIColor.purple
    // 初始较小值
    sliderView.minValue = "04:00"
    // 初始较大值
    sliderView.maxValue = "14:00"
    // 最大数值差（数字变化范围）
    sliderView.maxDelta = 29
    view.addSubview(sliderView)
```
### 数值回调
##### 每次拖动滑块结束的时候都会将当前的有效最小值、最大值传递出来 

```swift
    sliderView.handler = {
    (min, max) in
    // 时间字符串，18:00
    print([min, max])
    }
```
### 其他属性设置
```swift
    /// 较小（大）值label颜色, 默认黑色
    public var labelColor : UIColor = UIColor.black

    /// 较小（大）值label字体， 默认14号字体
    public var labelFont : UIFont = UIFont.systemFont(ofSize: 14)

    /// 按钮宽高，默认20
    public var btnWH : CGFloat = 20 

    /// 按钮背景色, 默认橙色
    public var btnBackgroundColor : UIColor = UIColor.orange 

    /// 按钮背景图片
    public var btnBgImg : UIImage?

    /// 主长线view背景色
    public var mainLineColor : UIColor = UIColor.orange

    /// 主长线(较小值线， 较大值线)view高度
    public var mainLineH : CGFloat = 5

    /// 较小(大)值短线view背景色
    public var valueLineColor : UIColor = UIColor.lightGray
```

