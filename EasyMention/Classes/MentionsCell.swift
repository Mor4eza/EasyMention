//
//  MentionsCell.swift
//  EasyMention
//
//  Created by Morteza on 10/1/19.
//

import UIKit

class MentionsCell: UITableViewCell {
    
    
    var mentionItem : MentionItem? {
        didSet{
            nameLabel.text = mentionItem?.name
            userNameLabel.text = mentionItem?.userName
            avatar.imageFromServerURL(mentionItem?.imageUrl ?? "")
        }
    }
    
  lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.gray
        lbl.font = UIFont.systemFont(ofSize: 12)
        return lbl
    }()
    let userNameLabel = UILabel()
   lazy var avatar: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 25
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(userNameLabel)
        self.contentView.addSubview(avatar)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        avatar.translatesAutoresizingMaskIntoConstraints = false
        
        //avatar imageView Constraints
        avatar.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 5).isActive = true
        avatar.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 5).isActive = true
        avatar.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 50).isActive = true
        //username Label Constraints
        userNameLabel.leadingAnchor.constraint(equalTo: self.avatar.trailingAnchor,constant: 10).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 5).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: self.contentView.frame.height / 2) .isActive = true
        userNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        
        //name Label Constraints
        nameLabel.leadingAnchor.constraint(equalTo: self.avatar.trailingAnchor,constant: 10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor,constant: 5).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
     
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
