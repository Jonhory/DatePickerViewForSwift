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
    
    private let animateTime = 1.3
    
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
            self.datePicker?.frame = CGRect(x: 0, y: self.bounds.height - 300, width: self.bounds.width, height: 300)
            self.barView?.frame = CGRect(x: 0, y: self.bounds.height - 300 - self.barHeight, width: self.bounds.width, height: self.barHeight)
        }
    }
    
    func hide() {
        UIView.animate(withDuration: animateTime, animations: {
            self.datePicker?.frame = CGRect(x: 0, y: self.bounds.height + self.barHeight, width: self.bounds.width, height: 300)
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
    
    private let barHeight: CGFloat = 40.0
    private func loadDatePicker() {
        if datePicker == nil {
            let dframe = CGRect(x: 0, y: self.bounds.height + barHeight, width: self.bounds.width, height: 300)
            datePicker = UIDatePicker(frame: dframe)
            datePicker?.datePickerMode = .date
            datePicker?.backgroundColor = UIColor.white
            datePicker?.addTarget(self, action: #selector(datePickerChangeValue), for: .valueChanged)
            addSubview(datePicker!)
            datePickerChangeValue()
            
            barView = UIView()
            barView?.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: barHeight)
            barView?.backgroundColor = UIColor.lightGray
            addSubview(barView!)
            
            cancelBtn = UIButton(type: .custom)
            cancelBtn?.setTitle("取消", for: UIControlState())
            cancelBtn?.addTarget(self, action: #selector(hide), for: .touchUpInside)
            cancelBtn?.setTitleColor(UIColor.blue, for: UIControlState())
            cancelBtn?.frame = CGRect(x: 0, y: 0, width: 80, height: barHeight)
            barView?.addSubview(cancelBtn!)
            
            sureBtn = UIButton(type: .custom)
            sureBtn?.setTitle("确定", for: UIControlState())
            sureBtn?.addTarget(self, action: #selector(sure), for: .touchUpInside)
            sureBtn?.setTitleColor(UIColor.red, for: UIControlState())
            sureBtn?.frame = CGRect(x: (barView?.frame.size.width)! - 80, y: 0, width: 80, height: barHeight)
            barView?.addSubview(sureBtn!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
