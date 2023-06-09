//
//  TransformationViewController.swift
//  ios-practica
//
//  Created by Eric Olsson on 1/11/23.
//

import UIKit

class TransformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var transformations: [Transformation]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Transformations"
        
        print("TransformationVC transformation count: \(transformations.count)")
        
        let xib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "customTableCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transformations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTableCell", for: indexPath) as! TableViewCell
        
        let transformation = transformations[indexPath.row]
        
        cell.iconImageView.setImage(url: transformation.photo)
        cell.titleLabel.text = transformation.name
        cell.descriptionLabel.text = transformation.description
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // enables transformationDetailsView viewing
        let transformation = transformations[indexPath.row]
        let transDetailsView = TransformationDetailViewController()
        transDetailsView.transformation = transformation
        navigationController?.pushViewController(transDetailsView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // empty
    }
}
