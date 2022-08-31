//
//  ViewController.swift
//  FetchRewards
//
//  Created by Neethu Kuruvilla on 5/17/22.
//

//tasks being done: -calling the fetchdata method when dessert or id button is clicked
//-getting the data from the API
//-proccesing and adding 

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var IDtextField: UITextField!
    
    @IBOutlet weak var recipiesTableView: UITableView!
    
    var DataFetcher = DataFetching()
    
    var displayedRecipeNames = [String]()
    
    var displayedRecipeIDs = [String]()
    
    var selectedRecipeName = ""
    var selectedRecipeID = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        recipiesTableView.delegate = self
        recipiesTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = displayedRecipeNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedRecipeNames.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipeName = self.displayedRecipeNames[indexPath.row]
        selectedRecipeID = self.displayedRecipeIDs[indexPath.row]
        performSegue(withIdentifier: "toRecipeVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeVC"{
            let destinationVC = segue.destination as! RecipeVC
            destinationVC.currentRecipeName = selectedRecipeName
            destinationVC.currentRecipeID = selectedRecipeID
        }
    }
    
    @IBAction func dessertButtonClicked(_ sender: Any) {
        displayedRecipeNames.removeAll(keepingCapacity: false)
        displayedRecipeIDs.removeAll(keepingCapacity: false)
        
        DataFetcher.fetchDessertRecipiesData { R in
            R.self.meals.forEach { m in
                self.displayedRecipeNames.append(m.strMeal!)
                self.displayedRecipeIDs.append(m.idMeal!)
                
            }
            DispatchQueue.main.async {
                self.recipiesTableView.reloadData()
            }
            
        }
        
        
        
        
    }
    
    @IBAction func idButtonClicked(_ sender: Any) {
        
        
        
        
        if(IDtextField.hasText){
        //clear displayed Names and IDs
        displayedRecipeNames.removeAll(keepingCapacity: false)
        displayedRecipeIDs.removeAll(keepingCapacity: false)
            
           
            
            DataFetcher.ID = IDtextField.text!
            
            DataFetcher.fetchIDRecipeData { R in
                R.meals?.forEach({ dictionary in
                    self.displayedRecipeNames.append((dictionary["strMeal"] as? String)!)
                    self.displayedRecipeIDs.append((dictionary["idMeal"] as? String)!)
                })
                
                DispatchQueue.main.async {
                    self.recipiesTableView.reloadData()
                }
            }
            
            
        } else {
            //make an allert
            makeAlert(titleInput: "Error", messageInput: "ID not found")
        }
        
    }
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}
