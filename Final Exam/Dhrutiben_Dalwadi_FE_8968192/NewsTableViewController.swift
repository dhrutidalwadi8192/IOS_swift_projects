//
//  NewsTableViewController.swift
//  Dhrutiben_Dalwadi_FE_8968192
//
//  Created by user237515 on 4/11/24.
//

import UIKit

class NewsTableViewController: UITableViewController {
    // core data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // news list with array of Articl type
    var newsList:[Article]=[]
    // current city
    var fromCity : String?
    // interaction source
    var source : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // if city found then get news for that city
        if let city = fromCity, !city.isEmpty{
            getNewsData(city)
            
        }else{
            do{
                // fetch user current location from core data
                let currentLocations = try context.fetch(UserCurrentLocation.fetchRequest())
                // if location found from user location storge the fetch city based on that
                if(currentLocations.count > 0){
                    fromCity = currentLocations[0].cityName
                    getNewsData(fromCity!)
                    
                }else{
                    // defauly city
                    fromCity = "Waterloo"
                    getNewsData(fromCity!)
                }
            }catch{
                print("Error while fetchin current user location")
            }
        }
        
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
        return newsList.count
    }

    // render cells to display data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // bind values to NewsTable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsDetails", for: indexPath) as! NewsTableViewCell
        
        cell.newsTitle.text = self.newsList[indexPath.row].title
        cell.newsDescription.text = self.newsList[indexPath.row].description ?? "-"
        if let sourceName = self.newsList[indexPath.row].source?.name{
            cell.newsSource.text = sourceName
        }
        
        cell.newsAuthor.text = self.newsList[indexPath.row].author ?? "-"
        
        // take first news and call function to add data in history
        if indexPath.row == 0 {
            addHistory(cell.newsTitle.text ?? "", cell.newsAuthor.text ?? "",cell.newsDescription.text ?? "", cell.newsSource.text ?? "")
        }
        return cell
    }
    
    
    // change city for news
    @IBAction func changeCity(_ sender: Any) {
        // function all to open change city dialog
        OpenChangeCityDialg()
    }
    
    
    // navigate to home
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // navigate to home
    @IBAction func navigateToMap(_ sender: UIButton) {
        let navController = storyboard?.instantiateViewController(withIdentifier: "Map") as! MapViewController
        //pass interaction source as News
        navController.source = Constants.InteractionType.NEWS
        // push Map View Controller in navigation
        navigationController?.pushViewController(navController, animated: true)
    }
    
    
   // navigate to weather
    @IBAction func navigateToWeather(_ sender: UIButton) {
        let navController = storyboard?.instantiateViewController(withIdentifier: "Weather") as! WeatherViewController
        // pass interaction sourc as News
        navController.source = Constants.InteractionType.NEWS
        // push weather vie controller in navigation
        navigationController?.pushViewController(navController, animated: true)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    
    // function to make API call to get weather information
    func getNewsData(_ cityName : String){
        // create url component
        var components = URLComponents(string: Constants.newsAPIBaseUrl)!
        
        // add query parameters to request
        components.queryItems=[
            URLQueryItem(name:"q",value:cityName),
            URLQueryItem(name:"apiKey",value:Constants.newsAPIKey),
            // current page
            URLQueryItem(name:"page",value:"1"),
            // page size
            URLQueryItem(name:"pageSize",value:"10"),
            // language
            URLQueryItem(name:"language",value:"en")
        ]
        
        // prepare url based on url component
        guard let apiUrl = components.url else {return}
        print("apiutl \(apiUrl)")
        // create data task with shred session
        let dataTask = URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
            
            if let data = data{
               
                do{
                    
                    // decode json to CityNews structure
                    let newsData = try JSONDecoder().decode(CityNews.self,from:data)
                    
                    // perform UI updates on main thread
                    
                        // fcheck response status
                        if(newsData.status == "ok"){
                            // check if news found
                            if(newsData.totalResults > 0){
                                DispatchQueue.main.async {
                                    // display data in table
                                    self.newsList = newsData.articles
                                    // reload table view
                                    self.tableView.reloadData()
                               
                                }
                            }else{
                                // display news not found message
                                self.showAlert(title: "Not Found", message: "No news found for \(cityName)")
                            }
                        }else{
                            // display error message
                            self.showAlert(title: "Error", message: "Error whie fetching news data")
                        }
                    
                }catch{
                    // catch error in decode
                    print("Error while parsing news data : \(error)")
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error", message: "Error while fetching news information")
                    }
                    
                }
            }
            // api call error
            if let error = error {
                print("Error while getting news information: \(error)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Error while fetching weather information")
                }
                return
            }
        }
        // begin data task
        dataTask.resume()
        
    }
    
    
    // function to open Change City Dialog
    func OpenChangeCityDialg(){
        let alertDialog = UIAlertController(title:"Change City",message:"",preferredStyle: .alert)
        // add city name text field
        alertDialog.addTextField{(textField) in
            textField.placeholder="Enter City Name"
        }
        
        // cancel button
        let cancelAction = UIAlertAction(title:"Cancel",style: .cancel,handler:nil)
        alertDialog.addAction(cancelAction)
        
        // Change City Button
        let insertAction = UIAlertAction(title:"Change",style: .destructive) { [self] action in
            // take city name
            let cityName = alertDialog.textFields?.first?.text ?? ""
            if(cityName.isEmpty){
                // if city is not entered by user display message
                showAlert(title:"",message:"Please enter city name")
            }else{
                // set as current city
                fromCity = cityName
                // get news data
                getNewsData(cityName)
                
            }
        }
        // add change city button to dialog
        alertDialog.addAction(insertAction)
        // display dialog on screen
        present(alertDialog,animated: true,completion: nil)
    }

    // function to add history
    func addHistory(_ title : String, _ author : String, _ description : String, _ newsSource : String){
        if let source = source, !source.isEmpty {
            let history = NavigationHistory(context: context)
            // interaction source
            history.source = source
            // interaction type
            history.interactionType = Constants.InteractionType.NEWS
            // city
            history.city = fromCity
            // title
            history.newsTitle = title
            // author
            history.newsAuthor = author
           // description
            history.newsDescription = description
           // current date
            history.createdAt = Date()
           // news source
            history.newsSource = newsSource
            do{
                // save data
                try context.save()
                
            }catch{
                print("Error while adding new To Do Item")
            }
        }
    }
    
    // dismiss keyboard
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
            view.endEditing(true)
    }
    
}
