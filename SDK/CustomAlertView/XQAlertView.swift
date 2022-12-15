//
//  XQAlertView.swift
//  XQAlertDemo
//
//  Created by sinking on 2019/11/23.
//  Copyright © 2019 sinking. All rights reserved.
//

import UIKit
import Masonry


fileprivate var xq_alertView_ :XQAlertView?

/// 弹框view
public class XQAlertView: UIView, UITextViewDelegate {
    
    
    /// 显示弹框
    /// 一定会显示一个按钮
    /// 如果单个按钮, 回调是 callback, 相当于 dismissCallback 是无用的
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 副标题
    ///   - leftBtnTitle: 左边按钮标题
    ///   - rightBtnTitle: 右边按钮标题
    ///   - rightCallback: 点击右边按钮回调
    ///   - leftCallback: 点击左边按钮回调
    @objc public static func show(_ title: String, message: String?, rightBtnTitle: String? = nil, leftBtnTitle: String? = nil, rightCallback: XQAlertViewCallback? = nil, leftCallback: XQAlertViewCallback? = nil) {
        if let _ = xq_alertView_ {
//            print("已存在 alertView")
            return
        }
        
        self.createAlertView()
        
        if let leftBtnTitle = leftBtnTitle, let rightBtnTitle = rightBtnTitle {
            // 两个都存在
            xq_alertView_?.show(title, message: message, leftBtnTitle: leftBtnTitle, rightBtnTitle: rightBtnTitle, callback: rightCallback, dismissCallback: leftCallback)
        }else if let leftBtnTitle = leftBtnTitle {
            // 存在某个
            xq_alertView_?.show(title, message: message, btnTitle: leftBtnTitle, callback: rightCallback)
        }else if let rightBtnTitle = rightBtnTitle {
            // 存在某个
            xq_alertView_?.show(title, message: message, btnTitle: rightBtnTitle, callback: rightCallback)
        }else {
            // 都不存在
            xq_alertView_?.show(title, message: message, btnTitle: "", callback: rightCallback)
        }
        
    }
    
    /// 显示单个按钮弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 副标题
    ///   - btnTitle: 按钮标题
    ///   - callback: 点击右边按钮回调
    ///   - dismissCallback: 点击左边按钮回调
    @objc public static func show(_ title: String?, message: String?, btnTitle: String, callback: XQAlertViewCallback? = nil) {
        if let _ = xq_alertView_ {
//            print("已存在 alertView")
            return
        }
        
        self.createAlertView()
        
        xq_alertView_?.show(title, message: message, btnTitle: btnTitle, callback: callback)
    }
    
    /// 显示弹框, 富文本连接
    /// - Parameters:
    ///   - message: 内容
    ///   - messageLinks: 内容中要显示为可点击链接
    ///   - messageLinkTextAttributes: UITextView.linkTextAttributes 属性,  就是链接富文本的属性. 例如颜色这些
    ///   - textViewDelegate: UITextView 的 代理, 就是监听点击富文本 的
    @objc public static func show(_ title: String, message: String, messageLinks: [String: String], messageLinkTextAttributes: [NSAttributedString.Key : Any] = [:], leftBtnTitle: String?, rightBtnTitle: String?, textViewDelegate: UITextViewDelegate? = nil, callback: XQAlertViewCallback? = nil, dismissCallback: XQAlertViewCallback? = nil) {
        
        let attributedString = NSMutableAttributedString.init(string: message)
        
        // 段落属性
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.alignment = .center
        
        // 添加默认
        attributedString.addAttributes(
            [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor : UIColor.lightGray,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
            ],
            range: NSRange.init(location: 0, length: message.count))
        
        for (key, value) in messageLinks {
            
            if let range = message.range(of: key) {
                let rn = NSRange.init(range, in: message)
                attributedString.addAttributes(
                    [
                        NSAttributedString.Key.link : value,
                    ],
                    range: rn)
            }
        }
        
        self.show(title, message: attributedString, messageLinkTextAttributes: messageLinkTextAttributes, leftBtnTitle: leftBtnTitle, rightBtnTitle: rightBtnTitle, textViewDelegate: textViewDelegate, callback: callback, dismissCallback: dismissCallback)
    }
    
