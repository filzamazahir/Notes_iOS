//
//  NotesViewController.swift
//  Notes Clone
//
//  Created by Filza Mazahir on 1/25/16.
//  Copyright © 2016 Filza Mazahir. All rights reserved.
//

import UIKit

class NotesViewController: UITableViewController, NoteDetailsViewControllerDelegate, BackButtonDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    var searchController = UISearchController(searchResultsController: nil)
    var notes: [Note] = Note.all()
    var filteredNotes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: Search bar functions
    func filterNotesForSearchText(searchText: String, scope: String = "All") {
        filteredNotes = notes.filter { note in
            return note.noteContent.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterNotesForSearchText(searchController.searchBar.text!)
    }
    
    
    
    //MARK: Tableview overrides
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell")!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        // Filtering Notes 
        if searchController.active && searchController.searchBar.text != "" {
            cell.textLabel?.text = filteredNotes[indexPath.row].noteContent
            let filteredDateString = dateFormatter.stringFromDate(filteredNotes[indexPath.row].createdAt)
            cell.detailTextLabel?.text = filteredDateString
        }
        
        else {
            cell.textLabel?.text = notes[indexPath.row].noteContent
            
            let dateString = dateFormatter.stringFromDate(notes[indexPath.row].createdAt)
            cell.detailTextLabel?.text = dateString
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Filtering Notes
        if searchController.active && searchController.searchBar.text != "" {
            return filteredNotes.count
        }
        
        notes = Note.all()
        return notes.count
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("DetailsSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // Filtering Notes
        if searchController.active && searchController.searchBar.text != "" {
            filteredNotes[indexPath.row].deleteobject()
        }
        else {
            notes[indexPath.row].deleteobject()
        }
       
        tableView.reloadData()
    }
    
    
    //MARK: Prepare for Segue
    @IBAction func composeNoteButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("DetailsSegue", sender: nil)
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailsSegue" {
            
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! NoteDetailsViewController
            controller.delegate = self
            controller.backButtonDelegate = self
            
            if sender != nil {
                 
                if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                    
                    //Filtering notes
                    if searchController.active && searchController.searchBar.text != "" {
                        controller.noteToEdit = filteredNotes[indexPath.row]
                        searchController.active = false
                        searchController.searchBar.text = ""
                    }
                    else {
                        controller.noteToEdit = notes[indexPath.row]
                    }
                    
                    
                    
                    
                }
            }
            
        }
        
    }
    
    
    
    
    //MARK : Delegate Functions
    func noteDetailsViewController(controller: NoteDetailsViewController, didFinishAddingNote noteContent: String) -> Note {
//        dismissViewControllerAnimated(true, completion: nil)
        print("in didFinishADDINGNote: \(noteContent)")
        let newNote = Note(content: noteContent)
        newNote.save()
        
        tableView.reloadData()
        
        return newNote
        
    }
    
    func noteDetailsViewController(controller: NoteDetailsViewController, didFinishEditingNote note: Note, editedNote: String) {
//        dismissViewControllerAnimated(true, completion: nil)
        print("in didFinishEDITINGNote: \(editedNote)")
        note.edit(editedNote)
        
        tableView.reloadData()
    }
    
    func backButtonPressedFrom(controller: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }



}

