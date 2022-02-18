
import UIKit
import Alamofire

class GetCriticsFromApi {
    
    let urlReviewsWord = "https://api.nytimes.com/svc/movies/v2/critics/.json?api-key="
    
    let urlCritics = "https://api.nytimes.com/svc/movies/v2/critics/all.json?api-key="
    
    let key = "rp3d9BM90jGDjFjCoCuXMX1JHgLz9rMG"
    
    var criticsData: [Success] = []
    
    var reservData: [Success] = []
    
    struct Critics: Codable {
        let results: [Success]
        let status: String
        let num_results: Int
        let copyright: String
    }
    
    struct Success: Codable {
        let bio: String
        let display_name: String
        let multimedia: Multimedia?
        let seo_name: String
        let sort_name: String
        let status: String
    }
    
    struct Multimedia: Codable {
        let resource: Resource
    }
    
    struct Resource: Codable {
        let credit: String
        let height: Int
        let src: String
        let type: String
        let width: Int
    }
    
    func getDataCritics(urlCritics: String, completion: @escaping () -> Void) {
        DispatchQueue.global().async {
        AF.request(urlCritics + self.key).responseJSON { AFdata in
            
            do {
                        guard let jsonObject = try JSONSerialization.jsonObject(with: AFdata.data!) as? [String: Any] else {
                            print("Error: Cannot convert data to JSON object")
                            return
                        }
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
            
                do {
                    let decodedData = try JSONDecoder().decode(Critics.self, from: prettyJsonData)
                    for i in 0...decodedData.results.count-1 {
                        self.criticsData.append(decodedData.results[i])
                    }
                } catch {
                    print("decode error")
                }
                DispatchQueue.main.async {
                    completion()
                }
                    } catch {
                        print("Error: Trying to convert JSON data to string")
                        return
                    }
        }
        }
    }
    
    
    
    func setImage(index: Int) -> URL {
        let imageUrl = self.criticsData[index].multimedia?.resource.src ?? "vk.com/1"
        
        return URL(string: imageUrl)!
    }
}

