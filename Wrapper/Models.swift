//
//  DiscogsWrapperHelper.swift
//  DiscogsWrapper
//
//  Created by Benny Lach on 07.06.15.
//  Copyright (c) 2015 BL. All rights reserved.
//
import Foundation

// MARK: - Discogs Artist
class DiscogsArtist {
    var id: Int!
    var name: String!
    var realname: String!
    var nameVariations: [String]!
    var profile: String!
    var members:[[String: AnyObject]]!
    var images:[[String: AnyObject]]!
    
    var urls:[NSURL]!
    var releasesURL:NSURL!
    var resourceURL:NSURL!
    
    var uri:NSURL!
    var dataQuality:String!
    
    init(artistDict: [String: AnyObject]) {
        id = artistDict["id"] as? Int
        name = artistDict["name"] as? String
        realname = artistDict["realname"] as? String
        nameVariations = artistDict["namevariations"] as? [String]
        profile = artistDict["profile"] as? String
        members = artistDict["members"] as? [[String: AnyObject]]
        images = artistDict["images"] as? [[String: AnyObject]]

        if let urls = artistDict["urls"] as? [String] {
            for url in urls {
                self.urls?.append(url.toURL()!)
            }
        }
        releasesURL = (artistDict["releases_url"] as? String)?.toURL()
        resourceURL = (artistDict["resource_url"] as? String)?.toURL()
        
        uri = (artistDict["uri"] as? String)?.toURL()
        dataQuality = artistDict["data_qualitiy"] as? String
    }
    
    func getReleases(completion: ToupleCompletionBlock) {
        if let id = self.id {
            DiscogsWrapper.sharedInstance.getReleasesOfArtist(id, completion: completion)
        } else {
            let error = Helper.sharedInstance.getError(.kReleaseNoId, code: .kMissingValue)
            completion(nil, error: error)
        }
    }
}

// MARK: - Discogs Release
class DiscogsRelease {
    
    var title: String!
    var id: Int!
    var artists: [[String:AnyObject]]!
    var extraArtists: [[String:AnyObject]]!
    var masterId: Int!
    
    var labels: [[String: AnyObject]]!
    var formats: [[String: AnyObject]]!
    var formatQuantity: Int!
    var notes: String!
    
    var released: String!
    var releasedFormatted: String!
    var country: String!
    var year: Int!
    var genres: [String]!
    var styles: [String]!
    var estimatedWeight: Double!
    var identifiers: [[String: AnyObject]]!
    
    var status: String!
    var dateAdded: NSDate!
    var dateChanged: NSDate!
    
    var images: [[String: AnyObject]]!
    var tracklist: [DiscogsTrack]!
    var companies: [[String: AnyObject]]!
    var videos: [[String: AnyObject]]!
    var series: [AnyObject]?
    
    var community: DiscogsCommunity!
    var masterURL: NSURL!
    var resourceURL: NSURL!
    
    var uri: NSURL!
    var dataQuality: String!
    var thumbURL: NSURL!
    
    init(releaseDict: [String: AnyObject]) {
        title = releaseDict["title"] as? String
        id = releaseDict["id"] as? Int
        artists = releaseDict["artists"] as? [[String: AnyObject]]
        extraArtists = releaseDict["extraartists"] as? [[String: AnyObject]]
        masterId = releaseDict["master_id"] as? Int
        
        labels = releaseDict["labels"] as? [[String: AnyObject]]
        formats = releaseDict["formats"] as? [[String: AnyObject]]
        formatQuantity = releaseDict["format_quantity"] as? Int
        notes = releaseDict["notes"] as? String
        
        released = releaseDict["released"] as? String
        releasedFormatted = releaseDict["released_formatted"] as? String
        country = releaseDict["country"] as? String
        year = releaseDict["year"] as? Int
        genres = releaseDict["genres"] as? [String]
        styles = releaseDict["styles"] as? [String]
        estimatedWeight = releaseDict["estimated_weight"] as? Double
        identifiers = releaseDict["identifiers"] as? [[String: AnyObject]]
        
        status = releaseDict["status"] as? String
        dateAdded = (releaseDict["date_added"] as? String)?.toDate()
        dateChanged = (releaseDict["date_changed"] as? String)?.toDate()
        
        images = releaseDict["images"] as? [[String: AnyObject]]
        tracklist = castTracklist(releaseDict["tracklist"] as? [[String: AnyObject]])
        companies = releaseDict["companies"] as? [[String: AnyObject]]
        videos = releaseDict["videos"] as? [[String: AnyObject]]
        
        if let communityDict = releaseDict["community"] as? [String: AnyObject] {
            community = DiscogsCommunity(communityDict: communityDict)
        }
        masterURL = (releaseDict["master_url"] as? String)?.toURL()
        resourceURL = (releaseDict["resource_url"] as? String)?.toURL()
        
        uri = (releaseDict["uri"] as? String)?.toURL()
        dataQuality = releaseDict["data_quality"] as? String
        thumbURL = (releaseDict["thumb"] as? String)?.toURL()
    }
    
