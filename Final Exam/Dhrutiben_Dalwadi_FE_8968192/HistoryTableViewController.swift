//
//  HistoryTableViewController.swift
//  Dhrutiben_Dalwadi_FE_8968192
//
//  Created by user237515 on 4/11/24.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    // context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // navigation history arraay
    var navigationHistory = [NavigationHistory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // fetch history
        fetchHistory()
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    // number of section
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return navigationHistory.count
    }

    // view cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // get cell value
        let currentHistory = navigationHistory[indexPath.row]
        
        // if interaction type is Weather then display data in Weather History view cell
        if(currentHistory.interactionType == Constants.InteractionType.WEATHER){
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherHistory",for:indexPath) as! WeatherHistoryTableViewCell
            
            // bind values to cell
            cell.cityName.text = currentHistory.city
            cell.interactionSource.text = currentHistory.source
            cell.cityName.text = currentHistory.city
            cell.temperature.text = currentHistory.temperature
            cell.humidity.text = "Humidity:  \(currentHistory.humidity!)"
            cell.windSpeed.text = "Wind Speed:  \(currentHistory.windSpeed!)"
            cell.weatherDate.text = currentHistory.weatherDate
            cell.weatherTime.text = currentHistory.weatherTime
            return cell
           
        }else if(currentHistory.interactionType == Constants.InteractionType.NEWS){
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsHistory",for : indexPath)  as! NewsHistoryTableViewCell
            
            // bind values to cell
            cell.newsAuthor.text = currentHistory.newsAuthor
            cell.newsTitle.text = currentHistory.newsTitle
            cell.newsDescription.text = currentHistory.newsDescription
            cell.newsSource.text = currentHistory.newsSource
            cell.cityName.text = currentHistory.city
            cell.interactionSource.text = currentHistory.source
            return cell
        } else if(currentHistory.interactionType == Constants.InteractionType.MAP){
            // bind values to cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapHistory",for : indexPath)  as! MapHistoryTableViewCell
            cell.interactionSource.text = currentHistory.source
            cell.cityName.text = currentHistory.city
            cell.distance.text = currentHistory.totalDistance
            cell.startLocation.text = currentHistory.from
            cell.endLocation.text = currentHistory.to
            cell.travelMode.text = currentHistory.travelMode
            
            return cell
            
        }else {
            // default value
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsHistory", for: indexPath) as! NewsHistoryTableViewCell
            cell.newsTitle?.text = "No History Found"
            return cell
        }
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // function call to delete history function
            deleteHistory(history:navigationHistory[indexPath.row])
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // function to fetch to do list
    func fetchHistory(){
        do{
            // fetch history from core data
            navigationHistory = try context.fetch(NavigationHistory.fetchRequest()) as! [NavigationHistory]
            // sort data in descending order of created date
            navigationHistory.sort { $1.createdAt! < $0.createdAt! }
            //self.tableView.reloadData()
            
        }catch{
            print("Error while fetching to do list")
        }
    }
    
    // funtion to delete to do
    func deleteHistory(history:NavigationHistory){
        // delete history
        context.delete(history)
        do{
            try context.save()
            // fetch updated data
            fetchHistory()
            
        }catch{
            print("Error while deleting to Do")
        }
    }
    
        
    


}
