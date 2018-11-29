//
//  SelectedReposDataViewController.swift
//  MapPrrTask
//
//  Created by ESystems on 27/11/18.
//  Copyright © 2018 Naidu. All rights reserved.
//

import UIKit

class SelectedReposDataViewController: UIViewController {
    
    @IBOutlet weak var personImgV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptLbl: UILabel!
    @IBOutlet weak var contributersCollV: UICollectionView!
    
    var contributorsUrl = String()
    var contributorsData = [[String: Any]]()
    var repositoryData = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignDataToComponants()
        
        // Do any additional setup after loading the view.
    }
    
    func assignDataToComponants() {
        if let owner = repositoryData["owner"] as? [String: Any], let imageUrl = owner["avatar_url"] as? String {
            if let url = URL(string: imageUrl) {
                let data = try? Data(contentsOf: url)
                personImgV.image = UIImage(data: data!)
            }
        }
        if let name = repositoryData["name"] as? String {
            nameLbl.text = name
        }
        if let descript = repositoryData["description"] as? String {
            descriptLbl.text = descript
        }
        if let contributor = repositoryData["contributors_url"] as? String {
            contributorsUrl = contributor
            loadContributorsData(withUrl: contributorsUrl)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadContributorsData(withUrl: String) {
        NetworkManager.shared.loadDetailsFromService(with: withUrl) { (response, jsonData, error) in
            if error == nil {
                if let jData = jsonData as? [[String: Any]] {
                    self.contributorsData = jData
                    DispatchQueue.main.async {
                        self.contributersCollV.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func selectProjectLinkButton(_ sender: UIButton) {
        let webVC = storyboard?.instantiateViewController(withIdentifier: "ReposWebViewController") as! ReposWebViewController
        if let projLinkStr = repositoryData["html_url"] as? String {
            webVC.urlStr = projLinkStr
        }
        self.navigationController?.pushViewController(webVC, animated: true)
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK:- CollectionView Methods

extension SelectedReposDataViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contributorsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContributersCollectionViewCell", for: indexPath) as! ContributersCollectionViewCell
        //Corner Setting
        cell.contributorImgV.layer.cornerRadius = cell.contributorImgV.frame.height/2
        cell.contributorImgV.layer.masksToBounds = true
        //Assigning Data To Cell Fields
        let menuItems = contributorsData[indexPath.item]
        cell.contributorNameLbl.text = menuItems["login"] as? String
        if  let imageUrl = menuItems["avatar_url"] as? String {
            if let url = URL(string: imageUrl) {
                let data = try? Data(contentsOf: url)
                cell.contributorImgV.image = UIImage(data: data!)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.size.width / 4)-0.5
        let height: CGFloat = 110.0
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let contrDataVC = storyboard?.instantiateViewController(withIdentifier: "ContributorViewController") as! ContributorViewController
        let cData = contributorsData[indexPath.item]
        if let rUrl = cData["repos_url"] as? String {
            contrDataVC.reposUrl = rUrl
        }
        self.navigationController?.pushViewController(contrDataVC, animated: true)
        
    }
}

