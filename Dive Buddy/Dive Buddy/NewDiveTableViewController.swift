//
//  NewDiveTableViewController.swift
//  Dive Buddy
//
//  Created by Alexander Engel on 5/16/16.
//  Copyright © 2016 Alex Engel. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import ContactsUI
class NewDiveTableViewController: UITableViewController,UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate, CNContactPickerDelegate {
    
    //images that have not been uploaded
    private var imagesToUpload = [UIImage]()
    
    //images that need to be displayed in the collection view
    private var imagesToDisplay = [UIImage]()
    private var imagePicker = UIImagePickerController()
    private var numSections = 4
    private var sectionRowCount = [2, 6, 9, 2]
    //labels to accompany input fields
    @IBOutlet weak var airTempUnits: UILabel!
    @IBOutlet weak var waterTempUnits: UILabel!
    @IBOutlet weak var visibilityUnits: UILabel!
    @IBOutlet weak var maxDepthUnits: UILabel!
    @IBOutlet weak var tankVolUnits: UILabel!

    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    //holds the form data necessaary for new dive
    var formInfo = Dictionary<String, String?>()
    
    //textfields to collect dive data
    @IBOutlet weak var diveDateTextField: UITextField!
    @IBOutlet weak var diveBuddyTextField: UITextField!
    @IBOutlet weak var diveSiteTextField: UITextField!
    @IBOutlet weak var weatherTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var airTempTextField: UITextField!
    @IBOutlet weak var waterTempTextField: UITextField!
    @IBOutlet weak var visibilityTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var maxDepthTextField: UITextField!
    @IBOutlet weak var tankTypeTextField: UITextField!
    @IBOutlet weak var tankVolTextField: UITextField!
    @IBOutlet weak var airTypeTextField: UITextField!
    @IBOutlet weak var startingPsiTextField: UITextField!
    @IBOutlet weak var endingPsiTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    //parameter to hold an existing dive if we are editing one
    var existingDive: DiveInfo?
    
    //if the location is from the picklocation view controller, fill in the appropriate data in the new dive form
    var location: MKPointAnnotation? {
        didSet {
            if location?.title != nil {
                locationTextField.text = location?.title
                formInfo["location"] = location?.title
            } else {
                locationTextField.text = String(location!.coordinate.latitude) + ", " + String(location!.coordinate.longitude)
            }
            formInfo["latitude"] = String(location!.coordinate.latitude)
            formInfo["longitude"] = String(location!.coordinate.longitude)
            
        }
    }
    
    //when the user is adding a buddy, allow them to add from contacts
    @IBAction func buddyFromContacts(sender: UIButton) {
        let contactPickerViewController = CNContactPickerViewController()
        contactPickerViewController.delegate = self
        presentViewController(contactPickerViewController, animated: true, completion: nil)
    }
    
