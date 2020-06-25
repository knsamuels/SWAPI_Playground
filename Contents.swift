import UIKit

// base Url: https://swapi.dev/api

// url for people: https://swapi.dev/api/people
// url for films: https://swapi.dev/api/films


struct Person: Decodable {
    let name: String
    let birth_year: String
    let films: [URL]
    let height: String
    let starships: [String]
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}


class SwapiService {
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    static let peopleEndPoint = "people"
    static let filmEndPoint = "films"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?)-> Void) {
        // 1 - Prepare URL
        guard let baseURL = baseURL else { return completion(nil) }
        
        let peopleURL = baseURL.appendingPathComponent(peopleEndPoint)
        let finalURL = peopleURL.appendingPathComponent(String(id))
        
        // 2 - Contact server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            // 3 - Handle errors
            if let error = error {
                print("there was an error: \(error): \(error.localizedDescription)")
                return completion(nil)
            }
            //             4 Check for data
            guard let data = data else { return completion(nil) }
            // 5 - Decode Person from JSON
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                return completion(person)
            } catch {
                print("We had an error decoding our person - \(error) - \(error.localizedDescription)")
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        // 1 - Contact server
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            // Handle Errors
            if let error = error {
                print("there was an error: \(error): \(error.localizedDescription)")
                return completion(nil)
            }
            // 3 Check for data
            guard let data = data else { return completion(nil)}
            // 4 Decode Film from Json
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                return completion(film)
            } catch {
                print("We had an error decoding our film - \(error) - \(error.localizedDescription)")
                return completion(nil)
            }
        }.resume()
    }
    
    
    static func fetchfilm(url: URL) {
        SwapiService.fetchFilm(url: url) { (film) in
            if let film = film {
                print(film)
            }
        }
    }
}

SwapiService.fetchPerson(id: 13) { (person) in
    guard let person = person else {return}
    print(person.name)
    
    for url in person.films {
       
        SwapiService.fetchFilm(url: url) { (film) in
            guard let film = film else { return }
            print(film.title)
        }
    }
}

