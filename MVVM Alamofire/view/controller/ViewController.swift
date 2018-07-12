//
//  ViewController.swift
//  MVVM Alamofire
//
//  Created by Arifin Firdaus on 7/12/18.
//  Copyright © 2018 Arifin Firdaus. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // MARK: - Injection
    let viewModel = PhotoViewModel(dataService: DataService())
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attemptFetchPhoto(withId: 8)
    }
    
    // MARK: - Networking
    private func attemptFetchPhoto(withId id: Int) {
        viewModel.fetchPhoto(withId: id)
        
        viewModel.updateLoadingStatus = {
            let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
        }
        
        viewModel.showAlertClosure = {
            if let error = self.viewModel.error {
                print(error.localizedDescription)
            }
        }
        
        viewModel.didFinishFetch = {
            self.titleLabel.text = self.viewModel.titleString
            self.subtitleLabel.text = self.viewModel.albumIdString
            self.headerImageView.sd_setImage(with: self.viewModel.photoUrl, completed: nil)
        }
    }
    
    // MARK: - UI Setup
    private func activityIndicatorStart() {
        // Code for show activity indicator view
        // ...
        print("start")
    }
    
    private func activityIndicatorStop() {
        // Code for stop activity indicator view
        // ...
        print("stop")
    }
    
}

