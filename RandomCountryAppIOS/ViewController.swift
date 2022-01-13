//
//  ViewController.swift
//  RandomCountryAppIOS
//
//  Created by Grzegorz Domanowski on 12/01/2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var randomCountryButton: UIButton!
    @IBOutlet weak var capitalLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var capitalName = "";
        
        callCountryApi();


 
        
    }
    
    
    @IBAction func searchOnClick(_ sender: Any) {
        var query = self.capitalLabel.text
        query = query!.replacingOccurrences(of: " ", with: "+")
        var url = "https://www.google.co.in/search?q=" + query!
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        
    }
    
    @IBAction func pickRandomCountryFomApi(_ sender: Any) {
        callCountryApi();
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake {
            callCountryApi();
        }
    }
    
    func callCountryApi() -> Void {

        
        let url : String = "https://restcountries.com/v3.1/all"
        
        
        URLSession.shared.dataTask(with: NSURL(string: url) as! URL) { data, response, error in
            // Handle result
            
            let response = String (data: data!, encoding: String.Encoding.utf8)
            
            do {
                
                let randomInt = Int.random(in: 0..<250)
                
                let getResponse = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                
                
                let countryArray = getResponse as! NSArray
                
                let country1 = countryArray[randomInt] as! [String:Any]
                //Kraj
                let name = country1["name"] as! [String:Any]
                let countryName = name["common"] as! String
                //Stolica
                if(country1["capital"] != nil)
                {
                    let capital = country1["capital"] as! NSArray
                    let capitalName = capital[0] as! String
                    print(capital[0]);
                    DispatchQueue.main.async {
                    self.capitalLabel.text = capitalName
                    }
                }
                //Flaga
                let flag = country1["flags"] as! [String:Any]
                let flagUrl = flag["png"] as! String
                
                print(flagUrl)
                
                //Set Values
                
                
                DispatchQueue.main.async {
                    self.countryLabel.text = countryName
                    
                }
                
                if let url = URL(string: flagUrl) {
                    let task = URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, error == nil else { return }
                        
                        DispatchQueue.main.async { /// execute on main thread
                            self.imageView.image = UIImage(data: data)
                        }
                    }
                    
                    task.resume()
                }

                
                
                
                
                print(name["common"])
                
                
            } catch {
                print("error serializing JSON: \(error)")
            }
        }.resume()
                    
                   
            
    };
    
    
    
    
}









