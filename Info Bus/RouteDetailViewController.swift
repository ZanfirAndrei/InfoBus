//
//  RouteDetailViewController.swift
//  Info Bus
//
//  Created by Zorro Andrei on 29/04/2020.
//  Copyright © 2020 ZorroAndrei. All rights reserved.
//

import UIKit

class RouteDetailViewController: UIViewController {

    var segmentDataSource : [Segment] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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


extension RouteDetailViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return segmentDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //var index : Int
        print(segmentDataSource[section].transport_type!)
        if segmentDataSource[section].transport_type!.lowercased() == "walk"{
            //index = 1
            return 1
        }else{
            //index = segmentDataSource[section].stops!.count
            return segmentDataSource[section].stops!.count
        }
        
        //return index
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "segmentDetailCell")!
        //var data : String
        if segmentDataSource[indexPath.section].transport_type!.lowercased() == "walk"{
            let src = segmentDataSource[indexPath.section].stops![0].name!
            let dest = segmentDataSource[indexPath.section].stops![1].name!
            //data = src + " -> " + dest
            cell.textLabel?.text = "\(src) -> \(dest)"
        } else {
            //data = segmentDataSource[indexPath.section].stops![indexPath.row].name!
             cell.textLabel?.text = segmentDataSource[indexPath.section].stops![indexPath.row].name!
        }
        
        //cell.textLabel?.text = data
        //dataSource[indexPath.row])
        return cell
    }
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var name = segmentDataSource[section].transport_name
        
        if segmentDataSource[section].transport_type == "Walk"{
            name = "Mers"
        }
        return name
        
    }*/
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var name : String
        
        if segmentDataSource[section].transport_type!.lowercased() == "walk"{
            name = "Mers"
        }else{
            name = segmentDataSource[section].transport_name!
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        view.backgroundColor = UIColor.green
        
        let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
        
        lbl.text = name
        view.addSubview(lbl)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
}
 

