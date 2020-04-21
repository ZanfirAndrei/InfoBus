//
//  CustomSearchViewController.swift
//  Info Bus
//
//  Created by Zorro Andrei on 20/04/2020.
//  Copyright © 2020 ZorroAndrei. All rights reserved.
//

import UIKit

class CustomSearchViewController: UIViewController {

    @IBOutlet weak var srchSource: UISearchBar!
    
    @IBOutlet weak var srchDestination: UISearchBar!
    
    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet weak var searchBtn: UIButton!
    
    var toggleStatus: Int = 0
    var dataStatus: Int = 0
    
    /*
    var srchSource = UISearchBar()
    var srchDestination = UISearchBar()
    var tblView = UITableView()
    var lblNoData = UILabel()
    var btnFilter = UIButton()
    var btnSearch = UIButton()
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleFilterBtn(_ sender: Any) {
        if self.filterView.isHidden{
            self.filterView.isHidden = false
        }else{
            self.filterView.isHidden = true
        }
    }
    
    @IBAction func searchRoute(_ sender: Any) {
    }
    
    func configView(){
        self.filterView.isHidden = true
        self.searchBtn.isHidden = true
    }
    
    func toggleSearchBtn() {
        if self.srchSource.text == "" || self.srchDestination.text == "" {
            self.searchBtn.isHidden = true
        }else{
            self.searchBtn.isHidden = false
        }
    }
    /*
    func configViews(){
        //TODO
        loadSearchBars()
        loadNoDataLbl()
        //loadTableView()
        //loadFilter()
        //loadBtns()
        
        toggleViews()
    }
    func loadSearchBars(){
        srchSource.translatesAutoresizingMaskIntoConstraints = false
        srchDestination.translatesAutoresizingMaskIntoConstraints = false
        //self.view.addSubview(srchSource)
        self.view.addSubview(srchDestination)
        
        //srchSource.placeholder = "Punct de plecare"
        srchDestination.placeholder = "Punct de sosire"
        
        let margins = view.safeAreaLayoutGuide
        
        //srchSource.heightAnchor.constraint(equalToConstant: 50).isActive = true
        srchSource.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        srchSource.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        srchSource.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        srchSource.bottomAnchor.constraint(equalTo: srchSource.topAnchor, constant: 50).isActive = true
        
        //srchDestination.heightAnchor.constraint(equalToConstant: 50).isActive = true
        srchDestination.topAnchor.constraint(equalTo: srchSource.bottomAnchor).isActive = true
        //srchDestination.topAnchor.constraint(equalTo: margins.topAnchor, constant: 50).isActive = true
        srchDestination.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        srchDestination.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        srchDestination.bottomAnchor.constraint(equalTo: srchDestination.topAnchor, constant: 50).isActive = true
        
        srchSource.delegate = self
        srchDestination.delegate = self
        
    }
    
    func loadNoDataLbl(){
        /*self.view.addSubview(lblNoData)
        
        lblNoData.text = " Niciun rezultat! "
        lblNoData.textAlignment = .center
        lblNoData.font.withSize(40)
        
        lblNoData.topAnchor.constraint(equalTo: self.srchDestination.bottomAnchor ).isActive = true
        lblNoData.bottomAnchor.constraint(equalTo: self.view.bottomAnchor ).isActive = true
        lblNoData.leftAnchor.constraint(equalTo: self.view.leftAnchor ).isActive = true
        lblNoData.rightAnchor.constraint(equalTo: self.view.rightAnchor ).isActive = true
        //lblNoData.isHidden = true*/
    }
    
    func toggleViews(){
        
        if toggleStatus == 0 { //initial / default
        
        }else if toggleStatus == 1{ //search source
            
            if dataStatus == 0{ //no data
                
            }else if dataStatus == 1{ // data
                
            }
            
        }else if toggleStatus == 2{ //search destination
            
            if dataStatus == 0{ //no data
                
            }else if dataStatus == 1{ // data
                
            }
            
        }else if toggleStatus == 3{ //filtering
            
        }else if toggleStatus == 4{ //ready
            
        }
    }
    */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CustomSearchViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("aici")
    }
    //func searchbarth
}
