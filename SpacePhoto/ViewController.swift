//
//  ViewController.swift
//  SpacePhoto
//
//  Created by Vladimir Pisarenko on 21.06.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let photoInfoController = PhotoInfoController()
    let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=cwqSfkA240h42cehdTCzFWHAAhuYY6HE4cu4zABk")!

    @IBOutlet var imageLabel: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var copyrightLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        imageLabel.image = UIImage(systemName: "photo.on.rectangle")
        descriptionLabel.text = ""
        copyrightLabel.text = ""
        
        Task {
            do {
                let photoInfo = try await photoInfoController.fetchPhotoInfo()
                updateUI(with: photoInfo)
            } catch {
                updateUI(with: error)
            }
        }
        
        func updateUI(with photoInfo: PhotoInfo) {
            Task {
                do {
                    let image = try await photoInfoController.fetchImage(from: photoInfo.url)
                    title = photoInfo.title
                    imageLabel.image = image
                    descriptionLabel.text = photoInfo.description
                    copyrightLabel.text = photoInfo.copyright
                } catch {
                    updateUI(with: error)
                }
            }
        }
        func updateUI(with error: Error) {
            title = "Error fetching photo"
            imageLabel.image = UIImage(systemName: "exclamationmark.octagon")
            descriptionLabel.text = error.localizedDescription
            copyrightLabel.text = ""
        }
    }
}

