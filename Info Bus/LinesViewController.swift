//
//  LinesViewController.swift
//  Info Bus
//
//  Created by Zorro Andrei on 15/04/2020.
//  Copyright © 2020 ZorroAndrei. All rights reserved.
//

import UIKit

class LinesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    var dataSource : [AllLines] = []
    var searchedLine : [AllLines] = []
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
        
        helper.getAllLines()
            .done{ allLines -> Void in
                //print(allLines)
                self.dataSource = allLines.lines!
                self.tvReloadData()
                
            }.catch{ err in
                print("errors occure: \(err)")
        }
    }
    
    func chooseData() -> [AllLines]{
            if isSearching{
                return self.searchedLine
            }else{
                return self.dataSource
            }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "LineShowStops"{
            
            let newController = segue.destination as! LineStopsViewController
            
            let cell = sender as! LinesTableViewCell
            let index = self.tblView.indexPath(for: cell)
            let data = self.chooseData()
            newController.title = data[index?.row ?? 0].name
            newController.lineId = data[index?.row ?? 0].id
            
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}

extension LinesViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return searchedLine.count
        }else{
           return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LineCell") as! LinesTableViewCell
        if isSearching{
            cell.setLineCell(with: searchedLine[indexPath.row])
        }else{
            cell.setLineCell(with: dataSource[indexPath.row])
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    
}

extension LinesViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //print("aici")
        searchedLine = dataSource.filter({$0.name!.lowercased().contains(searchText.lowercased()) } )
        isSearching = true
        tvReloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        tvReloadData()
    }
}

class LinesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblLineName: UILabel!
    @IBOutlet weak var lblLineType: UILabel!
    
    private var lineId : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func getId() -> Int{
        return self.lineId!
    }
    
    func setLineCell(with line: AllLines){
        self.lblLineName.text = line.name
        self.lblLineType.text = line.type
        self.lineId = line.id
    }
}
