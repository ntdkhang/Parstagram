//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Nguyen Tran Duy Khang on 3/26/22.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController,
							UIImagePickerControllerDelegate,
							UINavigationControllerDelegate {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var commentField: UITextField!
	
	@IBAction func onTapCamera(_ sender: Any) {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.allowsEditing = true
		
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			picker.sourceType = .camera
		} else {
			picker.sourceType = .photoLibrary
		}
		present(picker, animated: true, completion: nil)
		
	}
	
	func imagePickerController(_ picker: UIImagePickerController,
							   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		let image = info[.editedImage] as! UIImage
		let size = CGSize(width: 300, height: 300)
		let scaledImage = image.af.imageScaled(to: size)
		
		imageView.image = scaledImage
		dismiss(animated: true, completion: nil)
		
	}
	
	@IBAction func onSubmit(_ sender: Any) {
		let post = PFObject(className: "Posts")
		post["caption"] = commentField.text!
		post["author"] = PFUser.current()!
		
		let imageData = imageView.image!.pngData()!
		let imageFile = PFFileObject(data: imageData)
		post["image"] = imageFile
		
		post.saveInBackground { success, error in
			if success {
				self.dismiss(animated: true, completion: nil)
			} else {
				print("Error: \(error?.localizedDescription ?? "")")
			}
		}
		
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
