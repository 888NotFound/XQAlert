//
//  ViewController.swift
//  Demo
//
//  Created by xq on 2022/12/15.
//

import UIKit
import SnapKit
import XQAlert

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTableView()
    }
    
    let tableView = UITableView()
    let cellReuseIdentifier = "tbaleView"
    var data: [String] = ["测试", "测试", "测试", "Sheet",]
    
    
    func initTableView() {
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = self.data[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            XQAlertView.show("标题", message: "消息\n消息\n消息\n消息\n", rightBtnTitle: "右", leftBtnTitle: "左") {
                print("点击右")
            } leftCallback: {
                print("点击左")
            }
            break
            
            
        case 1:
            XQAlertView.show("标题", message: "消息", btnTitle: "按钮") {
                print("点击")
            }
            
        case 2:
            XQCustomAlertView.show(withTitle: "标题", message: "消息", titleArr: ["0", "1"]) { index in
                print("点击: \(index)")
            }
            
        case 3:
            XQCustomSheetAlertView.sheet(withTitle: "标题", message: "消息", dataArr: ["0", "1", "2"], cancelText: "取消") { index in
                print("点击: \(index)")
            } cancelCallback: { index in
                print("点击取消")
            }

            
            
        default:
            break
        }
    }
    
    
}