    func masterRelease(completion:(master: DiscogsMasterRelease?, error: NSError?) -> Void) {
        if let id = masterId {
            DiscogsWrapper.sharedInstance.getMasterRelease(id, completion: { (responseObject, error) -> Void in
                completion(master: responseObject as? DiscogsMasterRelease, error: error)
            })
        } else {
            let error = Helper.sharedInstance.getError(.kReleaseNoMasterId, code: .kMissingValue)
            completion(master: nil, error: error)
        }
        
    }
    
    private func castTracklist(trackArray: [[String: AnyObject]]?) -> [DiscogsTrack]? {
        if let tracks = trackArray {
            var castedTracks = [DiscogsTrack]()
            
            for track in tracks {
                castedTracks.append(DiscogsTrack(trackDict: track))
            }
            return castedTracks
        }
        return nil
    }
}

// MARK: - Discogs Master Release
class DiscogsMasterRelease {
    var title: String!
    var id: Int!
    var artists: [[String: AnyObject]]!
    var mainRelease: Int!
    
    var year: Int!
    var genres: [String]!
    var styles: [String]!
    
    var images: [[String: AnyObject]]!
    var tracklist:[DiscogsTrack]!
    var videos: [[String: AnyObject]]!
    
    var mainReleaseURL: NSURL!
    var versionsURL: NSURL!
    var resourceURL: NSURL!
    
    var uri: NSURL!
    var dataQuality: String!
    
    init(masterDict: [String: AnyObject]) {
        title = masterDict["title"] as? String
        id = masterDict["id"] as? Int
        artists = masterDict["artists"] as? [[String: AnyObject]]
        mainRelease = masterDict["main_release"] as? Int
        
        year = masterDict["year"] as? Int
        genres = masterDict["genres"] as? [String]
        styles = masterDict["styles"] as? [String]
        
        images = masterDict["images"] as? [[String: AnyObject]]
        tracklist = castTracklist(masterDict["tracklist"] as? [[String: AnyObject]])
        videos = masterDict["videos"] as? [[String: AnyObject]]
        
        mainReleaseURL = (masterDict["main_release_url"] as? String)?.toURL()
        versionsURL = (masterDict["versions_url"] as? String)?.toURL()
        resourceURL = (masterDict["resource_url"] as? String)?.toURL()
        
        uri = (masterDict["uri"] as? String)?.toURL()
        dataQuality = masterDict["data_quality"] as? String
    }
    
    func getVersions(completion: ToupleCompletionBlock) {
        if let id = self.id {
            DiscogsWrapper.sharedInstance.getMasterReleaseVersions(id, completion: completion)
        } else {
            let error = Helper.sharedInstance.getError(.kMasterNoId, code: .kMissingValue)
            completion(nil, error: error)
        }
    }
    
    private func castTracklist(trackArray: [[String: AnyObject]]?) -> [DiscogsTrack]? {
        if let tracks = trackArray {
            var castedTracks = [DiscogsTrack]()
            
            for track in tracks {
                castedTracks.append(DiscogsTrack(trackDict: track))
            }
            return castedTracks
        }
        return nil
    }
}

// MARK: - Discogs Track
class DiscogsTrack {
    var duration: Double!
    var position: String!
    var title: String!
    var type: String!
    
    init(trackDict: [String: AnyObject]) {
        duration = trackDict["duration"] as? Double
        position = trackDict["position"] as? String
        title = trackDict["title"] as? String
        type = trackDict["type"] as? String
    }
}

// MARK: - Discogs Label
class DiscogsLabel {
    var name: String!
    var profile: String!
    var id: Int!
    var contactInfo: String!
    
    var subLabels: [[String: AnyObject]]!
    var images: [[String: AnyObject]]!
    
    var urls: [NSURL]!
    var releasesURL: NSURL!
    var resourceURL: NSURL!
    
    var uri: NSURL!
    var dataQuality: String!
    
    init(labelDict: [String: AnyObject]) {
        name = labelDict["name"] as? String
        profile = labelDict["profile"] as? String
        id = labelDict["id"] as? Int
        contactInfo = labelDict["contact_info"] as? String
        
        subLabels = labelDict["sublabels"] as? Array
        images = labelDict["images"] as? [[String: AnyObject]]
        
        if let urls = labelDict["urls"] as? [String] {
            for url in urls {
                self.urls?.append(url.toURL()!)
            }
        }
        
        if let releasesURLString = labelDict["releases_url"] as? String {
            releasesURL = NSURL(string:releasesURLString)
        }
        if let resourceURLString = labelDict["resource_url"] as? String {
            resourceURL = NSURL(string:resourceURLString)
        }
        if let uriString = labelDict["uri"] as? String {
            uri = NSURL(string:uriString)
        }
        self.dataQuality = labelDict["data_quality"] as? String
    }
    
