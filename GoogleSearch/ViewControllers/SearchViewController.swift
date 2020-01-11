//
//  SearchViewController.swift
//  GoogleSearch
//
//  Created by Deep on 23/11/19.
//  Copyright © 2019 Deep. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var querySearchBar: UISearchBar!
    var searchedText = ""
   fileprivate let GoogleSearchResultsListVCNib = "GoogleSearchResultsListVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.querySearchBar.text = ""
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupSearchBar() {
        self.querySearchBar.delegate = self
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedText = searchText
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return false
    }
    
    
    @IBAction func onTappingSearch(_ sender: Any) {
        let searchListVC = GoogleSearchResultsListVC.init(nibName: GoogleSearchResultsListVCNib, bundle: nil)
        searchListVC.query = searchedText
        searchListVC.modalPresentationStyle = .fullScreen
        self.present(searchListVC, animated: true, completion: nil)
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


