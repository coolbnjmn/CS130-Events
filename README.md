# CS130-Events
CS130 Project with Mark, Matt, Ari, Shai, Collin and Ben

##Setup Instructions
1. Ensure you have the latest version of Xcode installed on your computer. You can find the latest release at https://developer.apple.com/xcode/downloads/

2. Install cocoapods to your Mac by opening Terminal and executing the command 
  > sudo gem install cocoapods

3. Clone the git repository at `https://github.com/coolbnjmn/CS130-Events.git` by executing the command
  > git clone https://github.com/coolbnjmn/CS130-Events.git

4. Navigate to the directory `Udder_ios/Udder/`, i.e.
  > cd Udder_ios/Udder

5. Execute the command
  > pod install

6. Once all the necessary pod files have installed, open `Udder.xcworkspace` **NOT** `Udder.xcodeproj`

7. In the top-left corner of Xcode, there are two icons that look like `Udder>iOS Device`. Press on the `iOS Device` and set it to `iPhone6` for optimal performance.

8. Press the right-facing arrow button at the top-left of Xcode to build and run the app. Alternatively, you can press `Product/Run` or `command+R`.

##Backend Testing Instructions
1. Ensure that you have Node.js installed on your computer. You can find the latest release at https://nodejs.org/download/

2. Navigate to the directory `Udder_parse/Udder/`, i.e.
  > cd Udder_parse/Udder

3. Run the following command to install the testing dependencies, shown in the package.json file. This will create a directory called node_modules.
  > npm install

4. To run the tests, run the mocha command shown below. We found that the default timeout of 2000 ms was too little for our asynchronous calls, so we set the parameter to 15000 to be safe. 
  > ./node_modules/mocha/bin/mocha --timeout 15000

NOTE: The Parse credentials necessary to run these tests are not included in the test files in the repository for security reasons. If you would like to run the tests, please contact the Udder development team.
