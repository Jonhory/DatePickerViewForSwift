//
//  ViewController.swift
//  DatePickerView
//
//  Created by Jonhory on 2017/3/20.
//  Copyright © 2017年 com.wujh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let timeLabel = UILabel()
    let timeBtn = UIButton(type: .system)
    
    var datePicker: DatePickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLabel()
        loadDatePicker()
        loadTimeBtn()
    }
    
    func handle(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            datePicker?.show()
        } else {
            datePicker?.hide()
        }
    }
    
    func loadLabel() {
        timeLabel.text = "请选择日期"
        timeLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        timeLabel.center = CGPoint(x: view.center.x, y: view.center.y - 200)
        timeLabel.textColor = UIColor.black
        view.addSubview(timeLabel)
    }
    
    func loadTimeBtn() {
        timeBtn.setTitle("弹出时间选择器", for: UIControlState())
        timeBtn.setTitle("关闭时间选择器", for: .selected)
        timeBtn.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        timeBtn.center = CGPoint(x: view.center.x, y: view.center.y - 100)
        timeBtn.addTarget(self, action: #selector(handle(_:)), for: .touchUpInside)
        view.addSubview(timeBtn)
    }
    
    func loadDatePicker() {
        datePicker = DatePickerView.addTo(superView: view)
        datePicker?.sureBlock = {[weak self] dateStr in
            print("哈哈哈",dateStr)
            self?.timeLabel.text = dateStr
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

