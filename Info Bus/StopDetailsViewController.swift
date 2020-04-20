//
//  StopDetailsViewController.swift
//  Info Bus
//
//  Created by Zorro Andrei on 19/04/2020.
//  Copyright © 2020 ZorroAndrei. All rights reserved.
//

import UIKit

class StopDetailsViewController: UIViewController {

    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblAdress: UILabel!
    
    var lineId : Int?
    var stopId : Int?
    
    var dataSource : Stop = Stop()
    var linesDataSource : [Lines] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        // Do any additional setup after loading the view.
    }
    func reloadData(){
        self.lblAdress.text = "Adresa: \(self.dataSource.description!) "
        self.tblView.reloadData()
        //self.title = dataSource?.name
    }
    
    func getData(){
        let helper = Helper()
        
        helper.getSpecificStop(stop: stopId, line: lineId)
            .done{ specificStop -> Void in
                self.dataSource = specificStop
                self.linesDataSource = specificStop.lines!
                //print("-------- data source --------\n\(self.dataSource)")
                //let list = self.dataSource.lines!
                //print("-------- data source --------\n\(list)")
                self.reloadData()
                
            }.catch{ err in
                print("errors occure: \(err)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension StopDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.linesDataSource.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StopDetailsCell") as!  StopDetailsTableViewCell
        cell.setStopDetailCell(with: self.linesDataSource[indexPath.row])
        return cell
    }
}

class StopDetailsTableViewCell: UITableViewCell{
    @IBOutlet weak var lblTimp: UILabel!
    @IBOutlet weak var lblLine: UILabel!
    
    func convertTime(with rawtime: Int? ) -> String {
        if rawtime == nil{
            return "-"
        }else if rawtime! < 59 {
            return "0min"
        }else{
            let min = Int(rawtime! / 60)
            if min < 59 {
                return "\(min)min"
            }else if min == 60 {
                return "1h"
            }else{
                let h = Int(min / 60)
                let m = Int(min % 60)
                return "\(h)h \(m)min"
            }
        }
        return ""
    }
    func setStopDetailCell(with line: Lines){
        lblTimp.text = convertTime(with: line.arriving_time)
        lblLine.text = " \(line.name!) > \(line.direction_name!)"
    }
    
}
