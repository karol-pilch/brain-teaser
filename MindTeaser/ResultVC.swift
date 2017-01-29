//
//  ResultVC.swift
//  MindTeaser
//
//  Created by Karol Pilch on 29/01/2017.
//  Copyright © 2017 Karol Pilch. All rights reserved.
//

/*

To do:

* Make the numbers pop up from nothingness
* Make the pink view drop down from the top after a second

*/

import UIKit

class ResultVC: UIViewController {
	
	// MARK: View setup:
	@IBOutlet weak var correctLabel: UILabel!
	@IBOutlet weak var incorrectLabel: UILabel!
	
	
	// Data to display
	var correctCount: Int = 0
	var incorrectCount: Int = 0
	
	

	override func viewDidLoad() {
		super.viewDidLoad()
		
		correctLabel.text = String(correctCount)
		incorrectLabel.text = String(incorrectCount)
	}
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return UIInterfaceOrientationMask.portrait
	}

	
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