    /// 显示弹框, 富文本
    /// - Parameters:
    ///   - message: 富文本内容
    ///   - messageLinkTextAttributes: UITextView.linkTextAttributes 属性,  就是链接富文本的属性. 例如颜色这些
    ///   - textViewDelegate: UITextView 的 代理, 就是监听点击富文本 的
    @objc public static func show(_ title: String, message: NSAttributedString, messageLinkTextAttributes: [NSAttributedString.Key : Any] = [:], leftBtnTitle: String?, rightBtnTitle: String?, textViewDelegate: UITextViewDelegate? = nil, callback: XQAlertViewCallback? = nil, dismissCallback: XQAlertViewCallback? = nil) {
        self.createAlertView()
        xq_alertView_?.show(title, message: message, messageLinkTextAttributes: messageLinkTextAttributes, leftBtnTitle: leftBtnTitle, rightBtnTitle: rightBtnTitle, textViewDelegate: textViewDelegate, callback: callback, dismissCallback: dismissCallback)
    }
    
    /// 隐藏弹框
    @objc public static func hide() {
        if let xq_alertView = xq_alertView_ {
            xq_alertView.hide()
        }else {
//            print("不存在 alertView")
        }
    }
    
    /// 创建 alert, 并且添加到 window 上
    private static func createAlertView() {
        // 添加到window
        //        let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
        if let window = self.getWindow() {
            xq_alertView_ = XQAlertView()
            window.addSubview(xq_alertView_!)
            xq_alertView_?.mas_makeConstraints({ (make) in
                make?.edges.equalTo()(window)
            })
        }
    }
    
    
    
    /// 获取 window
    private static func getWindow() -> UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    
    public typealias XQAlertViewCallback = () -> ()
    
    private var callback: XQAlertViewCallback?
    private var dismissCallback: XQAlertViewCallback?
    
    /// 黑色背景
    private var backBtn = UIButton()
    
    /// 弹框内容
    private var contentView = UIView()
    /// 内部滚动
    private var contentScrollView = UIScrollView()
    
    /// 标题
    private var titleLab = UILabel()
    
    /// 中间描述
    private var messageView = UIView()
    private var messageTV = UITextView()
    private var messageLab = UILabel()
    
    /// 左右按钮
    private var leftBtn = UIButton()
    private var rightBtn = UIButton()
    
    
    /// 内容 view 宽度比
    private let contentWithScale: CGFloat = 0.8
    
