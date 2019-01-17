//
//  DatePickerView.swift
//  DatePickerView
//
//  Created by Jonhory on 2017/3/20.
//  Copyright © 2017年 com.wujh. All rights reserved.
//

import UIKit


import Foundation
import UIKit

fileprivate let SCREEN_WIDTH = UIScreen.main.bounds.size.width
fileprivate let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

/// iPhoneX XR
fileprivate func iPhoneX() -> Bool {
    return (SCREEN_WIDTH == 375.0 && SCREEN_HEIGHT == 812.0) || (SCREEN_WIDTH == 414.0 && SCREEN_HEIGHT == 896.0)
}

/// 34 / 0
fileprivate func TabbarSafeBottomMargin() -> CGFloat { return iPhoneX() ? 34.0 : 0.0 }

class DatePickerViewColorConfig {
    
    class Title {
        var sure: UIColor = .black
        var cancel: UIColor = .darkGray
        var center: UIColor = .red
    }
    
    class Background {
        
        var timePicker: UIColor = .lightGray
        var sure: UIColor = .red
        var cancel: UIColor = .red
        var barView: UIColor = .purple
        var picker: UIColor = .yellow
        var back: UIColor = .black
    }
    
    var title = Title()
    var background = Background()
}

protocol DatePickerViewDelegate: class {
    
    func datePickerSure(_ leftStr: String, rightStr: String, picker: DatePickerView)
    func datePickerCancel(_ picker: DatePickerView)
}

/// 时间选择控件 11:12 - 13:14 isSingle: 单独时间 年月日
class DatePickerView: UIView {
    
    weak var delegate: DatePickerViewDelegate?
    
    /// 时间返回格式 默认HH:mm  isSingle:  yyyy-MM-dd
    var format: String = ""
    /// 单独时间 年月日
    var isSingle: Bool = false
    /// 是否自由选择时间，不进行左右比大小，默认否 右边一定大于左边
    var isFreeTime: Bool = false
    var colorConfig = DatePickerViewColorConfig()
    
    init(frame: CGRect, isSingle: Bool = false, colorConfig: DatePickerViewColorConfig = DatePickerViewColorConfig()) {
        super.init(frame: frame)
        self.isSingle = isSingle
        self.colorConfig = colorConfig
        loadPublicUI()
        if isSingle {
            loadSingleUI()
            format = "yyyy-MM-dd"
        } else {
            loadUI()
            format = "HH:mm"
        }
        self.layoutIfNeeded()
    }
    
    convenience init(isSingle: Bool = true, superView: UIView? = UIApplication.shared.keyWindow) {
        if superView == nil {
            print("DatePickerView: ⚠️ 没有父视图！！！")
            self.init()
            return
        }
        self.init(frame: superView!.bounds, isSingle: isSingle)
        superView!.addSubview(self)
    }
    
    convenience init() {
        self.init(isSingle: true)
    }
    
