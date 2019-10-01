//
//  ViewController.swift
//  EasyMention
//
//  Created by morteza.ghrdi@gmail.com on 09/29/2019.
//  Copyright (c) 2019 morteza.ghrdi@gmail.com. All rights reserved.
//

import UIKit
import EasyMention

class ViewController: UIViewController {

    @IBOutlet weak var mentionsTextView: EasyMention!
    var mentionItems = [MentionItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
  
        mentionsTextView.mentionDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }


    func getUsersFromFile(query: String,handler: @escaping (([Users]?) -> Void)){
        if let path = Bundle.main.path(forResource: "Users", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .dataReadingMapped)
                let decoder = JSONDecoder()
                let jsonResult = try decoder.decode([Users].self, from: jsonData)
                
                var filtredResult = [Users]()
                filtredResult = query.isEmpty ? jsonResult : jsonResult.filter({ (user) -> Bool in
                     return user.userName.range(of: query, options: .caseInsensitive, range: nil, locale: nil) != nil
                })
                    // If dataItem matches the searchText, return true to include it
               
//                filtredResult = jsonResult.filter{$0.userName.lowercased().contains(query.lowercased())}
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    handler(filtredResult)
                }
            
                
            } catch {
                print("Error parsing jSON: \(error)")
                handler(nil)
            }
        }
    }

    
    
}

extension ViewController: EasyMentionDelegate {
    func mentionSelected(in textView: EasyMention, mention: MentionItem) {
        print(textView.getCurrentMentions())
        
    }
    
    func startMentioning(in textView: EasyMention, mentionQuery: String) {
        self.getUsersFromFile(query: mentionQuery, handler: { (users) in
            self.mentionItems.removeAll()
            users?.forEach({ (user) in
                self.mentionItems.append(MentionItem(name: user.name, userName: user.userName, id: Int(user.id)!, imageURL: user.avatar))
            })
            self.mentionsTextView.setMentions(mentions: self.mentionItems)

            
        })
    }
    
    
}

