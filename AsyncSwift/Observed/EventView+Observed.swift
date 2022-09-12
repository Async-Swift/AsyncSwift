//
//  EventView+Observed.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/08.
//

import Foundation

extension EventView {
    final class Observed: ObservableObject {

        @Published var response = JSONResponse()

        init() {
            fetchJson()
        }

        func fetchJson() {
            guard let url = URL(string: "https://insub4067.github.io/insub_dev/asyncswift.json") else { return }

            let request = URLRequest(url: url)

            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }

                guard let response = response as? HTTPURLResponse else { return }

                if response.statusCode == 200 {
                    guard let data = data else { return }
                    DispatchQueue.main.async { [weak self] in
                        if let self = self {
                            do {
                                let decodedData = try JSONDecoder().decode(JSONResponse.self, from: data)
                                self.response = decodedData
                            } catch let error {
                                print("❌ \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
            dataTask.resume()
        }
    }
}
