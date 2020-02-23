Note: if you use the simulator to run this project, please select a location under the debug menu of the simulator.

# VeoRideTest

### Summary

#### This application contains two pages.
1. Map page. The user can click a point near his location on the map, and then the start button will appear at the bottom of the screen. Click the start button to enter the route navigation mode.
2. Trip summary page. In the map page, when the user moves near the destination (within 6m of the selected location), the navigation will automatically be finished and this page will pop up. The page shows the user's moving path, trip time and total mileage on the map.

### Development steps
1. To get the requirements, first you should convert these requirements into page sketches on white paper. Design a sketch for each state of the page so that you can clearly know what you need to do.
2. Make a development task list and development plan according to the sketch.
3. Create a project and build a file directory structure. Considering that there is no need for network request and data processing, MVC mode can be directly used instead of MVVM mode.
4. Complete the development tasks one by one according to the development plan.<br>
4.1 Processe the request to obtain the location permission, the situation such as being rejected by the user shall be considered. You need to add the corresponding fields in info.plist.<br>
4.2 MapKit is introduced to develop map related functions. Create a tap gesture to add an annotation.<br>
4.3 Consider the display time of start button, and some logic to be handled when exiting the navigation.<br>
4.4 After the navigation task is completed, when the user jumps to the trip summary page, you need to take in the navigation start / stop time and navigation route, so as to display the path on the thumbnail map, and display the journey time and total mileage on the page.

### Development environment requirements
* iOS 13.0+ / Mac OS X 10.15+
* Xcode 11.0+
* Swift 5.0+
