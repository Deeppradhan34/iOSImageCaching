//
//  SearchResultsTableViewCell.swift
//  GoogleSearch
//
//  Created by Deep on 23/11/19.
//  Copyright © 2019 Deep. All rights reserved.
//

import UIKit

struct SearchResultsKeys {
    static let placeholder = "placeholder"
}

class SearchResultsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchedImageView: UIImageView!
    @IBOutlet weak var searchInfoLabel: UILabel!
    
    var cachedData: Data?
    var dataSource: SearchResultsDataSource?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(title: String, imageUrl: String) {
        searchInfoLabel.text = title
        self.searchedImageView.image = UIImage.init(named: SearchResultsKeys.placeholder)
        if imageUrl != "" {
            dataSource?.getDownloadedImage(url: imageUrl, completion: {[weak self] (data) in
                if let imageData = data as Data? {
                    let image = UIImage(data: imageData)
                    
                    DispatchQueue.main.async() {
                        self?.searchedImageView.image = image
                    }
                }
            })
        }
    }
}


