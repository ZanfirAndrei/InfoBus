//
//  LineStopsViewController.swift
//  Info Bus
//
//  Created by Zorro Andrei on 20/04/2020.
//  Copyright © 2020 ZorroAndrei. All rights reserved.
//

import UIKit

class LineStopsViewController: UIViewController {

    @IBOutlet weak var lblTur: UILabel!
    @IBOutlet weak var lblRetur: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    
    var lineId: Int?
    var loadingData: Int = 0
    var toggle: Int = 0
    var plecare: String?
    var sosire: String?
    
    var bothSides: [Stops] = []
    var tur: [Stops] = []
    var retur: [Stops] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func fncBothSides(_ sender: Any) {
        self.toggleDirection(with: 0)
    }
    
    @IBAction func fncTur(_ sender: Any) {
        self.toggleDirection(with: 1)
    }
    
    @IBAction func fncRetur(_ sender: Any) {
        self.toggleDirection(with: 2)
    }
    
    
    
    func reloadData(){
        self.tblView.reloadData()
        
    }
    
    func incrementLoadingData(){
        loadingData += 1
        if loadingData == 3{
            self.lblTur.text = "Tur: \(self.plecare!) > \(self.sosire!)"
            self.lblRetur.text = "Retur: \(self.sosire!) > \(self.plecare!)"
            reloadData()
        }
    }
    
    func getData(){
        getBothDirections()
        getTur()
        getRetur()
    }
    
    func toggleDirection(with value: Int?)
    {
        if value != nil{
            if self.toggle != value!{
                if value == 0 { // amblele directii
                    self.toggle = 0
                    
                    self.lblTur.text = "Tur: \(self.plecare!) > \(self.sosire!)"
                    self.lblRetur.text = "Retur: \(self.sosire!) > \(self.plecare!)"
                    
                }else if value! == 1{//tur
                    self.toggle = 1
                    
                    self.lblTur.text = "Tur: \(self.plecare!) > \(self.sosire!)"
                    self.lblRetur.text = ""
                    
                }else if value! == 2{//retur
                    self.toggle = 2
                    
                    self.lblTur.text = "Retur: \(self.sosire!) > \(self.plecare!)"
                    self.lblRetur.text = ""
                }
                reloadData()
            }
        }
    }
    
    func chooseData()-> [Stops] {
        if self.toggle == 0{
            return self.bothSides
        }else if self.toggle == 1{
            return self.tur
        }else if self.toggle == 2{
            return self.retur.reversed()
        }
        return []
    }
    
    func getBothDirections(){
        let helper = Helper()
        
        helper.getStopsByLine(line: lineId!, requestType: 0)
            .done{ response -> Void in
                self.plecare = response.direction_name_retur!
                self.sosire = response.direction_name_tur!
                self.bothSides = response.stops!
                self.incrementLoadingData()
            }.catch{ err in
                print("errors occure: \(err)")
        }
    }
    
    func getTur(){
        let helper = Helper()
        
        helper.getStopsByLine(line: lineId!, requestType: 1)
            .done{ response -> Void in
                
                self.tur = response.stops!
                self.incrementLoadingData()
            }.catch{ err in
                print("errors occure: \(err)")
        }
    }
    func getRetur(){
        let helper = Helper()
        
        helper.getStopsByLine(line: lineId!, requestType: 2)
            .done{ response -> Void in
                
                self.retur = response.stops!
                self.incrementLoadingData()
            }.catch{ err in
                print("errors occure: \(err)")
        }
    }

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "LineStopDetails"{
            
            let newController = segue.destination as! StopDetailsViewController
            let cell = sender as! LineStopTableViewCell
            let index = self.tblView.indexPath(for: cell)
            let data = chooseData()
            newController.stopId = data[index?.row ?? 0].id
            newController.lineId = self.lineId
            newController.title = data[index?.row ?? 0].name
            
        }
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

extension LineStopsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = self.chooseData()
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LineStopCell") as! LineStopTableViewCell
        let data = self.chooseData()
        
        cell.setLineStopCell(with: data[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
}

class LineStopTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAdresa: UILabel!
    
    private var stopId : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func getId() -> Int{
        return self.stopId!
    }
    
    func setLineStopCell(with stop: Stops){
        self.lblName.text = stop.name
        self.lblAdresa.text = stop.description
        self.stopId = stop.id
    }
}
