//
//  FeedCell.swift
//  DogLife
//
//  Created by Mustafa Berkay Kaya on 28.08.2020.
//  Copyright © 2020 Berkay Kaya. All rights reserved.
//

import UIKit
import Firebase
class FeedCell: UITableViewCell {

    @IBOutlet weak var feedUserImage: UIImageView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var feedUserNameLabel: UILabel!
    @IBOutlet weak var feedCommentLabel: UILabel!
    @IBOutlet weak var bonesCounterLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func bonesButtonClicked(_ sender: Any) {
        let firestoreDatabase = Firestore.firestore()
        if let likeCount = Int(bonesCounterLabel.text!){
            let likeStore = ["likes":likeCount + 1] as [String:Any]
            firestoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
        }
    }
    @IBAction func dowlandPhoto(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(feedImageView!.image!, nil, nil, nil)
    }
}
