
![logo](images/gelo-tag.png)

Sample GeLo SDK iOS Application
===================================

This sample application demonstrates how to use the GeLo iOS SDK within a typical Objective-C iOS application.



Building the sample application for development
-----------------------------------
The guide will assume your using a Mac OSX environment, and that you have a copy of the GeLo SDK already on your system and building without error.


1. Clone the Project
```bash
    git clone git@github.com:GeLoInc/GeLo-App-Sample.git
```

2. Open the 'example.xcodeproj' file in Xcode 5.0 or newer

3. Add a reference to the 'GeLo SDK' under the project's "Build Phases" -> "Link Binary With Libraries".

That should be all you need to do, to get the sample application to compile. Add proper Apple app signing certificates / provisioning and the application should run on your development devices.