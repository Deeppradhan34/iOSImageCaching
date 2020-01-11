//
//  GoogleSearchResultsListVC.swift
//  GoogleSearch
//
//  Created by Deep on 23/11/19.
//  Copyright © 2019 Deep. All rights reserved.
//

import UIKit
import Foundation

typealias CompletionHandler = ((Data?) -> ())?

protocol SearchResultsDataSource: NSObjectProtocol {
    func getDownloadedImage(url: String, completion: CompletionHandler)
}

class GoogleSearchResultsListVC: UIViewController {
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    let viewModel = GoogleSearchResultsViewModel()
    var query = ""
    var indicator = UIActivityIndicatorView()
    fileprivate let SearchResultsTableViewCellNib = "SearchResultsTableViewCell"
    fileprivate let SearchResultsTableViewCellIdentifier = "SearchResultsTableViewCellIdentifier"
    fileprivate let SearchDetailVCViewControllerNib = "SearchDetailVCViewController"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableViewInitialSetUp()
        self.indicator = UIActivityIndicatorView.init(frame: CGRect.init(x: self.view.frame.width/2, y: self.view.frame.height/2, width: 50, height: 50))
        self.definesPresentationContext = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.searchResults.items = []
        
        GoogleSearchResultsViewModel.cachedImage.countLimit = 100
        
        if GoogleSearchResultsViewModel.cachedImage.countLimit > 100 {
            GoogleSearchResultsViewModel.cachedImage.removeAllObjects()
        }
        
        self.showLoader()
        viewModel.fetchSearchResults(searchString: query, completion: { [weak self] (error) in
            
            guard let strongSelf =  self else {return}
            strongSelf.stopLoader()
            if error == nil {
                DispatchQueue.main.async {
                    strongSelf.renderSearchResultsForSuccessState()
                }
            } else {
                DispatchQueue.main.async {
                    strongSelf.renderSearchResultsForFailureState()
                }
            }
            
        })
    }
    
    private func tableViewInitialSetUp() {
        searchResultsTableView.rowHeight = UITableView.automaticDimension
        searchResultsTableView.estimatedRowHeight = 300.0
        searchResultsTableView.backgroundColor = UIColor.clear
        searchResultsTableView.tableFooterView = UIView()
        registerCells()
    }
    
    
    func renderSearchResultsForSuccessState() {
        self.searchResultsTableView.delegate = self
        self.searchResultsTableView.dataSource = self
        self.searchResultsTableView.reloadData()
    }
    
    func renderSearchResultsForFailureState() {
        self.view.backgroundColor = UIColor.white
    }
    
    private func registerCells() {
        let searchResultTableViewCellXib = UINib(nibName: SearchResultsTableViewCellNib, bundle: nil)
        self.searchResultsTableView.register(searchResultTableViewCellXib, forCellReuseIdentifier: SearchResultsTableViewCellIdentifier)
    }
    
    private func showLoader() {
        DispatchQueue.main.async {
            self.indicator.color = UIColor.black
            self.indicator.hidesWhenStopped = true
            self.indicator.startAnimating()
            self.view.addSubview(self.indicator)
        }
        
    }
    
    private func stopLoader() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
        }
    }
    
    @IBAction func onTappingBackButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension GoogleSearchResultsListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.searchResultsTableView.dequeueReusableCell(withIdentifier: SearchResultsTableViewCellIdentifier) as? SearchResultsTableViewCell {
            
            cell.dataSource = self
            if let url = viewModel.searchResults.items?[indexPath.row].pagemap?.cseImage?[0].src, url != "" {
                cell.configureCell(title: viewModel.searchResults.items?[indexPath.row].title ?? "", imageUrl:url)
            } else {
                cell.configureCell(title: viewModel.searchResults.items?[indexPath.row].title ?? "", imageUrl:"")
            }
            return cell
        }
        return UITableViewCell.init()
    }
    
}


extension GoogleSearchResultsListVC: SearchResultsDataSource {
    
    func getDownloadedImage(url: String, completion: CompletionHandler) {
        
        self.viewModel.downloadImage(stringUrl: url, completion: { (data) in
            
            if data != nil {
                completion?(data)
            }
            
        })
        
    }
    
}
