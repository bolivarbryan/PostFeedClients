# Posts Feed App

Need to take a look of what's is happening out there with technology. this is your chance to have the most important  recent news about new implementations, CEOs, and tech companies.

## Project distribution

###Common Models:

```
	Post

    /// Created timestamp from post
    private let createdAt: Date
    
    /// Author Name
    private let author: String?
    
    /// Story title
    private let storyTitle: String?
    
    /// Story URL for Post, used for see more details about post
    private let storyURL: String?
    
    /// Post identifier
    let objectID: String?
	
```

About API
-

By testing multiple times API, I found that there are two scenarios where data comes duplicated or nil. I resolved to use objectID as primary key in database (data still comes duplicated anyway), a solution could be to threat story_title as primary key but this is not reccomended. (please find evidence below).

![GitHub Logo](../Duplicates_Evidence.jpg)


iOS: 
-

Architecture used: *MVVM* ([https://www.objc.io/issues/13-architecture/mvvm/](https://www.objc.io/issues/13-architecture/mvvm/))

Project Distribution:

- **DatabaseManager**: Handles Database Connection and delete and fetch requests
- **API**: Moya's Syntactic sugar for establishing API connection
- **App**: Contains the complete app flow splitted by feature
	- **Posts**: Post list Feature.
		- **ViewModels**: Posts View Model where the API Meets database and prepares data for sharing with controller
		- **Controllers**: Standard UITableviewController for fetching Posts
		- **Views**: Contains Storyboards and UIView Components

		
Internal Dependencies Used:

- **UIKit**: Framework for building iOS Applications.
- **Foundation**: Apple standard framework for handling default operations in Swift Ecosystem
- **CoreData**: Data persistance framework for storing Data. in this case Posts feed
	- Data is Fetched and only updated in case a post is 'Deleted'

External dependencies:
- **Moya**: Dependency for organizing API requests sending them to a separate layer. It uses internally Alamofire.
- **AlamoFire**: Networking Dependency used for making API requests


Dependency Manager used: **Swift Package Manager**

XCode version used: **Xcode 12.0.1**
