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
    
    @IBOutlet weak var peopleTextBox: UITextField!
    
    @IBOutlet weak var timeTextBox: UITextField!
    
    @IBOutlet weak var placeTblView: UITableView!
    
    @IBOutlet weak var resultBtn: UIButton!
    
    
    var toggleStatus: Int = 0
    var srcDataSource: [Place] = []
    var destDataSource: [Place] = []
    var tableDataSource: [Place] = []
    var routeDataSource: [Route] = []
    
    var srcData: Place?
    var destData: Place?
    var isSrchSrcClicked: Bool = false
    var isSrchDestClicked: Bool = false
    
    var isSrchSrcFilledProgrammatically: Bool = false
    var isSrchDestFilledProgrammatically: Bool = false
    
    var searchedText : String = ""
    
    var reqBody : RoutesBody?
    
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
        if self.peopleTextBox.text == ""{
            reqBody!.transport_types[3].selected = true
        }else{
            reqBody!.transport_types[3].selected = false
        }
        reqBody!.start_time = 1588069980000
        reqBody!.start_lat = srcData!.lat
        reqBody!.start_lng = srcData!.lng
        reqBody!.stop_lat = destData!.lat
        reqBody!.stop_lng = destData!.lng
        
        getRoutes()
    }
    
    
    @IBAction func switchBus(_ sender: UISwitch) {
        reqBody!.transport_types[0].selected = sender.isOn
        print(sender.isOn)
    }
    
    @IBAction func switchTrolley(_ sender: UISwitch) {
        reqBody!.transport_types[1].selected = sender.isOn
    }
    
    @IBAction func switchTram(_ sender: UISwitch) {
        reqBody!.transport_types[2].selected = sender.isOn
    }
    
    @IBAction func srcBtn(_ sender: Any) {
        //print("aici")
        //let searchPlaces = SearchResultsViewController()
        //searchPlaces.searchFor = "From"
        //navigationController?.pushViewController(searchPlaces, animated: true)
    }
    
    @IBAction func  goToRslts(_ sender: Any) {
        
    }
    
    func configView(){
        let helper = Helper()
        
        self.filterView.isHidden = true
        self.searchBtn.isHidden = true
        self.placeTblView.isHidden = true
        self.reqBody = helper.getRoutesBody()
    }
    
    func toggleSearchBtn() {
        if self.srchSource.text == "" || self.srchDestination.text == "" {
            self.searchBtn.isHidden = true
        }else{
            self.searchBtn.isHidden = false
        }
    }
    
    func reloadData(){
        self.placeTblView.reloadData()
    }
    
    func checkSrcsBars() -> Bool {
        if self.isSrchSrcClicked && srchSource.text! == "" {
            return true
        }else if self.isSrchDestClicked && srchDestination.text! == "" {
            return true
        }else{
            return false
        }
    }
    
    func toggleDataSources(){
        
        filterDataSource()
        
        if tableDataSource.count == 0 && checkSrcsBars(){
            self.placeTblView.isHidden = true
        }else{
            self.placeTblView.isHidden = false
        }
        
        self.reloadData()
    }
    
    func filterDataSource(){
        if isSrchSrcClicked{
            tableDataSource = srcDataSource.filter({$0.name!.lowercased().contains(searchedText.lowercased()) } ).sorted(by: { $0.name! < $1.name! })
            
        }else if isSrchDestClicked{
            tableDataSource = destDataSource.filter({$0.name!.lowercased().contains(searchedText.lowercased()) } ).sorted(by: { $0.name! < $1.name! })
        }
    }
    
    func getPlacesData(startingWith text: String) {
        let helper = Helper()
        
        helper.getPlaces(startingWith: text)
            .done{ placesResponce -> Void in
                if self.isSrchSrcClicked{
                    self.srcDataSource = placesResponce.places!
                }else if self.isSrchDestClicked{
                    self.destDataSource = placesResponce.places!
                }
                self.toggleDataSources()
                //self.reloadData()
                
            }.catch{ err in
                print("errors occure: \(err)")
        }
    }
    
    func getRoutes() {
        let helper = Helper()
        
        helper.getRoutes(headerBody: reqBody!)
            .done{ routesResponse -> Void in
                self.routeDataSource = routesResponse.routes!
                //self.reloadData()
                print(self.routeDataSource)
            }.catch{ err in
                print("errors occure: \(err)")
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "ShowSearchResults"{
            
            let newController = segue.destination as! SearchResultsViewController
            
            newController.title = "Rute"
            newController.dataSource = self.routeDataSource
            
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

extension CustomSearchViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar == srchSource{
            self.isSrchSrcClicked = true
            self.isSrchDestClicked = false
            if searchBar.text == ""{
                self.tableDataSource = []
                self.reloadData()
            }else{
                self.toggleDataSources()
            }
            
            
        }else if searchBar == srchDestination{
            self.isSrchSrcClicked = false
            self.isSrchDestClicked = true
            if searchBar.text! == ""{
                self.tableDataSource = []
                self.reloadData()
            }else{
                self.toggleDataSources()
            
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar == srchSource{
            if isSrchSrcFilledProgrammatically{
                self.isSrchSrcFilledProgrammatically = false
            
            }else{
                if searchBar.text! == ""{
                    self.srcDataSource = []
                    self.toggleDataSources()
                    self.srcData = nil
                    self.toggleSearchBtn()
                    
                }else if searchBar.text!.count == 1{
                    self.getPlacesData(startingWith: searchBar.text!)
                    
                }else{
                    self.searchedText = searchBar.text!
                    self.filterDataSource()
                    self.reloadData()
                }
                
            }
            
        }else if searchBar == srchDestination{
            if isSrchDestFilledProgrammatically{
                self.isSrchDestFilledProgrammatically = false
            
            }else{
                if searchBar.text! == ""{
                    self.destDataSource = []
                    self.toggleDataSources()
                    self.destData = nil
                    self.toggleSearchBtn()
                
                }else if searchBar.text!.count == 1{
                    self.getPlacesData(startingWith: searchBar.text!)
                
                }else{
                    self.searchedText = searchBar.text!
                    self.filterDataSource()
                    self.reloadData()
                }
            }
        }
    }
}


extension CustomSearchViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tableDataSource.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell") as! PlacesTableViewCell
        
        cell.setPlaceCell(with: tableDataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isSrchSrcClicked{
            self.srcData = tableDataSource[indexPath.row]
            self.isSrchSrcFilledProgrammatically = true
            self.srchSource.text = srcData!.name!
            self.placeTblView.isHidden = true
            
        }else if self.isSrchDestClicked{
            self.destData = tableDataSource[indexPath.row]
            self.isSrchDestFilledProgrammatically = true
            self.srchDestination.text = destData!.name!
            self.placeTblView.isHidden = true
        
        }
        
        toggleSearchBtn()
    }
}

class PlacesTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPlaceName: UILabel!
    @IBOutlet weak var lblPlaceDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setPlaceCell(with place: Place){
        self.lblPlaceName.text = place.name
        if(place.description != nil){
            self.lblPlaceDesc.text = place.description
        }else{
            self.lblPlaceDesc.text = ""
        }
    }
}


