//
//  RecipeVC.swift
//  FetchRewards
//
//  Created by Neethu Kuruvilla on 5/19/22.
//

/*
 Tasks done in this file:
 -gets steps and ingredients from the ID of the selected recipe
 -process data to properly split up the steps and append them to the array
 -increasing ingredient count so that tableview is proper length
 -
 */

import UIKit

class RecipeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    

    
    @IBOutlet weak var mealNameTL: UILabel!
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    
    @IBOutlet weak var instructionsTableView: UITableView!
    
    var currentRecipeName = ""
    var currentRecipeID = ""
    
    var currentRecipeIngredients = [String](repeating: "", count: 20)
    var currentRecipeInstructions = [String]()
    
    var IngredientCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        
        instructionsTableView.delegate = self
        instructionsTableView.dataSource = self
        
        if currentRecipeName != ""{
            mealNameTL.text = currentRecipeName
            
            
            fetchRecipe { R in
                //get ingredients first
                //var amount = "strMeasure"
                //var item = "strIngredient"
                for i in 1...20{
                    //append i to end of strings
                    let amount = "strMeasure\(i)"
                    let item = "strIngredient\(i)"
                    //currentRecipeIngredients[i] = R[0]![amount]
                    
                    R.meals?.forEach({ dictionary in
                        //self.currentRecipeIngredients[i-1] = (dictionary [amount] as? String)!
                        
                        
                        
                        if(dictionary[amount] as? String != ""){
                            if(dictionary[amount] as? String != nil){
                                if(dictionary[amount] as? String != " "){
                                
                                self.currentRecipeIngredients[i-1] = (dictionary[amount] as? String)!
                                self.IngredientCount += 1
                                //append food to end
                                self.currentRecipeIngredients[i-1].append(" ")
                                self.currentRecipeIngredients[i-1].append((dictionary[item] as? String)!)
                                    
                                }
    
                            }
                        }
                    })
                    
                }
                
                
                
                R.meals?.forEach({ dictionary in
                    let inst = (dictionary["strInstructions"] as? String)!
                    
                    self.currentRecipeInstructions = inst.components(separatedBy: ".")
                    
                    /*
                    for i in self.currentRecipeInstructions{
                        print("<< \(i)>>")
                    }*/
                })
                
               
                
                
            }
            
            
            
        }
        // Do any additional setup after loading the view.
    }
    
    func fetchRecipe(completionHandler: @escaping (Recipe) -> Void){
        var urlString = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="
       // print("Hello")
        urlString.append(currentRecipeID)
        
        let url = URL(string: urlString)!
        print(url)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else{

                return
            }
            
            do {
                
                
                let RecipeData = try JSONDecoder().decode(Recipe.self, from: data)
                
                completionHandler(RecipeData)
                DispatchQueue.main.async {
                   self.ingredientsTableView.reloadData()
                    self.instructionsTableView.reloadData()
                }
                
            } catch {
                
                let error = error
                print(String(describing: error))
                
            }
        }.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ingredientsTableView {
            return IngredientCount
        }
        if tableView == instructionsTableView {
            return currentRecipeInstructions.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ingredientsTableView {
            
            let cell = UITableViewCell()
            cell.textLabel?.text = currentRecipeIngredients[indexPath.row]
            return cell
        }
        if tableView == instructionsTableView {
            let cell = UITableViewCell()
            if currentRecipeInstructions[indexPath.row] != ""{
                cell.textLabel?.text = currentRecipeInstructions[indexPath.row]
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
