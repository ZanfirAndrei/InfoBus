//
//  StopsViewController.swift
//  Info Bus
//
//  Created by Zorro Andrei on 18/04/2020.
//  Copyright © 2020 ZorroAndrei. All rights reserved.
//

import UIKit

class StopsViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    var dataSource : [AllStops] = []
    var searchedStop : [AllStops] = []
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tvReloadData(){
        self.tblView.reloadData()
    }
    
    func getData(){
        let helper = Helper()
        let target = "station"
        
        helper.getAllStops()
            .done{ allStops -> Void in
                //print("aici")
                self.dataSource = allStops.filter({$0.type!.lowercased().prefix(target.count) == target}).sorted(by:{ $0.name! < $1.name! })
                //print(allStops)
                //print(self.dataSource)
                self.tvReloadData()
                
            }.catch{ err in
                print("errors occure: \(err)")
        }
    }
    
    
    func chooseData() -> [AllStops]{
        if isSearching{
            return self.searchedStop
        }else{
            return self.dataSource
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "StopShowDetails"{
            
            let newController = segue.destination as! StopDetailsViewController
            let cell = sender as! StopsTableViewCell
            let index = self.tblView.indexPath(for: cell)
            let data = chooseData()
            newController.stopId = data[index?.row ?? 0].id
            newController.title = data[index?.row ?? 0].name
            
        }
    }
    
    /*
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension StopsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let data = self.chooseData()
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StopCell") as!  StopsTableViewCell
        
        let data = self.chooseData()
        
        cell.setStopCell(with: data[indexPath.row])
        //cell.accessoryView?.backgroundColor = cell.backgroundColor
        cell.accessoryType = .disclosureIndicator
        //cell.backgroundColor = cell.contentView.backgroundColor
        
        return cell
    }
    
   /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc =
            storyboard?.instantiateViewController(withIdentifier: "StopDetailsViewController") as? StopDetailsViewController
        let data = self.chooseData()
        vc?.stopId = data[indexPath.row].id
        vc?.isStop = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }*/
    
}

extension StopsViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedStop = dataSource.filter({$0.name!.lowercased().contains(searchText.lowercased()) } )
        isSearching = true
        tvReloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        tvReloadData()
    }
    
}

class StopsTableViewCell: UITableViewCell {
    @IBOutlet weak var lblStopName: UILabel!
    @IBOutlet weak var lblStopType: UILabel!
    
    private var stopId : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setStopCell(with stop: AllStops){
        self.lblStopName.text = stop.name
        self.lblStopType.text = stop.type
        self.stopId = stop.id
    }
}
