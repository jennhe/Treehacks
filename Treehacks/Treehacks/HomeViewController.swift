//
//  SecondViewController.swift
//  Treehacks
//
//  Created by Katie Mishra on 2/16/19.
//  Copyright © 2019 Katie Mishra. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //variables
    var coinNumber: CLong = 50
    var currLevel: Int = 0
    
    let MAXDIST: Float = 100.0
    var currDist: Float = 0.0
    var loaded = false

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaded = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //advances the bar to the curr level
    //fix
    func advance(_ sender: Bool) {
        progressBar.setProgress(currDist, animated: true)
        perform(#selector(updateProgress), with: nil, afterDelay: 0.001)
    }
    
    @objc func updateProgress() {
        currDist = currDist + 0.001
        progressBar.progress = currDist/MAXDIST
        
        if currDist < (Float)(coinNumber) {
            perform(#selector(updateProgress), with: nil, afterDelay: 0.001)
        }
    }


}

