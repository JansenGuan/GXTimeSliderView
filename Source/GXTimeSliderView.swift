//
//  GXTimeSliderView.swift
//  GXSliderView
//
//  Created by guan_xiang on 2018/11/23.
//  Copyright © 2018 iGola_iOS. All rights reserved.
//

import UIKit

class GXTimeSliderView: UIView {
    /// 数值回调
    public var handler : ((String, String)->())?
    
    /// 最大差值
    public var maxDelta : CGFloat = 24.0{
        didSet{
            let time = hhmmStringToNumber(time: minValue)
            let total = CGFloat(time.hour) + CGFloat(time.min) / 60.0
            minBtn.center.x = total * (mainLine.frame.width - btnWH) / maxDelta + margin + btnWH * 0.5
            minLine.frame.size = CGSize(width: minBtn.center.x, height: mainLineH)

            
            let maxtime = hhmmStringToNumber(time: maxValue)
            let maxtotal = CGFloat(maxtime.hour) + CGFloat(maxtime.min) / 60.0
            maxBtn.center.x = maxtotal * (mainLine.frame.width - btnWH) / maxDelta + margin + btnWH * 0.5
            
            maxLine.frame.origin.x = maxBtn.center.x
            maxLine.frame.size = CGSize(width: self.frame.width - maxBtn.center.x - margin, height: mainLineH)
        }
    }
    
    /// 默认初始最小值
    public var minValue : String = "00:00"{
        didSet{
            minLabel.text = minValue
            
            let time = hhmmStringToNumber(time: minValue)
            let total = CGFloat(time.hour) + CGFloat(time.min) / 60.0
            minBtn.center.x = total * (mainLine.frame.width - btnWH) / maxDelta + margin + btnWH * 0.5
            minLine.frame.size = CGSize(width: minBtn.center.x, height: mainLineH)
        }
    }

    /// 默认初始最大值
    public var maxValue : String = "24:00"{
        didSet{
            maxLabel.text = maxValue
            
            let time = hhmmStringToNumber(time: maxValue)
            let total = CGFloat(time.hour) + CGFloat(time.min) / 60.0
            maxBtn.center.x = total * (mainLine.frame.width - btnWH) / maxDelta + margin + btnWH * 0.5
            
            maxLine.frame.origin.x = maxBtn.center.x
            maxLine.frame.size = CGSize(width: self.frame.width - maxBtn.center.x - margin, height: mainLineH)
            
        }
    }
    
    /// 较小（大）值label颜色, 默认黑色
    public var labelColor : UIColor = UIColor.black{
        didSet{
            minLabel.textColor = labelColor
            maxLabel.textColor = labelColor
        }
    }
    
    /// 较小（大）值label字体， 默认14号字体
    public var labelFont : UIFont = UIFont.systemFont(ofSize: 14){
        didSet{
            minLabel.font = labelFont
            maxLabel.font = labelFont
        }
    }
    
    /// 按钮宽高，默认40
    public var btnWH : CGFloat = 20 {
        didSet{
            minBtn.frame.size = CGSize(width: btnWH, height: btnWH)
            minBtn.layer.cornerRadius = btnWH * 0.5
            minBtn.clipsToBounds = true
            
            maxBtn.frame.size = CGSize(width: btnWH, height: btnWH)
            maxBtn.layer.cornerRadius = btnWH * 0.5
            maxBtn.clipsToBounds = true
        }
    }
    
    /// 按钮背景色, 默认橙色
    public var btnBackgroundColor : UIColor = UIColor.orange {
        didSet{
            minBtn.backgroundColor = btnBackgroundColor
            maxBtn.backgroundColor = btnBackgroundColor
        }
    }
    
    /// 按钮背景图片
    public var btnBgImg : UIImage?{
        didSet{
            minBtn.setBackgroundImage(btnBgImg, for: .normal)
            minBtn.setBackgroundImage(btnBgImg, for: .normal)
        }
    }
    
    /// 主长线view背景色
    public var mainLineColor : UIColor = UIColor.orange{
        didSet{
            mainLine.backgroundColor = mainLineColor
        }
    }
    
