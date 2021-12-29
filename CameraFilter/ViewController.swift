//
//  ViewController.swift
//  CameraFilter
//
//  Created by Nicholas Forte on 28/12/21.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var btnApplyFilter: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Camera Filter"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
            let photosCvc = navC.viewControllers.first as? PhotosCollectionViewController
            else {
            fatalError("Segue destination is not found")
        }
        
        photosCvc.selectedPhoto.subscribe(onNext: { [weak self] photo in
            
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
            
        }).disposed(by: disposeBag)
    }
    
    @IBAction func applyFilterButtonPressed() {
        
        guard let sourceImage = self.photoImageView.image else {
            return
        }
        
        FilterService().applyFilter(to: sourceImage)
            .subscribe(onNext: { filterImage in
                DispatchQueue.main.async {
                    self.photoImageView.image = filterImage
                }
            }).disposed(by: disposeBag)
        
    }


    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.btnApplyFilter.isHidden = false
    }
    
    
}

