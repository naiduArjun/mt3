//
//  RepositoriesTableViewCell.swift
//  MapPrrTask
//
//  Created by ESystems on 27/11/18.
//  Copyright © 2018 Naidu. All rights reserved.
//

import UIKit

class RepositoriesTableViewCell: UITableViewCell {    
    
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var watchersCountLbl: UILabel!
    
    @IBOutlet weak var languageLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setRepoDetails(with data: [String: Any]) {
        if let name = data["name"] as? String {
            nameLbl.text = name
        }
        if let fullNameStr = data["full_name"] as? String {
            fullName.text = fullNameStr
        }
        if let watchersCnt = data["watchers_count"] as? Int {
            watchersCountLbl.text = String(watchersCnt)
        }
        
        if let languageStr = data["language"] as? String {
            languageLbl.text = languageStr
        }
        
        if let owner = data["owner"] as? [String: Any], let imageUrl = owner["avatar_url"] as? String {
            DispatchQueue.global().async {
                if let url = URL(string: imageUrl) {
                    let data = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        self.avatarImg.image = UIImage(data: data!)
                    }
                }
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
