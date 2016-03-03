//
//  Note.swift
//  Notes Clone
//
//  Created by Filza Mazahir on 1/25/16.
//  Copyright © 2016 Filza Mazahir. All rights reserved.
//

import Foundation
class Note: NSObject, NSCoding {
    static var key: String = "Notes"
    static var schema: String = "NotesList"
    var noteContent: String
    var createdAt: NSDate
    var updatedAt: NSDate
    

    init(content: String) {
        noteContent = content
        createdAt = NSDate()
        updatedAt = NSDate()
    }
    
    // MARK: - NSCoding protocol
    // used for encoding (saving) objects
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(noteContent, forKey: "noteContent")
        aCoder.encodeObject(createdAt, forKey: "createdAt")
        aCoder.encodeObject(createdAt, forKey: "updatedAt")
    }
    
    
    // used for decoding (loading) objects
    required init?(coder aDecoder: NSCoder) {
        noteContent = aDecoder.decodeObjectForKey("noteContent") as! String
        createdAt = aDecoder.decodeObjectForKey("createdAt") as! NSDate
        updatedAt = aDecoder.decodeObjectForKey("updatedAt") as! NSDate
        super.init()
    }
    
    // MARK: - Queries
    static func all() -> [Note] {
        var notes = [Note]()
        let path = Database.dataFilePath("NotesList")
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                notes = unarchiver.decodeObjectForKey(Note.key) as! [Note]
                unarchiver.finishDecoding()
            }
        }
        if notes != [] {
            var noteListSorted = false
            while noteListSorted == false {
                noteListSorted = true // reset
                for var i = 0; i < notes.count-1; ++i {
                
                    print("First Date: \(notes[i].noteContent) updated at \(notes[i].updatedAt) and created at \(notes[i].createdAt), Second Date: \(notes[i+1].noteContent) updated at \(notes[i+1].updatedAt) and created at \(notes[i+1].createdAt)")
//                if notes[i].createdAt.timeIntervalSinceReferenceDate <  notes[i+1].createdAt.timeIntervalSinceReferenceDate {
                
                    if notes[i].updatedAt.compare(notes[i+1].updatedAt) == NSComparisonResult.OrderedAscending {
                        print("date sorted: \(notes[i].noteContent) and \(notes[i+1].noteContent)")
                        let temp = notes[i]
                        notes[i] = notes[i+1]
                        notes[i+1] = temp
                        noteListSorted = false
                    }
                }
            }
        }
        
        return notes
    }
    func save() {
        var notesFromStorage = Note.all()
        var exists = false
        for var i = 0; i < notesFromStorage.count; ++i {
            if notesFromStorage[i].createdAt == self.createdAt {
                notesFromStorage[i] = self
                exists = true
            }
        }
        if !exists {
            notesFromStorage.append(self)
        }
        Database.save(notesFromStorage, toSchema: Note.schema, forKey: Note.key)
    }
    
    func edit(editedNote: String){
//        print (self.noteContent)
//        print (editedNote)
        var notesFromStorage = Note.all()
        for var i = 0; i < notesFromStorage.count; ++i {
            if notesFromStorage[i].createdAt == self.createdAt {
                notesFromStorage[i].noteContent = editedNote
                notesFromStorage[i].updatedAt = NSDate()
                print("\(notesFromStorage[i].noteContent) updated at \(notesFromStorage[i].updatedAt)")
                
            }
            Database.save(notesFromStorage, toSchema: Note.schema, forKey: Note.key)
        }
    }
    
    func deleteobject() {
        print("object deleted")
        var notesFromStorage = Note.all()
        for var i = 0; i < notesFromStorage.count; ++i {
            if notesFromStorage[i].createdAt == self.createdAt {
                notesFromStorage.removeAtIndex(i)
                
            }
            Database.save(notesFromStorage, toSchema: Note.schema, forKey: Note.key)
        }
        
    }
    
    
}