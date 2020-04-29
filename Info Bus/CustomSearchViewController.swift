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
    
    var isDataRecieved: Bool = false
    var isDataValid: Bool = false
    var isDataProcessed: Bool = false
    
    var defaultNumOfPeople = 30
    var isOkNumOfPeople : Bool = false
    var isOkMaxTime : Bool = false
    
    var errorMessage : String = ""
    
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
        self.isDataValid = false
        
        if !self.isDataRecieved {
            if self.peopleTextBox.text == ""{
                reqBody!.transport_types[3].selected = true
            }else{
                reqBody!.transport_types[3].selected = false
            }
            reqBody!.start_time = 1588596598000
            reqBody!.start_lat = srcData!.lat
            reqBody!.start_lng = srcData!.lng
            reqBody!.stop_lat = destData!.lat
            reqBody!.stop_lng = destData!.lng
            
            getRoutes()
        }else{
            let message = checkData()
            if self.isDataValid {
                self.performSegue(withIdentifier: "ShowSearchResults", sender: self.resultBtn)
            }else{
                self.launchAlert(message: message)
            }
        }
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
    
    func launchAlert(message: String){
        let alert = UIAlertController(title: "Eroare", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Am inteles!", style: .cancel)
        
        alert.addAction(okAction)
        
        self.present(alert,animated: true)
    }
    
    func validateData() -> Bool{
        self.isOkMaxTime = false
        self.isOkNumOfPeople = false
        
        var maxNOP = -1
        var minTime = -1
        
        routeDataSource.forEach { route in
            if maxNOP == -1{
                maxNOP = route.number_of_people!
            }else if maxNOP < route.number_of_people!{
                maxNOP = route.number_of_people!
            }
            let time = Int(route.duration!/60)
            if minTime == -1{
                minTime = time
            }else if minTime < time{
                minTime = time
            }
        }
        if self.peopleTextBox.text! != ""{
            let tBoxMaxNOP = Int(self.peopleTextBox.text!)!
            if maxNOP <= tBoxMaxNOP {
                self.isOkNumOfPeople = true
            }
        }else{
            self.isOkNumOfPeople = true
        }
        
        if self.timeTextBox.text! != ""{
            let tBoxMaxTime = Int(self.timeTextBox.text!)!
            if minTime <= tBoxMaxTime{
                self.isOkMaxTime = true
            }
        }else{
            self.isOkMaxTime = true
        }
        
        if  self.isOkMaxTime && self.isOkNumOfPeople{
            self.errorMessage = ""
            self.isDataValid = true
            return true
        } else{
            
            self.errorMessage = "Nu s-au gasit rute pentru optiunile introduse!"
            
            if  !self.isOkMaxTime{
                self.errorMessage += "\n Timpul minim valabil este: \(minTime) min."
                
            } else if !self.isOkNumOfPeople  {
                
                self.errorMessage += "\n Numarul minim de persoane valabil este: \(maxNOP) persoane."
            }
            self.isDataValid = false
            return false
        }
        
    }
    
    func getRandomnNOP(numMaxim: Int, type: String, numOfStops: Int ) -> Int{
        if type.lowercased() == "walk" {
            return -1
        }else {
            let maxNumber = numMaxim + Int(numMaxim/4)
            let myNumMax = Int(maxNumber/numOfStops)
            let nr = arc4random_uniform(UInt32(myNumMax))
            return Int(nr)
        }
    }
    
    func processData(with maxNumberOfPeople: Int){
        
        var myRoutes :[Route] = []
        var currentIndex = -1
        routeDataSource.forEach{route in
            
            myRoutes.append(route)
            currentIndex += 1
            let numOfstops = route.segments!.filter({!$0.transport_type!.lowercased().contains("walk")}).count
            
            myRoutes[currentIndex].segments! = []
            
            var maxNumOfPeople = -1
            
            route.segments!.forEach{
                var segment = $0
                let nrOfPeople = getRandomnNOP(numMaxim: maxNumberOfPeople, type: $0.transport_type!, numOfStops: numOfstops)
                if nrOfPeople == -1{
                    segment.number_of_people = 0
                    
                    if maxNumOfPeople == -1{
                        maxNumOfPeople = 0
                    }else if maxNumOfPeople < 0{
                        maxNumOfPeople = 0
                    }
                    
                }else{
                    if maxNumOfPeople == -1{
                        maxNumOfPeople = nrOfPeople
                    }else if maxNumOfPeople < nrOfPeople{
                        maxNumOfPeople = nrOfPeople
                    }
                }
                
                myRoutes[currentIndex].segments!.append(segment)
            }
            myRoutes[currentIndex].number_of_people = maxNumberOfPeople
        }
        
        self.isDataProcessed = true
        self.routeDataSource = myRoutes
    }
    
    func checkData() -> String{
        if isDataProcessed{
            if validateData(){
                return ""
            }else{
                return self.errorMessage
            }
        }else{
            var numberOfpeople = 0
            if self.peopleTextBox.text! != ""{
                numberOfpeople = Int(self.peopleTextBox.text!)!
            }else{
                numberOfpeople = self.defaultNumOfPeople
            }
            processData(with: numberOfpeople)
            
            if validateData(){
                return ""
            }else{
                return self.errorMessage
            }
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
                
                if self.routeDataSource.count == 0{
                    self.launchAlert(message: "Nu s-au gasit date pentru optiunile introduse!\n Introduceti alte oprioni!")
                }
                else{
                    self.isDataRecieved = true
                    let message = self.checkData()
                    
                    if self.isDataValid {
                        self.performSegue(withIdentifier: "ShowSearchResults", sender: self.resultBtn)
                    }else{
                        self.launchAlert(message: message)
                        //alerta
                    }
                }
                //self.resultBtn.sendActions(for: .touchUpInside)
                
                //self.performSegue(withIdentifier: "ShowSearchResults", sender: self.resultBtn)
                //self.reloadData()
                //print(self.routeDataSource)
            }.catch{ err in
                print("errors occure: \(err)")
        }
    }
    

    
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


