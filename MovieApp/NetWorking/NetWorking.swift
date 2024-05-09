import UIKit

class MovieDataManager {
    static let shared = MovieDataManager()
    
    private init() {}
    
    // MARK: - Function to fetch data using URLSession
    func loadData(completionHandler: @escaping ([MoviesPojo]?) -> Void) {
        let networkIndicator = UIActivityIndicatorView(style: .gray)
        networkIndicator.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        networkIndicator.startAnimating()
        UIApplication.shared.keyWindow?.addSubview(networkIndicator)
        
        guard let url = URL(string: "https://freetestapi.com/api/v1/movies") else {
            completionHandler(nil)
            DispatchQueue.main.async {
                networkIndicator.stopAnimating()
                networkIndicator.removeFromSuperview()
            }
            return
        }
        
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                networkIndicator.stopAnimating()
                networkIndicator.removeFromSuperview()
            }
            
            guard let data = data else {
                completionHandler(nil)
                return
            }
            print("BackGround")
            do {
                let result = try JSONDecoder().decode([MoviesPojo].self, from: data)
                completionHandler(result)
            } catch let error {
                print(error.localizedDescription)
                completionHandler(nil)
            }
        }
        task.resume()
    }
}
