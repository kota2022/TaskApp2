//
//  inputViewController.swift
//  TaskApp
//
//  Created by Tsuji Kota on 30.04.2024.
//

import UIKit
import RealmSwift
import UserNotifications

class inputViewController: UIViewController ,UIPickerViewDelegate ,UIPickerViewDataSource {
    
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let realm = try! Realm()
    var task: Task!
    
   
    var scheduleArray: [String] = [
        "仕事",
        "遊び",
        "家族",
        "勉強",
        "その他"
    ]
    
    var pickerResult:String = "その他"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        
       
        
        
        //背景をタップしたらdissmissKeyboardを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        // Do any additional setup after loading the view.
    }
    
    //============Picker==============
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return scheduleArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return scheduleArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let date1 = scheduleArray[row]
        pickerResult = date1
        
    }
    
    //===========Picker End==========
    
    
    @objc func dissmissKeyboard(){
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text!
            self.task.date = self.datePicker.date
            self.task.category = self.pickerResult
            self.realm.add(self.task, update: .modified)
                
        }
        setNotification(task: task)
        
        super.viewWillDisappear(animated)
        
        
        func setNotification(task: Task){
            let content = UNMutableNotificationContent()
            
            if task.title == ""{
                content.title = "(タイトルなし)"
            }else{
                content.title = task.title
            }
            if task.contents == ""{
                content.body = "(内容なし)"
            } else{
                content.body = task.contents
            }
            content.sound = UNNotificationSound.default
                
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: task.date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: String(task.id.stringValue), content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request){ (error) in
            print(error ?? "ローカル通知登録OK")
            }
            
            center.getPendingNotificationRequests{(request: [UNNotificationRequest])in for request in request {
                print("/---------")
                print(request)
                print("----------/")
                
            }
            }
            
        }
    }
    
    
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    
    
    
    
}