    public func show() {
        isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.backV.alpha = 0.2
            self.bottomV.frame = CGRect(x: 0, y: self.bounds.height - self.height, width: self.bounds.width, height: self.height)
        }
    }
    
    @objc public func hide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.backV.alpha = 0
            self.bottomV.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: self.height)
        }) { (f) in
            if f {
                self.isHidden = true
            }
        }
    }
    /// 整体背景
    let backV = UIButton()
    /// 底部视图
    let bottomV = UIView()
    /// 确定按钮
    var sureBtn: UIButton!
    /// 取消按钮
    var cancelBtn: UIButton!
    /// 左边时间选择控件
    lazy var leftTime = UIDatePicker()
    /// 右边时间选择控件
    lazy var rightTime = UIDatePicker()
    /// 按钮所在视图高度
    let barHeight: CGFloat = 44
    /// 时间选择控件高度
    let timeHeight: CGFloat = 180
    /// 底部视图高度
    let height: CGFloat = 180 + 44 + TabbarSafeBottomMargin() + 26
    lazy var formatter = DateFormatter()
    
    private func loadPublicUI() {
        backV.frame = bounds
        backV.alpha = 0.0
        backV.backgroundColor = colorConfig.background.back
        backV.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        addSubview(backV)
        
        bottomV.frame = CGRect(x: 0, y: bounds.height, width: bounds.width, height: height)
        bottomV.backgroundColor = colorConfig.background.picker
        addSubview(bottomV)
        
        let barView = UIView(frame: CGRect(x: 0, y: bottomV.bounds.height - height, width: bottomV.bounds.width, height: barHeight))
        barView.backgroundColor = colorConfig.background.barView
        bottomV.addSubview(barView)
        
        
        sureBtn = createBtn("Sure", textColor: colorConfig.title.sure, font: 16, backColor: colorConfig.background.sure, superView: barView)
        sureBtn.frame = CGRect(x: barView.bounds.maxX - SCREEN_WIDTH/4, y: 0, width: SCREEN_WIDTH/4, height: barHeight)
        sureBtn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        
        cancelBtn = createBtn("Cancel", textColor: colorConfig.title.cancel, font: 16, backColor: colorConfig.background.cancel, superView: barView)
        cancelBtn.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH/4, height: barHeight)
        
        cancelBtn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
    }
    
    private func loadSingleUI() {
        leftTime.layer.cornerRadius = 10
        leftTime.layer.masksToBounds = true
        leftTime.backgroundColor = colorConfig.background.timePicker
        leftTime.locale = Locale(identifier: "zh_CN")
        leftTime.datePickerMode = .date
        leftTime.minimumDate = Date()
        leftTime.addTarget(self, action: #selector(dateChange(_:)), for: .valueChanged)
        bottomV.addSubview(leftTime)

        leftTime.frame = CGRect(x: 13, y: 13 + barHeight, width: bottomV.bounds.width - 26, height: timeHeight)
    }
    
    private func loadUI() {
        
        leftTime.layer.cornerRadius = 10
        leftTime.layer.masksToBounds = true
        leftTime.backgroundColor = colorConfig.background.timePicker
        leftTime.datePickerMode = .time
        leftTime.addTarget(self, action: #selector(dateChange(_:)), for: .valueChanged)
        
        rightTime.layer.masksToBounds = true
        rightTime.layer.cornerRadius = 10
        rightTime.backgroundColor = colorConfig.background.timePicker
        rightTime.datePickerMode = .time
        rightTime.addTarget(self, action: #selector(dateChange(_:)), for: .valueChanged)
        
        bottomV.addSubview(leftTime)
        bottomV.addSubview(rightTime)
        
        leftTime.frame = CGRect(x: 13, y: 13 + barHeight, width: bottomV.bounds.width/2 - 26, height: timeHeight)
        
        rightTime.frame = CGRect(x: bottomV.bounds.width/2 + 10, y: 13 + barHeight, width: leftTime.bounds.width, height: leftTime.bounds.height)
        
        let centerL = create(text: "至", color: colorConfig.title.center, font: 16, superView: bottomV)
        centerL.sizeToFit()
        centerL.center = CGPoint(x: center.x, y: leftTime.center.y)
    }
    
    @objc func btnClick(_ btn: UIButton) {
        hide()
        if btn == backV {
            delegate?.datePickerCancel(self)
            return
        }
        
        if btn == cancelBtn { delegate?.datePickerCancel(self) }
        
        if isSingle == false {
            if isFreeTime == false && rightDate.compare(leftDate) == .orderedAscending {
                rightDate = leftDate
            }
            
            if btn == sureBtn {
                formatter.dateFormat = format
                let leftStr = formatter.string(from: leftDate)
                let rightStr = formatter.string(from: rightDate)
                
                delegate?.datePickerSure(leftStr, rightStr: rightStr, picker: self)
            }
        } else {
            if btn == sureBtn {
                formatter.dateFormat = format
                let leftStr = formatter.string(from: leftDate)
                delegate?.datePickerSure(leftStr, rightStr: "", picker: self)
            }
        }
        
    }
    
    /// 最小时间
    var leftDate = Date() {
        didSet {
            leftTime.date = leftDate
        }
    }
    
    /// 最大时间
    var rightDate = Date() {
        didSet {
            rightTime.date = rightDate
        }
    }
    
    @objc func dateChange(_ datePicker: UIDatePicker) {
        let date = datePicker.date
        if datePicker == leftTime {
            leftDate = date
        } else {
            rightDate = date
        }
        
        if isFreeTime == false && rightDate.compare(leftDate) == .orderedAscending {
            rightTime.setDate(leftDate, animated: true)
            rightDate = date
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DatePickerView {
    
    func createBtn(_ text: String, textColor: UIColor, font: CGFloat, backColor: UIColor, superView: UIView) -> UIButton {
        let b = UIButton(type: .custom)
        superView.addSubview(b)
        b.setTitle(text, for: .normal)
        b.setTitleColor(textColor, for: .normal)
        b.backgroundColor = backColor
        b.titleLabel?.font = UIFont.systemFont(ofSize: font)
        b.titleLabel?.adjustsFontSizeToFitWidth = true
        return b
    }
    
    func create(text: String, color: UIColor, font: CGFloat, superView: UIView, numberOfLines: Int = 1) -> UILabel {
        let l = UILabel(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        l.text = text
        l.textColor = color
        l.font = UIFont.systemFont(ofSize: font)
        l.adjustsFontSizeToFitWidth = true
        l.numberOfLines = numberOfLines
        superView.addSubview(l)
        return l
    }
    
}