    func getReleases(completion: ToupleCompletionBlock) {
        if let id = self.id {
            DiscogsWrapper.sharedInstance.getLabelReleases(id, completion: completion)
        } else {
            let error = Helper.sharedInstance.getError(.kLabelNoId, code: .kMissingValue)
            completion(nil, error: error)
        }
    }
}


// MARK: - Discogs Community
class DiscogsCommunity {
    struct Rating {
        var average: Double!
        var count: Int!
        
        init(ratingDict: [String: AnyObject]?) {
            average = ratingDict?["average"] as? Double
            count = ratingDict?["count"] as? Int
        }
    }
    
    var contributors: [[String: AnyObject]]!
    var dataQuality: String!
    var have: Int!
    var want: Int!
    var rating: Rating!
    var status: String!
    var submitter: [String: AnyObject]!
    
    init (communityDict: [String: AnyObject]) {
        contributors = communityDict["contributors"] as? [[String: AnyObject]]
        dataQuality = communityDict["data_quality"] as? String
        have = communityDict["have"] as? Int
        want = communityDict["want"] as? Int
        rating = Rating(ratingDict: communityDict["rating"] as? [String: AnyObject])
        status = communityDict["status"] as? String
        submitter = communityDict["submitter"] as? [String: AnyObject]
    }
}

// MARK: - Discogs User
class DiscogsUser {
    var id: Int!
    var name: String!
    var username: String!
    var profile: String!
    var location: String!
    var registered: NSString!
    
    var email: String!
    var homepage: NSURL!
    
    var rank: Int!
    var numPending: Int!
    var releasesContributed: Int!
    var releasesRated: Int!
    var ratingAverage: Double!
    
    var numLists: Int!
    var numCollection: Int!
    var numWantlist: Int!
    var numForSale: Int!
    
    var collectionFieldsURL: NSURL!
    var collectionFoldersURL :NSURL!
    var wantlistURL: NSURL!
    var inverntoryURL: NSURL!
    
    var avatarURL: NSURL!
    var uri: NSURL!
    var resourceURL: NSURL!
    
    init(userDict: [String: AnyObject]) {
        id = userDict["id"] as? Int
        name = userDict["name"] as? String
        username = userDict["username"] as? String
        profile = userDict["profile"] as? String
        location = userDict["location"] as? String
        registered = userDict["registered"] as? String
        
        email = userDict["email"] as? String
        homepage = (userDict["home_page"] as? String)?.toURL()
        
        rank = userDict["rank"] as? Int
        numPending = userDict["num_pending"] as? Int
        releasesContributed = userDict["releases_contributed"] as? Int
        releasesRated = userDict["releases_rated"] as? Int
        ratingAverage = userDict["rating_avg"] as? Double
        
        numLists = userDict["num_lists"] as? Int
        numCollection = userDict["num_collection"] as? Int
        numWantlist = userDict["num_wantlist"] as? Int
        numForSale = userDict["num_for_sale"] as? Int
        
        collectionFieldsURL = (userDict["collection_fields_url"] as? String)?.toURL()
        collectionFoldersURL = (userDict["collection_folders_url"] as? String)?.toURL()
        wantlistURL = (userDict["wantlist_url"] as? String)?.toURL()

        inverntoryURL = (userDict["inventory_url"] as? String)?.toURL()
        
        avatarURL = (userDict["avatar_url"] as? String)?.toURL()
        uri = (userDict["uri"] as? String)?.toURL()
        resourceURL = (userDict["resource_url"] as? String)?.toURL()
    }
    
    func getSubmissions(completion: (submissionDict: [String: AnyObject]?, error: NSError?) -> Void) {
        if let name = self.username {
            DiscogsWrapper.sharedInstance.getUserSubmissions(name, completion: { (responseObject, error) -> Void in
                completion(submissionDict: responseObject as? [String: AnyObject], error: error)
            })
        } else {
            let error = Helper.sharedInstance.getError(.kUserNoUsername, code: .kMissingValue)
            completion(submissionDict: nil, error: error)
        }
        
    }
    
    func getContributions(completion: (constributionDict: [String: AnyObject]?, error: NSError?) -> Void) {
        if let name = self.username {
            DiscogsWrapper.sharedInstance.getUserContributions(name, completion: { (responseObject, error) -> Void in
                completion(constributionDict: responseObject as? [String: AnyObject], error: error)
            })
        } else {
            let error = Helper.sharedInstance.getError(.kUserNoUsername, code: .kMissingValue)
            completion(constributionDict: nil, error: error)
        }
    }
}