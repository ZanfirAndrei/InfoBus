//
//  SearchResultsViewController.swift
//  Info Bus
//
//  Created by Zorro Andrei on 25/04/2020.
//  Copyright © 2020 ZorroAndrei. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {

    @IBOutlet weak var routesTblView: UITableView!
    
    var dataSource : [Route] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowRoute"{
            let newController = segue.destination as! RouteDetailViewController
            
            let btn =  sender as! UIButton
            let cell = btn.superview!.superview as! SearchResultsTableCell
            
            //let index = self.routesTblView.indexPath(for: cell)
            
            newController.title = "Ruta"
            newController.segmentDataSource = cell.segmentsDataSource
            
            //print(dataSource[index?.row ?? 0])
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}

extension SearchResultsViewController: UITableViewDataSource, UITableViewDelegate
    //, UICollectionViewDataSource, UICollectionViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutesCell") as! SearchResultsTableCell
        
        cell.setSearchResultsCell(with: dataSource[indexPath.row])
        cell.segmentsCollView.reloadData()
        return cell
    }
    
    /*func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }*/
    
}


class SearchResultsTableCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var segmentsCollView: UICollectionView!
    

    @IBOutlet weak var goToBtn: UIButton!
    @IBOutlet weak var lblDurationTVC: UILabel!
    @IBOutlet weak var lblNumOfPeople: UILabel!
    
    
    var segmentsDataSource : [Segment] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.segmentsCollView.delegate = self
        self.segmentsCollView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func goToShowRoute(_ sender: AnyObject) {
        //self.ge
        //let cell = sender.superview!?.superview as! SearchResultsTableCell
        
    }
    
    
    func setSearchResultsCell(with route: Route){
        let duration = Int(route.duration! / 60)
        self.lblDurationTVC.text = "\(duration)"
        self.segmentsDataSource = route.segments!
    }
    
    
    // Mark: collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentsDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SegmentCell", for: indexPath ) as! SegmentCollectionCell
        
        cell.setSegmentCollCell(with: segmentsDataSource[indexPath.row])
        
        return cell
    }
    
}


class SegmentCollectionCell: UICollectionViewCell{
    
    @IBOutlet weak var imgTransportType: UIImageView!
    
    @IBOutlet weak var lblTransportType: UILabel!
    
    @IBOutlet weak var lblDurationCVC: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setSegmentCollCell(with segment: Segment){
        let duration = Int( segment.duration! / 60000)
        self.lblTransportType.text = segment.transport_name
        self.lblDurationCVC.text = "\(duration)"
    
    }
    
    
}
