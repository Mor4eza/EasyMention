
//
//  EasyMention.swift
//  EasyMention
//
//  Created by morteza.ghrdi@gmail.com on 09/29/2019.
//  Copyright (c) 2019 morteza.ghrdi@gmail.com. All rights reserved.
//

import UIKit
public protocol EasyMentionDelegate {
    func mentionSelected(in textView: EasyMention, mention: MentionItem)
    func startMentioning(in textView: EasyMention, mentionQuery: String)
}


public class EasyMention : UITextView {
    
    ////////////////////////////////////////////////////////////////////////
    // Public interface
    
    /// Force the results list to adapt to RTL languages
    open var forceRightToLeft = false
    
    // Move the table around to customize for your layout
    open var tableCornerRadius: CGFloat = 5.0
    open var mentionDelegate: EasyMentionDelegate?
    
    open var textViewBorderColor: UIColor = .black {
        didSet {
            self.layer.borderColor = textViewBorderColor.cgColor
        }
    }
    open var textViewBorderWidth: CGFloat = 0.7 {
        didSet {
            self.layer.borderWidth = textViewBorderWidth
            
        }
    }
    
    ////////////////////////////////////////////////////////////////////////
    // Private implementation
    open var currentMentions = [Int :MentionItem ]()
    fileprivate var mentionsIndexes = [Int:Int]()
    fileprivate var keyboardHieght:CGFloat?
    fileprivate var isMentioning = Bool()
    fileprivate var mentionQuery = String()
    fileprivate var startMentionIndex = Int()
    fileprivate var tableView = UITableView()
    fileprivate var timer: Timer? = nil
    fileprivate static let cellIdentifier = "MentionsCell"
    fileprivate var maxTableViewSize: CGFloat = 0
    fileprivate var mentions = [MentionItem]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    fileprivate var filtredMentions = [MentionItem]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView.removeFromSuperview()
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.delegate = self
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = self.textViewBorderWidth
        self.layer.borderColor = self.textViewBorderColor.cgColor
        setupTableView()
        
    }
    
    override open func deleteBackward() {
        super.deleteBackward()
    }
    
    public func setMentions(mentions: [MentionItem]) {
        self.mentions = mentions
        self.filtredMentions = mentions
        
    }
    
    /// get current metions in textView
    ///
    /// - Returns: list of mentions
    public func getCurrentMentions() -> [MentionItem]{
        var mItems = [MentionItem]()
        for (_, mentions) in self.currentMentions {
            mItems.append(mentions)
        }
        return mItems
    }
    
    // Create the filter table
    fileprivate func setupTableView() {
        self.window?.addSubview(tableView)
        
        tableView.layer.masksToBounds = true
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = tableCornerRadius
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        if forceRightToLeft {
            tableView.semanticContentAttribute = .forceRightToLeft
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.isHidden = true
        tableView.register(MentionsCell.self, forCellReuseIdentifier: EasyMention.cellIdentifier)

    }
    
    
    fileprivate func updatePosition(){
        self.tableView.frame.size.height = UIScreen.main.bounds.height - self.keyboardHieght! - self.frame.height
        
    }
}

//MARK:- TableView Delegate

extension EasyMention: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtredMentions.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EasyMention.cellIdentifier, for: indexPath) as? MentionsCell
        
        cell?.mentionItem = filtredMentions[indexPath.row]
        return cell!
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addMentionToTextView(name: filtredMentions[indexPath.row].userName)
        currentMentions[self.startMentionIndex] = filtredMentions[indexPath.row]
        if mentionDelegate != nil {
            self.mentionDelegate?.mentionSelected(in: self, mention: filtredMentions[indexPath.row])
        }
        self.mentionQuery = ""
        self.isMentioning = false
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.isHidden = true
        })
    }
    
}

//MARK:- TextView Delegate

extension EasyMention: UITextViewDelegate {
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        self.mentionDelegate?.startMentioning(in: self, mentionQuery: self.mentionQuery)
    }
    
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let str = String(textView.text)
        var lastCharacter = ""
        
        if !str.isEmpty && range.location != 0{
            lastCharacter = String(str[str.index(before: str.endIndex)])
        }
        
        // when want to delete mention
        if mentionsIndexes.count != 0 {
            let  char = text.cString(using: .utf8)!
            let isBackSpace = strcmp(char, "\\b")
            
            if (isBackSpace == -92) {
                for (index,length) in mentionsIndexes {
                    
                    if case index ... index+length = range.location {
                        // If start typing within a mention rang delete that name:
                      
                        textView.replace(textView.textRangeFromNSRange(range: NSMakeRange(index, length))!, withText: "")
                        mentionsIndexes.removeValue(forKey: index)
                        self.currentMentions.removeValue(forKey: index)
                        
                    }
                    
                }
            }
        }
        
        if isMentioning {
            if text == " " || (text.count == 0 &&  self.mentionQuery == ""){ // If Space or delete the "@"
                self.mentionQuery = ""
                self.isMentioning = false
                self.filtredMentions = mentions
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.tableView.isHidden = true
                    
                })
            }else if text.count == 0 {
                self.mentionQuery.remove(at: self.mentionQuery.index(before: self.mentionQuery.endIndex))
                timer?.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(EasyMention.textViewDidEndEditing(_:)), userInfo: self, repeats: false)
            }else {
                self.mentionQuery += text.lowercased()
                timer?.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(EasyMention.textViewDidEndEditing(_:)), userInfo: self, repeats: false)
                
            }
        } else {
            if text == "@" && ( range.location == 0 || lastCharacter == " ") { /* (Beginning of textView) OR (space then @) */
                //                self.filtredMentions = mentions
                self.isMentioning = true
                self.startMentionIndex = range.location
                UIView.animate(withDuration: 0.2, animations: {
                    self.tableView.isHidden = false
                })
                
            }
        }
        
        
        return true
    }
    
    
    // Add a mention name to the UITextView
    func addMentionToTextView(name: String){
        
        mentionsIndexes[self.startMentionIndex] = name.count
        let range: Range<String.Index> = self.text.range(of: "@" + self.mentionQuery)!
        self.text.replaceSubrange(range, with: name)
        
        let theText = self.text + " "
        //        let theEndIndex = self.startMentionIndex + name.count
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: theText)
        
        for (startIndex, length) in mentionsIndexes {
            // Add attributes for the mention
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: NSMakeRange(startIndex, length))
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 13), range: NSMakeRange(startIndex, length))
        }
        self.attributedText = attributedString
        
        
        
    }
    
}


extension UITextView{
    func textRangeFromNSRange(range:NSRange) -> UITextRange?
    {
        let beginning = self.beginningOfDocument
        guard let start = self.position(from: beginning, offset: range.location), let end = self.position(from: start, offset: range.length) else {
            return self.textRange(from: beginning, to: beginning)
            
        }
        return self.textRange(from: start, to: end)
    }
}
