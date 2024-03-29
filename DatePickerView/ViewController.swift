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
    
    @objc func handle(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            datePicker?.show()
        } else {
            datePicker?.hide()
        }
    }
    
    func loadLabel() {
        timeLabel.text = "请选择日期"
        timeLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        timeLabel.center = CGPoint(x: view.center.x, y: view.center.y - 200)
        timeLabel.textColor = UIColor.black
        view.addSubview(timeLabel)
    }
    
    func loadTimeBtn() {
        timeBtn.setTitle("弹出时间选择器", for: .normal)
        timeBtn.setTitle("关闭时间选择器", for: .selected)
        timeBtn.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        timeBtn.center = CGPoint(x: view.center.x, y: view.center.y - 100)
        timeBtn.addTarget(self, action: #selector(handle(_:)), for: .touchUpInside)
        view.addSubview(timeBtn)
    }
    
    func loadDatePicker() {
        if datePicker == nil {
            datePicker = DatePickerView(isSingle: false, superView: view)
            datePicker?.delegate = self
        }
        datePicker?.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

extension ViewController: DatePickerViewDelegate {
    
    func datePickerSure(_ leftStr: String, rightStr: String, picker: DatePickerView) {
        timeLabel.text = leftStr + " - " + rightStr
        timeBtn.isSelected = !timeBtn.isSelected
    }
    
    func datePickerCancel(_ picker: DatePickerView) {
        timeBtn.isSelected = !timeBtn.isSelected
    }
}