    /// 间距
    private let lr_spacing: CGFloat = 16
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.backBtn)
        
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.contentScrollView)
        self.contentScrollView.addSubview(self.titleLab)
        
        
        self.contentScrollView.addSubview(self.messageView)
        self.messageView.addSubview(self.messageLab)
        self.messageView.addSubview(self.messageTV)
        
        self.contentScrollView.addSubview(self.leftBtn)
        self.contentScrollView.addSubview(self.rightBtn)
        
        // 布局
        
        self.backBtn.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self)
        }
        
        self.contentView.mas_makeConstraints { (make) in
            make?.center.equalTo()(self)
            make?.width.equalTo()(self.mas_width)?.multipliedBy()(self.contentWithScale)
            // 不让超出屏幕高度
            make?.height.lessThanOrEqualTo()(self)?.offset()(-80)?.priorityHigh()
        }
        
        self.contentScrollView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.contentView)
            make?.width.equalTo()(self.contentView)
            make?.left.equalTo()(self.contentView)
            make?.bottom.equalTo()(self.contentView)
        }
        
        // 小布局
        
        let sView = UIView()
        self.contentScrollView.addSubview(sView)
        sView.mas_makeConstraints { (make) in
            make?.width.equalTo()(self.contentScrollView)
            make?.left.right()?.top()?.equalTo()(self.contentScrollView)
        }
        
        self.titleLab.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.contentScrollView)?.offset()(12)
            make?.left.equalTo()(self.contentScrollView)?.offset()(self.lr_spacing)
            make?.right.equalTo()(self.contentScrollView)?.offset()(-self.lr_spacing)
        }
        
        self.messageView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.titleLab.mas_bottom)?.offset()(12)
            make?.left.equalTo()(self.contentScrollView)?.offset()(self.lr_spacing)
            make?.right.equalTo()(self.contentScrollView)?.offset()(-self.lr_spacing)
        }
        
        self.messageLab.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self.messageView)
        }
        
        self.leftBtn.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.messageView.mas_bottom)?.offset()(12)
            make?.left.equalTo()(self.contentScrollView)
            make?.width.equalTo()(self.contentScrollView)?.multipliedBy()(0.5)
            make?.height.mas_equalTo()(44)
            make?.bottom.equalTo()(self.contentScrollView)?.priority()(.required)
        }
        
        self.rightBtn.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.leftBtn)
            make?.right.equalTo()(self.contentScrollView)
            make?.width.equalTo()(self.leftBtn)
            make?.height.equalTo()(self.leftBtn)
        }
        
        
        // 设置属性
        
        self.backBtn.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        self.backBtn.addTarget(self, action: #selector(respondsToBack), for: .touchUpInside)
        
        self.contentScrollView.backgroundColor = UIColor.white
        self.contentScrollView.layer.cornerRadius = 10
        self.contentScrollView.layer.masksToBounds = true
        self.contentScrollView.layer.borderWidth = 1
        self.contentScrollView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.titleLab.numberOfLines = 0
        self.titleLab.textAlignment = .center
        self.titleLab.font = UIFont.boldSystemFont(ofSize: 17)
        self.titleLab.textColor = UIColor.black
        
        self.messageLab.numberOfLines = 0
        self.messageLab.textAlignment = .center
        self.messageLab.font = UIFont.systemFont(ofSize: 14)
        self.messageLab.textColor = UIColor.lightGray
        
        self.messageTV.isHidden = true
        self.messageTV.isEditable = false
        self.messageTV.textAlignment = .center
        self.messageTV.delegate = self
        self.messageTV.font = UIFont.systemFont(ofSize: 14)
        self.messageTV.textColor = UIColor.lightGray
        // 边距
        self.messageTV.textContainerInset = UIEdgeInsets.zero
        self.messageTV.textContainer.lineFragmentPadding = 0
        self.messageTV.isScrollEnabled = false
        
        self.leftBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        self.rightBtn.setTitleColor(UIColor.black, for: .normal)
        
        self.leftBtn.addTarget(self, action: #selector(respondsToLeft(_:)), for: .touchUpInside)
        self.rightBtn.addTarget(self, action: #selector(respondsToRight(_:)), for: .touchUpInside)
        
        self.leftBtn.layer.borderWidth = 0.5
        self.leftBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        self.rightBtn.layer.borderWidth = 0.5
        self.rightBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        // 测试点击
        //        self.titleLab.isUserInteractionEnabled = true
        //        self.titleLab.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(respondsToTap(_:))))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        //        print("大小: ", #function, self.frame, self.contentScrollView.contentSize, self.contentScrollView.frame, self.messageView.frame, self.leftBtn.frame)
        
        // 算 messageView 会比较晚，导致 contentView 高度不对
        // 所以直接拿 self 来算
        if !self.messageTV.isHidden, self.frame.width != 0 {
            
            let width = self.contentWithScale * self.frame.width
            let messageTVWith = width - self.lr_spacing * 2
            self.messageTV.mas_remakeConstraints { (make) in
                make?.edges.equalTo()(self.messageView)
                make?.height.mas_equalTo()(self.calculationMessageTVHeight(messageTVWith))
            }
        }
        
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        //        print("大小: ", #function, self.frame, self.contentScrollView.contentSize, self.contentScrollView.frame, self.messageView.frame, self.leftBtn.frame)
        
        // 0 表示还没布局
        if self.contentScrollView.contentSize.height == 0 {
            return
        }
        
        // 这里取不到 scrollView.frame 的高度的, 所以要取外面的 self 的高度来计算
        // 当前最大高度
        let maxHeight = self.frame.height - 80;
        
        if self.contentScrollView.contentSize.height > maxHeight {
            // 大于, 表示内容超出了
            
            self.contentView.mas_remakeConstraints { (make) in
                make?.center.equalTo()(self)
                make?.width.equalTo()(self.mas_width)?.multipliedBy()(0.8)
                // 不让超出屏幕高度
                make?.height.mas_equalTo()(maxHeight)
            }
            
        }else {
            // 小于, 表示内容还有
            
            self.contentView.mas_remakeConstraints { (make) in
                make?.center.equalTo()(self)
                make?.width.equalTo()(self.mas_width)?.multipliedBy()(0.8)
                // 不让超出屏幕高度
                make?.height.mas_equalTo()(self.contentScrollView.contentSize.height)
                //                make?.height.mas_lessThanOrEqualTo()(maxHeight)
            }
        }
        
    }
    
    /// 显示两个按钮
    private func show(_ title: String?, message: String?, leftBtnTitle: String = "", rightBtnTitle: String = "", callback: XQAlertViewCallback? = nil, dismissCallback: XQAlertViewCallback? = nil) {
        
        self.titleLab.text = title
        self.messageLab.text = message
        
        self.leftBtn.setTitle(leftBtnTitle, for: .normal)
        self.rightBtn.setTitle(rightBtnTitle, for: .normal)
        
        self.callback = callback
        self.dismissCallback = dismissCallback
        
        self.xq_show()
    }
    
    /// 显示单个按钮
    private func show(_ title: String?, message: String?, btnTitle: String = "", callback: XQAlertViewCallback? = nil, dismissCallback: XQAlertViewCallback? = nil) {
        
        self.titleLab.text = title
        self.messageLab.text = message
        
        self.leftBtn.isHidden = true
        self.rightBtn.setTitle(btnTitle, for: .normal)
        self.rightBtn.mas_remakeConstraints({ (make) in
            make?.top.equalTo()(self.messageView.mas_bottom)?.offset()(12)
            make?.left.equalTo()(self.contentScrollView)
            make?.width.equalTo()(self.contentScrollView)
            make?.height.mas_equalTo()(44)
            make?.bottom.equalTo()(self.contentScrollView)?.priority()(.required)
        })
        
        
        self.callback = callback
        self.dismissCallback = dismissCallback
        
        self.xq_show()
    }
    
    /// 显示富文本弹框
    private func show(_ title: String, message: NSAttributedString, messageLinkTextAttributes: [NSAttributedString.Key : Any] = [:],  leftBtnTitle: String?, rightBtnTitle: String?, textViewDelegate: UITextViewDelegate? = nil, callback: XQAlertViewCallback? = nil, dismissCallback: XQAlertViewCallback? = nil) {
        
        self.titleLab.text = title
        self.messageTV.attributedText = message
        self.messageTV.linkTextAttributes = messageLinkTextAttributes
        if let textViewDelegate = textViewDelegate {
            self.messageTV.delegate = textViewDelegate
        }
        
        // 显示 tv, 隐藏 lab
        self.messageTV.isHidden = false
        self.messageLab.isHidden = true
        self.messageLab.mas_remakeConstraints({ (make) in
            make?.top.left()?.equalTo()(self.messageView)
        })
        self.messageTV.mas_remakeConstraints { (make) in
            make?.edges.equalTo()(self.messageView)
        }
        
        if let leftBtnTitle = leftBtnTitle, let rightBtnTitle = rightBtnTitle {
            
            self.leftBtn.setTitle(leftBtnTitle, for: .normal)
            self.rightBtn.setTitle(rightBtnTitle, for: .normal)
            
        }else if let btnTitle = leftBtnTitle {
            self.leftBtn.isHidden = true
            self.rightBtn.setTitle(btnTitle, for: .normal)
            self.rightBtn.mas_remakeConstraints({ (make) in
                make?.top.equalTo()(self.messageView.mas_bottom)?.offset()(12)
                make?.left.equalTo()(self.contentScrollView)
                make?.width.equalTo()(self.contentScrollView)
                make?.height.mas_equalTo()(44)
                make?.bottom.equalTo()(self.contentScrollView)?.priority()(.required)
            })
        }else if let btnTitle = rightBtnTitle {
            self.leftBtn.isHidden = true
            self.rightBtn.setTitle(btnTitle, for: .normal)
            self.rightBtn.mas_remakeConstraints({ (make) in
                make?.top.equalTo()(self.messageView.mas_bottom)?.offset()(12)
                make?.left.equalTo()(self.contentScrollView)
                make?.width.equalTo()(self.contentScrollView)
                make?.height.mas_equalTo()(44)
                make?.bottom.equalTo()(self.contentScrollView)?.priority()(.required)
            })
        }
        
        
        self.callback = callback
        self.dismissCallback = dismissCallback
        
        self.xq_show()
    }
    
    /// 显示
    private func xq_show() {
        self.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
        }) { (result) in
            
        }
    }
    
    /// 隐藏
    private func hide() {
        self.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (result) in
            if (xq_alertView_?.isEqual(self) ?? false) {
                xq_alertView_?.removeFromSuperview()
                xq_alertView_ = nil
            }
        }
    }
    
    /// 计算 tv 高度
    private func calculationMessageTVHeight(_ width: CGFloat) -> CGFloat {
        let drawingOptions = NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue)
        let size = self.messageTV.attributedText.boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: drawingOptions, context: nil)
        //        print("高度: ", #function, size.height)
        return size.height
    }
    
    
    // MARK: - resopnds
    @objc private func respondsToTap(_ gesture: UITapGestureRecognizer) {
        
    }
    
    @objc private func respondsToBack() {
        self.hide()
    }
    
    @objc private func respondsToLeft(_ btn: UIButton) {
        self.dismissCallback?()
        self.hide()
    }
    
    @objc private func respondsToRight(_ btn: UIButton) {
        self.callback?()
        self.hide()
    }
    
    deinit {
        print(#function, self.classForCoder)
    }
    
    // MARK: - UITextViewDelegate
    
    public func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//        print("点击了: ", #function, url, characterRange)
        return true
    }
    
    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//        print("点击了: ", #function, textAttachment, characterRange)
        return true
    }
    
}