    /// 主长线(较小值线， 较大值线)view高度
    public var mainLineH : CGFloat = 5{
        didSet{
            mainLine.frame.size.height = mainLineH
            mainLine.layer.cornerRadius = mainLineH * 0.5
            mainLine.clipsToBounds = true
            
            minLine.frame.size.height = mainLineH
            minLine.layer.cornerRadius = mainLineH * 0.5
            minLine.clipsToBounds = true
            
            maxLine.frame.size.height = mainLineH
            maxLine.layer.cornerRadius = mainLineH * 0.5
            maxLine.clipsToBounds = true
        }
    }
    
    /// 较小(大)值短线view背景色
    public var valueLineColor : UIColor = UIColor.lightGray{
        didSet{
            minLine.backgroundColor = valueLineColor
            maxLine.backgroundColor = valueLineColor
        }
    }
    
    //MARK: - 控件属性
    /// 当前较小值label
    private weak var minLabel : UILabel!
    /// 当前较大值label
    private weak var maxLabel : UILabel!
    /// 较小值滑块btn
    private weak var minBtn : UIButton!
    /// 较大值滑块btn
    private weak var maxBtn : UIButton!
    /// 主长线view
    private weak var mainLine : UIView!
    /// 较小值短线view
    private weak var minLine : UIView!
    /// 较大值短线view
    private weak var maxLine : UIView!
    
