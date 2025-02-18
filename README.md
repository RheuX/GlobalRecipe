### Summary: Include screen shots or a video of your app highlighting its features
I build a simple recipe menu app, it includes a title in the center of the app, and it will a showcase a list (if there are recipes loaded from the API). As you can see from the picture below, Each row has a small picture, the name and cuisine of the dish, and it has 2 icons for the source URL and youtube URL if given by the API. For the optional, such as the pictures and URL, if they are not given by the API, I made it so it has a placeholder image, or the links button would have an opacity near 0.5 (indicating that it's not accessible). The images are loaded using AsyncImage.

<img src="https://github.com/user-attachments/assets/a2ffce54-708d-4c2f-9651-afa7aa3b2d30" width="300" />

For the edge case regarding the API, first we can start if the API data is malformed (or not formatted according to what we expected), this will be display `No Recipe Found`, with a small text regarding the error. I'm catching the errors using a do try catch block, so it covers more than a `key not found` error. If the API data is empty, then it would simply say `No Recipe Found`, but there will be no error messages.

<img src="https://github.com/user-attachments/assets/08d8f4a7-db5a-4139-a6c0-c2dd7f1b6452" width="300" />
<img src="https://github.com/user-attachments/assets/249b80ee-da93-4089-8bf2-4fc6406f0de9" width="300" />

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I chose to focus on how I would fetch the API and error handling; Since from personal experience, if you don't have a good error handling when fetching APIs, it will be struggle to debug. Especially because anything can go wrong with API, whether its the backend fault, or maybe the structure in frontend at fault. Having multiple error handlers can make debugging much more nicer for me, and also future developers who are using the fetch API functions.

I also think about caching and how I would perform. Since there wasn't any specification on how the caching would work. I was thinking either having the data persist towards multiple session or just that session, and think on multiple ways on solving each idea. I would say its good to focus on these area because there are multiple ways you can think about how to improve the efficiency issue, so it's not something I can just think about once, and execute it. I should think more about the tradeoffs between each implementations.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
This is a rough estimate on how much I work on this project:

Initial Start -> ~1 hours
- Creating the initial plan: 15-20 minutes
- MVVM initial implementation: 30-40 minutes
- Finalizing UI strucutres: 20 minutes

Bug Fixes & Enchancements -> ~1 hours
- Fixing a bug with links: 30 minutes
- Implementing error handling with throws: 30 minutes
- Adding published message handling: 10 minutes

Optimizing Network Request & Caching -> 2 hours
- Researching efficient network request
- Evaluated async image or custom image
- Hashing or Time Caching solutions
- Implemented NSCache and UserDefaults for Caching

Unit Testing with XCTest -> 2-3 hours
- Research XCTest -> 1 hour
- Writing Unit Test -> 1-2 hours
- Refactor fetchRecipes and created services

**TOTAL HOURS: ~6-7 HOURS**

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
One of the most significant decisions I had to make in this project was how to handle caching. This involved two key aspects:

**JSON Data Caching**

Initially, my goal was to avoid unnecessary API fetches and redundant JSON decoding. I considered two approaches:

1. Hashing the data – Comparing the hash values of the old and new responses to detect changes.
2. Time validation – Avoiding API requests within a certain time window after a recent fetch.

I decided to use hashing since it improves efficiency by ensuring we only re-fetch when data changes. However, I encountered a drawback—Swift’s built-in Hasher generates a different hash value across sessions, even for identical data. This means that while hashing works well within a session, it resets after app termination. A potential solution to this would be using SHA256 hashing with CryptoKit for a more consistent hash, but I was unsure if this would be considered a third-party dependency.

For caching the API response, I chose NSCache, as it allows caching data within the session without persisting it across app restarts. I made this decision based on the assumption that persistent caching wasn’t required for this project. While I considered CoreData, given the time I need to learn and execute it, I chose not to do it.

**Image Caching**

For images, I used AsyncImage, which loads recipe images dynamically. However, AsyncImage only caches responses with URLCache, not the images themselves. This posed a limitation—if the user goes offline, previously loaded images wouldn't be available.

Since I opted for session-based caching, I decided not to implement a custom caching mechanism for images. However, if I were to extend caching across sessions, I would use NSCache for in-memory caching and CoreData or FileManager for persistent storage. Given that each recipe has a UUID, I could store images using the UUID as the key, allowing retrieval even when offline.

This caching decision balanced efficiency and simplicity within the project scope while leaving room for future improvements if persistent storage became a requirement.

### Weakest Part of the Project: What do you think is the weakest part of your project?

The weakest part of my project would probably be the caching and the Unit Testing part

I have little to none experience with Caching and Unit Testing. While I have some of the theory kept in my head, executing is still a major issue as I still have a lot to learn. I recognize that my current caching approach could be improved. With using AsyncImages, it limits the app as it doesn't persist images across app sessions. A more efficient solution is with using a CoreData so that it's able to get the images without additional network request. 

Unit testing is another area where I lack experience, especially testing with MVVM Model. It took longer than expected since I'm not familiar with XCTest anymore, and I had to make assumptions about how these components should be tested properly. While I did manage to create some test, I don't feel confident with I created is the standard of testing, or I'm just testing the bare/under minimum.

I would appreciate any feedback, especially with the Unit Testing, with how I built a great Unit Testing, and how much should I cover in terms of example or edge cases.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

**Note**: While there was no strict time constraint, I aimed to balance time and efficiency. Given the need for research and implementation, I prioritized completing the core requirements over additional enhancements to ensure a timely submission. However, I recognize there are areas that could be further refined with more time.

I had to do a lot of research on the internet on some things, so I would leave a reference:
- https://forums.developer.apple.com/forums/thread/704884
- https://stackoverflow.com/questions/61621960/how-do-i-hyperlink-a-button-in-swiftui/71182436#71182436
- https://forums.developer.apple.com/forums/thread/704884
- https://stackoverflow.com/questions/55389926/error-handling-using-jsondecoder-in-swift?utm_source=chatgpt.com
- https://stackoverflow.com/questions/40665869/how-to-approach-caching-in-ios-development-with-swift
- https://nirajpaul2.medium.com/how-to-write-a-test-case-for-the-api-call-in-swift-ios-69be089f4041
