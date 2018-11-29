//
//  RepositoryDescriptionViewController.swift
//  MapPrrTask
//
//  Created by ESystems on 28/11/18.
//  Copyright © 2018 Naidu. All rights reserved.
//

import UIKit

class RepositoryDescriptionViewController: UIViewController {
    @IBOutlet weak var repoDescriptLbl: UILabel!
    var descript = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            repoDescriptLbl.text = descript
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