    //when the user logs the dive
    @IBAction func logDiveButtonTapped(sender: UIBarButtonItem) {
        
        //if required fields are filled
        if diveDateTextField.text != "" && diveSiteTextField.text! != "" {
            var imageDatum = [NSData]()
            //convert pictures to NSData
            if imagesToUpload.count > 0 {
                for image in imagesToUpload {
                    let imageData = UIImagePNGRepresentation(image);
                    imageDatum.append(imageData!);
                }
            }
            
            //if we have an existing dive, pass the object id so we can update the correct on
            var objectId: NSManagedObjectID? = nil
            if existingDive != nil {
                objectId = existingDive!.objectID
            }
            //update/create dive
            DiveInfo.diveInfoFromDictionary(formInfo, imageDatum: imageDatum, updateObjectId: objectId, inmanagedObjectContext: managedObjectContext!)
            do {
                try managedObjectContext!.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            navigationController?.popViewControllerAnimated(true)
        } else {
            
            //if the required fields are not filled out, highlight them in red
            diveDateTextField.attributedPlaceholder = NSAttributedString(string:"Required", attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
            diveSiteTextField.attributedPlaceholder = NSAttributedString(string:"Required", attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
            
        }
    }
    
    @IBAction func startTimeTextFieldOnEdit(sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(NewDiveTableViewController.startTimePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func endTimeTextFieldOnEdit(sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(NewDiveTableViewController.endTimePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    @IBAction func diveDateTextFieldOnEdit(sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(NewDiveTableViewController.datePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    func startTimePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        startTimeTextField.text = dateFormatter.stringFromDate(sender.date)
        print(startTimeTextField.text!)
    }
    func endTimePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        endTimeTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        diveDateTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == 0 {
            formInfo["date"] = textField.text
        }
    }
    //show the image picker to add photos
    @IBAction func addPhotos() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //determine which text field changed and add the appropriate value
    func textFieldDidChange(textField: UITextField) {
        switch textField.tag {
        case 0:
            formInfo["date"] = textField.text
        case 1:
            formInfo["buddy"] = textField.text
        case 2:
            formInfo["dive_site"] = textField.text
        case 3:
            formInfo["location"] = textField.text
        case 4:
            formInfo["weather"] = textField.text
        case 5:
            formInfo["air_temp"] = textField.text
        case 6:
            formInfo["water_temp"] = textField.text
        case 7:
            formInfo["visibility"] = textField.text
        case 8:
            formInfo["start_time"] = textField.text
        case 9:
            formInfo["end_time"] = textField.text
        case 10:
            formInfo["max_depth"] = textField.text
        case 11:
            formInfo["tank_type"] = textField.text
        case 12:
            formInfo["tank_vol"] = textField.text
        case 13:
            formInfo["air_type"] = textField.text
        case 14:
            formInfo["start_psi"] = textField.text
        case 15:
            formInfo["end_psi"] = textField.text
        case 16:
            formInfo["notes"] = textField.text
        default:
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //check settings for metric/imperial and set labels
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("metric"){
            airTempUnits.text = "°C"
            waterTempUnits.text = "°C"
            visibilityUnits.text = "m"
            maxDepthUnits.text = "m"
            tankVolUnits.text = "L"
        } else {
            airTempUnits.text = "°F"
            waterTempUnits.text = "°F"
            visibilityUnits.text = "ft"
            maxDepthUnits.text = "ft"
            tankVolUnits.text = "cu.ft."
        }
        // handle the user input in the text fields through delegate callbacks
        diveDateTextField.delegate = self
        diveBuddyTextField.delegate = self
        diveSiteTextField.delegate = self
        weatherTextField.delegate = self
        airTempTextField.delegate = self
        waterTempTextField.delegate = self
        visibilityTextField.delegate = self
        startTimeTextField.delegate = self
        endTimeTextField.delegate = self
        maxDepthTextField.delegate = self
        tankTypeTextField.delegate = self
        tankVolTextField.delegate = self
        airTypeTextField.delegate = self
        startingPsiTextField.delegate = self
        endingPsiTextField.delegate = self
        locationTextField.delegate = self
        notesTextField.delegate = self
        
        imagePicker.delegate = self
        
        // tags
        diveDateTextField.tag = 0
        diveBuddyTextField.tag = 1
        diveSiteTextField.tag = 2
        locationTextField.tag = 3
        weatherTextField.tag = 4
        airTempTextField.tag = 5
        waterTempTextField.tag = 6
        visibilityTextField.tag = 7
        startTimeTextField.tag = 8
        endTimeTextField.tag = 9
        maxDepthTextField.tag = 10
        tankTypeTextField.tag = 11
        tankVolTextField.tag = 12
        airTypeTextField.tag = 13
        startingPsiTextField.tag = 14
        endingPsiTextField.tag = 15
        notesTextField.tag = 16
        
        //set editing changed and end actions for textfields
        diveDateTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        diveBuddyTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        diveSiteTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        locationTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        weatherTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        airTempTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        waterTempTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        visibilityTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        startTimeTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        endTimeTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        maxDepthTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        tankTypeTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        tankVolTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        airTypeTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        startingPsiTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        endingPsiTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        notesTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        locationTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        
        airTempTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        waterTempTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        visibilityTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        startTimeTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        endTimeTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        maxDepthTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        tankVolTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        startingPsiTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        endingPsiTextField.addTarget(self, action: #selector(NewDiveTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        
        //if we have an existing dive, fill in the text fields with its information
        if existingDive != nil {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            let dateString = dateFormatter.stringFromDate((existingDive!.date)!)
            diveDateTextField.text = dateString
            diveSiteTextField.text = existingDive!.dive_site!
            if(existingDive!.buddy != nil) {
                diveBuddyTextField.text = existingDive!.buddy!
            }
            if(existingDive!.location != nil) {
                visibilityTextField.text = String(existingDive!.location!)
            }
            if(existingDive!.weather != nil) {
                weatherTextField.text = existingDive!.weather!
            }
            if(existingDive!.air_temp != 0) {
                airTempTextField.text = String(existingDive!.air_temp!)
            }
            if(existingDive!.water_temp != 0) {
                waterTempTextField.text = String(existingDive!.water_temp!)
            }
            if(existingDive!.visibility != 0) {
                visibilityTextField.text = String(existingDive!.visibility!)
            }
            if(existingDive!.start_time != nil) {
                dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
                startTimeTextField.text = dateFormatter.stringFromDate(existingDive!.start_time!)
            }
            if(existingDive!.end_time != nil) {
                dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
                endTimeTextField.text = dateFormatter.stringFromDate(existingDive!.end_time!)
            }
            if(existingDive!.max_depth != 0) {
                maxDepthTextField.text = String(existingDive!.max_depth!)
            }
            if(existingDive!.tank_type != nil) {
                tankTypeTextField.text = String(existingDive!.tank_type!)
            }
            if(existingDive!.tank_volume != 0) {
                tankVolTextField.text = String(existingDive!.tank_volume!)
            }
            if(existingDive!.air_type != nil) {
                airTypeTextField.text = existingDive!.air_type!
            }
            if(existingDive!.start_psi != 0) {
                startingPsiTextField.text = String(existingDive!.start_psi!)
            }
            if(existingDive!.end_psi != 0) {
                endingPsiTextField.text = String(existingDive!.end_psi!)
            }
            if(existingDive!.notes != nil) {
                notesTextField.text = existingDive!.notes!
            }
            if(existingDive!.images != nil) {
                let imageArray = existingDive!.images!.array as? [Image]
                for image in imageArray! {
                    imagesToDisplay.append(UIImage(data: image.image_data!)!)
                }
            }
            
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return numSections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionRowCount[section]
    }
    
    override func tableView(tableView: UITableView,
                            willDisplayCell cell: UITableViewCell,
                                            forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let photoTableViewCell = cell as? PhotoTableViewCell else { return }
        
        photoTableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    }
    /*override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     
     return cell
     }*/
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    // MARK: - UIImagePickerControllerDelegate Methods
    
    //set the picked image to be uploaded and update view
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagesToDisplay.append(pickedImage)
            imagesToUpload.append(pickedImage)
        }
        dismissViewControllerAnimated(true, completion: nil)
        self.tableView.reloadData()
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //when a contact is selected, fill in the buddy field
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        diveBuddyTextField.text = contact.givenName + " " + contact.familyName
    }
    
}

//extension to handle collection view in table view
extension NewDiveTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return imagesToDisplay.count
    }
    
    //populate collection view with photos
    func collectionView(collectionView: UICollectionView,
                        willDisplayCell cell: UICollectionViewCell,
                                        forItemAtIndexPath indexPath: NSIndexPath) {
        if let photoCell = cell as? UploadPhotoViewCell {
            print(imagesToDisplay)
            photoCell.imageView.image = imagesToDisplay[indexPath.row]
            photoCell.contentMode = .ScaleAspectFit
        }
        
    }
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionViewCell",
                                                                         forIndexPath: indexPath)
        return cell
    }
}

//contactPickerDelegate



