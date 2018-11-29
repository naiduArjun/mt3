//
//  ViewController.swift
//  MapPrrTask
//
//  Created by ESystems on 26/11/18.
//  Copyright © 2018 Naidu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var repositoriesTableView: UITableView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var filterViewHc: NSLayoutConstraint!
    @IBOutlet weak var nameSwitch: UISwitch!
    @IBOutlet weak var fullNameSwitch: UISwitch!
    @IBOutlet weak var filterView: UIView!
    
    var isNameFltrSelected = true
    var isFullNameFltrSelected = false
    var isFilterSelected = false
    
    var repoCellId = "RepositoriesTableViewCell"
    var isSearchBarActive = false
    var filteredData = [[String: Any]]()
    var repoData = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerTableviewCells()
        loadRepositoriesData()
        filterViewHc.constant = 0
        
        

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private  func registerTableviewCells() {
        repositoriesTableView.register(RepositoriesTableViewCell.self, forCellReuseIdentifier: repoCellId)
        repositoriesTableView.register(UINib(nibName: "RepositoriesTableViewCell", bundle: nil), forCellReuseIdentifier: repoCellId)
    }
    
    private func loadRepositoriesData() {
        let urlStr = "https://api.github.com/search/repositories?q=swift&sort=stars&order=desc"
        NetworkManager.shared.loadDetailsFromService(with: urlStr) { (response, jsonData, error) in
            
            if error == nil {
                if let jsonD = jsonData {
                    if let items = jsonD["items"] as? [[String: Any]] {
                        self.repoData = items
                        DispatchQueue.main.async {
                            self.repositoriesTableView.reloadData()
                        }
                    }
                }
            }
            print(self.repoData.first!["full_name"] as Any)
        }
    }

    @IBAction func filterButtonAction(_ sender: UIButton) {
        if isFilterSelected == true {
            filterViewHc.constant = 0
            isFilterSelected = false
        }else{
            filterViewHc.constant = 60
            isFilterSelected = true

        }
        
    }
    
    @IBAction func filterSwitchesActions(_ sender: UISwitch) {
        if sender == nameSwitch {
            if sender.isOn == true {
                isNameFltrSelected = true
                isFullNameFltrSelected = false
                fullNameSwitch.isOn = false
            }else {
                isNameFltrSelected = false
                isFullNameFltrSelected = true
                fullNameSwitch.isOn = true
            }
        }else if sender == fullNameSwitch {
            if sender.isOn == true {
                isNameFltrSelected = false
                isFullNameFltrSelected = true
                nameSwitch.isOn = false
            }else {
                isNameFltrSelected = true
                isFullNameFltrSelected = false
                nameSwitch.isOn = true
            }
        }
        
    }
    
    
}

//MARK:- Tableview Delegate,DataSource Methods

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if filteredData.count>=10 {
                return 10
            }
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: repoCellId, for: indexPath) as! RepositoriesTableViewCell
            if indexPath.row <= 9 {
                cell.setRepoDetails(with: filteredData[indexPath.row])
            }
        cell.selectionStyle = .none       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let repoDataVc = storyboard?.instantiateViewController(withIdentifier: "SelectedReposDataViewController") as! SelectedReposDataViewController
        repoDataVc.repositoryData = filteredData[indexPath.row]
        self.navigationController?.pushViewController(repoDataVc, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchBarActive = true
        repositoriesTableView.reloadData()

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearchBarActive = false
        repositoriesTableView.reloadData()
        searchBar.resignFirstResponder()

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = repoData.filter({ (rData) -> Bool in
            var searchKey = String()
            if isNameFltrSelected == true {
               if let nameKey = rData["name"] as? String {
                    searchKey = nameKey
                }
                print(searchKey)
            }else if isFullNameFltrSelected == true {
                if let key = rData["language"] as? String {
                    searchKey = key
                }
                print(searchKey)
            }
            return (searchKey.lowercased().contains(searchText.lowercased()))
            })
       
        if(filteredData.count == 0){
            isSearchBarActive = false;
        } else {
            print(filteredData)
            filteredData = filteredData.sorted{ ($1["watchers"] as? Int)! < ($0["watchers"] as? Int)!}
            isSearchBarActive = true;
        }
        repositoriesTableView.reloadData()

    }
}
