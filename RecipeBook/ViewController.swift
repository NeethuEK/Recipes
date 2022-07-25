//
//  ViewController.swift
//  FetchRewards
//
//  Created by Neethu Kuruvilla on 5/17/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var IDtextField: UITextField!
    
    @IBOutlet weak var recipiesTableView: UITableView!
    
    
    var displayedRecipieName = [String]()
    
    var displayedRecipieID = [String]()
    
    var selectedRecipeName = ""
    var selectedRecipeID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        recipiesTableView.delegate = self
        recipiesTableView.dataSource = self
    }
    
    
    func fetchIDRecipeData(completionHandler: @escaping (Recipe) -> Void){
        
        var urlString = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="
        
        urlString.append(IDtextField.text!)
        
        let url = URL(string: urlString)!
        
        //check if url is valid
        
        
        
        let task = URLSession.shared.dataTask(with: url) { data, url, error in
            guard let data = data else {
                return
            }
            
            do {
                let recipeData = try JSONDecoder().decode(Recipe.self, from: data)
                
                completionHandler(recipeData)
                
                DispatchQueue.main.async {
                    self.recipiesTableView.reloadData()
                }
            } catch{
                let error = error
                print("Heya!")
                print(String(describing: error))
            }
            
            
        }.resume()
        
        
    }
    
    func fetchDessertRecipiesData(completionHandler: @escaping (DRecipe) -> Void){
        
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                return
            }
            
            do {
                let DrecipieData = try JSONDecoder().decode(DRecipe.self, from: data)
                
                print("abc")
                completionHandler(DrecipieData)
                DispatchQueue.main.async {
                    self.recipiesTableView.reloadData()
                }
                
                
                
            } catch {
                let error = error
                print("Hi Ho!")
                print(String(describing: error))
            }

        }.resume()
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = displayedRecipieName[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedRecipieName.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipeName = self.displayedRecipieName[indexPath.row]
        selectedRecipeID = self.displayedRecipieID[indexPath.row]
        performSegue(withIdentifier: "toRecipeVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeVC"{
            let destinationVC = segue.destination as! RecipeVC
            destinationVC.currentRecipe = selectedRecipeName
            destinationVC.currentRecipeID = selectedRecipeID
        }
    }
    
    @IBAction func dessertButtonClicked(_ sender: Any) {
        displayedRecipieName.removeAll(keepingCapacity: false)
        displayedRecipieID.removeAll(keepingCapacity: false)
        fetchDessertRecipiesData { DRecipe in
            DRecipe.meals.forEach { m in
                self.displayedRecipieName.append(m.strMeal!)
                self.displayedRecipieID.append(m.idMeal!)
            }
        }
        
        
    }
    
    @IBAction func idButtonClicked(_ sender: Any) {
        //TODO: * make alert if url is invalid
        
        if(IDtextField.hasText){
        //clear displayed Names and IDs
        displayedRecipieName.removeAll(keepingCapacity: false)
        displayedRecipieID.removeAll(keepingCapacity: false)
            
            fetchIDRecipeData { R in
                
                
                
                R.meals?.forEach({ dictionary in
                    
                        self.displayedRecipieName.append((dictionary["strMeal"] as? String)!)
                        self.displayedRecipieID.append((dictionary["idMeal"] as? String)!)
                   
                })
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
