//
//  ContributorViewController.swift
//  MapPrrTask
//
//  Created by ESystems on 28/11/18.
//  Copyright © 2018 Naidu. All rights reserved.
//

import UIKit

class ContributorViewController: UIViewController {

    @IBOutlet weak var contributorImgV: UIImageView!
    @IBOutlet weak var reposTableView: UITableView!
    var reposUrl = String()
    var reposData = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableviewCells()
        loadReposDataWith(url: reposUrl)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private  func registerTableviewCells() {
        reposTableView.register(ReposTableViewCell.self, forCellReuseIdentifier: "ReposTableViewCell")
        reposTableView.register(UINib(nibName: "ReposTableViewCell", bundle: nil), forCellReuseIdentifier: "ReposTableViewCell")
    }
    
    private func loadReposDataWith(url: String) {
        NetworkManager.shared.loadDetailsFromService(with: url) { (response, jsonData, error) in
            if error == nil {
                if let jData = jsonData as? [[String: Any]] {
                    self.reposData = jData
                    DispatchQueue.main.async {
                        if let firstData = self.reposData.first, let owner = firstData["owner"]as? [String: Any], let imageUrl = owner["avatar_url"] as? String {
                            if let url = URL(string: imageUrl) {
                                let data = try? Data(contentsOf: url)
                                self.contributorImgV.image = UIImage(data: data!)
                            }
                    }
                        self.reposTableView.reloadData()
                }
            }
        }
    }
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

//MARK:- Tableview Delegate,DataSource Methods

extension ContributorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return reposData.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReposTableViewCell", for: indexPath) as! ReposTableViewCell
        let repoDataDict = reposData[indexPath.row]
       cell.repoNameLbl.text = repoDataDict["name"] as? String
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repoDescVC = storyboard?.instantiateViewController(withIdentifier: "RepositoryDescriptionViewController") as! RepositoryDescriptionViewController
        let rData = reposData[indexPath.row]
        if let descriptData = rData["description"] as? String {
            repoDescVC.descript = descriptData
        }
        self.navigationController?.pushViewController(repoDescVC, animated: true)
    }
}
