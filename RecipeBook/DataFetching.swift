//
//  DataFetching.swift
//  RecipeBook
//
//  Created by Neethu Kuruvilla on 8/13/22.
//

import Foundation

struct DataFetching {
    
    //var MainViewController = ViewController()
    
    var ID = ""
    
    func fetchDessertRecipiesData(completionHandler: @escaping (DRecipe) -> Void){
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                return
            }
            
            do {
                let DrecipieData = try JSONDecoder().decode(DRecipe.self, from: data)
                
                print("abc")
                completionHandler(DrecipieData)
                DispatchQueue.main.async {
                    //
                    //MainViewController.recipiesTableView.reloadData()
                }
                
                
                
            } catch {
                let error = error
                print("Hi Ho!")
                print(String(describing: error))
            }

        }.resume()
    }
    
    
    func fetchIDRecipeData(completionHandler: @escaping (Recipe) -> Void){
        
        var urlString = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="
        
        urlString.append(ID)
        
        let url = URL(string: urlString)!
        
        //check if url is valid
        
        
        
        URLSession.shared.dataTask(with: url) { data, url, error in
            guard let data = data else {
                return
            }
            
            do {
                let recipeData = try JSONDecoder().decode(Recipe.self, from: data)
                
                completionHandler(recipeData)
                
                DispatchQueue.main.async {
                    //self.recipiesTableView.reloadData()
                }
            } catch{
                let error = error
                print("Heya!")
                print(String(describing: error))
            }
            
            
        }.resume()
        
        
    }
}
