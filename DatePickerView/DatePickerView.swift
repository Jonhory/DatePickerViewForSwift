//
//  DatePickerView.swift
//  DatePickerView
//
//  Created by Jonhory on 2017/3/20.
//  Copyright © 2017年 com.wujh. All rights reserved.
//

import UIKit

class DatePickerView: UIView {

    let backView = UIButton()
    var datePicker: UIDatePicker?
    
    var barView: UIView?
    var cancelBtn: UIButton?
    var sureBtn: UIButton?
    var dateStr: String!
    
    private let animateTime = 0.68
    private let barHeight: CGFloat = 49.0
    private let pickerHeight: CGFloat = 215
    
    var sureBlock: ((String) -> ())?
    
    //MARK: 初始化
    class func addTo(superView: UIView) -> DatePickerView {
        let pickerView = DatePickerView(frame: CGRect(x: 0, y: 0, width: superView.frame.width, height: superView.frame.height))
        superView.addSubview(pickerView)
        return pickerView
    }
    
    func show() {
        isHidden = false
        
        loadDatePicker()
        
        UIView.animate(withDuration: animateTime) {
            self.datePicker?.frame = CGRect(x: 0, y: self.bounds.height - self.pickerHeight, width: self.bounds.width, height: self.pickerHeight)
            self.barView?.frame = CGRect(x: 0, y: self.bounds.height - self.pickerHeight - self.barHeight, width: self.bounds.width, height: self.barHeight)
        }
    }
    
    func hide() {
        UIView.animate(withDuration: animateTime, animations: {
            self.datePicker?.frame = CGRect(x: 0, y: self.bounds.height + self.barHeight, width: self.bounds.width, height: self.pickerHeight)
            self.barView?.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: self.barHeight)
        }) { (finished) in
            if finished {
                self.isHidden = true
            }
        }
    }
    
    func sure() {
        if self.sureBlock != nil {
            self.sureBlock!(dateStr)
        }
        hide()
    }
    
    func datePickerChangeValue() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateStr = formatter.string(from: (datePicker?.date)!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        loadBackView()
    }
    
    private func loadBackView() {
        addSubview(backView)
        backView.frame = self.bounds
//        backView.backgroundColor = UIColor(red: 151/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.8)
    }
    
    private func loadDatePicker() {
        if datePicker == nil {
            let dframe = CGRect(x: 0, y: self.bounds.height + barHeight, width: self.bounds.width, height: pickerHeight)
            datePicker = UIDatePicker(frame: dframe)
            datePicker?.datePickerMode = .date
            let minDateStr = "19000101"
            let minFormatter = DateFormatter()
            minFormatter.dateFormat = "yyyyMMdd"
            datePicker?.minimumDate = minFormatter.date(from: minDateStr)
            datePicker?.maximumDate = Date()
            datePicker?.backgroundColor = UIColor.white
            datePicker?.addTarget(self, action: #selector(datePickerChangeValue), for: .valueChanged)
            addSubview(datePicker!)
            datePickerChangeValue()
            
            barView = UIView()
            barView?.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: barHeight)
            let backColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
            barView?.backgroundColor = backColor
            addSubview(barView!)
            
            cancelBtn = UIButton(type: .custom)
            cancelBtn?.setTitle("取消", for: UIControlState())
            cancelBtn?.addTarget(self, action: #selector(hide), for: .touchUpInside)
            let cancelColor = UIColor(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1.0)
            cancelBtn?.setTitleColor(cancelColor, for: UIControlState())
            cancelBtn?.frame = CGRect(x: 0, y: 0, width: 80, height: barHeight)
            barView?.addSubview(cancelBtn!)
            
            sureBtn = UIButton(type: .custom)
            sureBtn?.setTitle("确定", for: UIControlState())
            sureBtn?.addTarget(self, action: #selector(sure), for: .touchUpInside)
            let sureColor = UIColor(red: 5/255.0, green: 5/255.0, blue: 5/255.0, alpha: 1.0)
            sureBtn?.setTitleColor(sureColor, for: UIControlState())
            sureBtn?.frame = CGRect(x: (barView?.frame.size.width)! - 80, y: 0, width: 80, height: barHeight)
            barView?.addSubview(sureBtn!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