    /// 间距 10
    private var margin : CGFloat {
        get{
            return 10
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension GXTimeSliderView{
    @objc private func minPanAction(pan: UIPanGestureRecognizer){
        let localPoint = pan.translation(in: self)
        if pan.state == .changed{
            
            minBtn.center.x = minBtn.center.x + localPoint.x
            if minBtn.center.x < btnWH * 0.5 + margin{
                minBtn.center.x = btnWH * 0.5 + margin
            }else if minBtn.center.x > maxBtn.center.x{
                minBtn.center.x = maxBtn.center.x
            }
            let value = (minBtn.center.x - margin - btnWH * 0.5) * maxDelta / (mainLine.frame.width - btnWH)
            minLabel.text = toHHmmString(with: Int(value + 0.5))
            
        }else if pan.state == .ended{
            getDetalForBtn(with: minBtn)
            
            // 数值回调
            handler?(minLabel.text ?? minValue, maxLabel.text ?? maxValue)
        }
        minLine.frame.size = CGSize(width: minBtn.center.x, height: mainLineH)
        pan.setTranslation(CGPoint.zero, in: self)
    }
    
    @objc private func maxPanAction(pan: UIPanGestureRecognizer){
        let localPoint = pan.translation(in: self)
        if pan.state == .changed{
            
            maxBtn.center.x = maxBtn.center.x + localPoint.x
            if maxBtn.center.x > self.frame.width - margin - btnWH * 0.5{
                maxBtn.center.x = self.frame.width - margin - btnWH * 0.5
            }else if maxBtn.center.x < minBtn.center.x{
                maxBtn.center.x = minBtn.center.x
            }
            let value = (maxBtn.center.x - margin - btnWH * 0.5) * maxDelta / (mainLine.frame.width - btnWH)
            maxLabel.text = toHHmmString(with: Int(value + 0.5))
        
        }else if pan.state == .ended{
            getDetalForBtn(with: maxBtn)
            
            // 数值回调
            handler?(minLabel.text ?? minValue, maxLabel.text ?? maxValue)
        }
        maxLine.frame.origin.x = maxBtn.center.x
        maxLine.frame.size = CGSize(width: self.frame.width - maxBtn.center.x - margin, height: mainLineH)
        pan.setTranslation(CGPoint.zero, in: self)
    }
    
    private func getDetalForBtn(with btn : UIButton){
        let value = (btn.center.x - margin - btnWH * 0.5) * maxDelta / (mainLine.frame.width - btnWH)
        let temp = Int(value + 0.5)
        let tempX = CGFloat(temp) * (mainLine.frame.width - btnWH) / maxDelta + margin + btnWH * 0.5
        btn.center.x = tempX
    }
    
    // 数字转时间
    private func toHHmmString(with value : Int) -> String{
        if value < 10{
            return "0\(value):00"
        }
        return "\(value):00"
    }
    
    private func hhmmStringToNumber(time : String) -> (hour : Int, min : Int){
        guard let hourNumber = time.components(separatedBy: ":").first else {
            return (0,0)
        }
        
        guard let minNumber = time.components(separatedBy: ":").first else {
            return (0,0)
        }
        return (Int(hourNumber) ?? 0, Int(minNumber) ?? 0)
    }
}

//MARK: - UI
extension GXTimeSliderView {
    private func setupSubviews() {
        /// label
        let minLabel = UILabel()
        minLabel.text = "00:00"
        minLabel.font = labelFont
        minLabel.textAlignment = .left
        minLabel.textColor = labelColor
        addSubview(minLabel)
        self.minLabel = minLabel
        
        let maxLabel = UILabel()
        maxLabel.text = "24:00"
        maxLabel.font = labelFont
        maxLabel.textAlignment = .right
        maxLabel.textColor = labelColor
        addSubview(maxLabel)
        self.maxLabel = maxLabel
        
        /// 主长线
        let mainLine = UIView()
        mainLine.backgroundColor = mainLineColor
        mainLine.layer.cornerRadius = mainLineH * 0.5
        mainLine.clipsToBounds = true
        addSubview(mainLine)
        self.mainLine = mainLine
        
        /// 较小值
        let minLine = UIView()
        minLine.backgroundColor = valueLineColor
        minLine.layer.cornerRadius = mainLineH * 0.5
        minLine.clipsToBounds = true
        addSubview(minLine)
        self.minLine = minLine
        
        /// 较大值
        let maxLine = UIView()
        maxLine.backgroundColor = valueLineColor
        maxLine.layer.cornerRadius = mainLineH * 0.5
        maxLine.clipsToBounds = true
        addSubview(maxLine)
        self.maxLine = maxLine
        
        /// 按钮
        let minBtn = UIButton(type: .custom)
        minBtn.backgroundColor = btnBackgroundColor
        minBtn.layer.cornerRadius = btnWH * 0.5
        minBtn.clipsToBounds = true
        addSubview(minBtn)
        self.minBtn = minBtn
        let minPan = UIPanGestureRecognizer(target: self, action: #selector(minPanAction(pan:)))
        minBtn.addGestureRecognizer(minPan)
        
        
        let maxBtn = UIButton(type: .custom)
        maxBtn.backgroundColor = btnBackgroundColor
        maxBtn.layer.cornerRadius = btnWH * 0.5
        maxBtn.clipsToBounds = true
        addSubview(maxBtn)
        self.maxBtn = maxBtn
        let maxPan = UIPanGestureRecognizer(target: self, action: #selector(maxPanAction(pan:)))
        maxBtn.addGestureRecognizer(maxPan)
        
        
        /// label.frame
        minLabel.sizeToFit()
        minLabel.frame.origin.x = margin
        minLabel.frame.size = CGSize(width: (self.frame.width - margin * 2.0) * 0.5 , height: minLabel.frame.height)
        minLabel.center.y = (self.frame.height - minLabel.frame.height - margin) * 0.5
        
        maxLabel.sizeToFit()
        maxLabel.frame.size = CGSize(width: (self.frame.width - margin * 2.0) * 0.5 , height: maxLabel.frame.height)
        maxLabel.frame.origin.x = self.frame.width - margin - maxLabel.frame.width
        maxLabel.center.y = minLabel.center.y
        
        /// btn.frame
        minBtn.frame.size = CGSize(width: btnWH, height: btnWH)
        minBtn.frame.origin = CGPoint(x: margin, y: minLabel.frame.maxY + margin * 0.5)
        
        maxBtn.frame.size = CGSize(width: btnWH, height: btnWH)
        maxBtn.center.y = minBtn.center.y
        maxBtn.frame.origin.x = self.frame.width - margin - btnWH
        
        /// 主长线frame
        mainLine.frame.size = CGSize(width: self.frame.width - margin * 2.0, height: mainLineH)
        mainLine.center.y = minBtn.center.y
        mainLine.frame.origin.x = margin
        
        /// 较小值线frame
        minLine.frame.size = CGSize(width: 0, height: mainLineH)
        minLine.center.y = mainLine.center.y
        minLine.frame.origin.x = margin
        
        /// 较大值线frame
        maxLine.frame.size = CGSize(width: 0, height: mainLineH)
        maxLine.center.y = mainLine.center.y
        maxLine.frame.origin.x = self.frame.width - margin
        
    }
}

