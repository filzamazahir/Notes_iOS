//
//  NoteDetailsViewController.swift
//  Notes Clone
//
//  Created by Filza Mazahir on 1/25/16.
//  Copyright © 2016 Filza Mazahir. All rights reserved.
//

import UIKit
class NoteDetailsViewController: UITableViewController, UITextViewDelegate {
    
    weak var delegate: NoteDetailsViewControllerDelegate?
    weak var backButtonDelegate: BackButtonDelegate?
    var noteToEdit: Note?
    
    @IBOutlet weak var newNoteTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newNoteTextView.delegate = self
        
        if let currentNote = noteToEdit {
            newNoteTextView.text = currentNote.noteContent
        }
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView) {

        if let note = noteToEdit {
            delegate?.noteDetailsViewController(self, didFinishEditingNote: note, editedNote: newNoteTextView.text!)
            print("in editing mode: \(newNoteTextView.text)")
            
        }
            
        else {
            noteToEdit = delegate?.noteDetailsViewController(self, didFinishAddingNote: newNoteTextView.text!)
            print("in saving new note mode: \(newNoteTextView.text)")
            
        }
        
    }
    

    
    @IBAction func backBarButtonPressed(sender: UIBarButtonItem) {
        backButtonDelegate?.backButtonPressedFrom(self)
    }
    

}