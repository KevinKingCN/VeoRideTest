# VeoRideTest

### Summary

#### This application contains two pages
1. Map page. The user can click a point near the location on the map, and then the start button will appear at the bottom of the screen. Click the start button to enter the path navigation mode.
2. Itinerary summary page. In the map page, when the user moves near the destination (within 6m of the selected location), the navigation will automatically end and this page will pop up. The page shows the user's moving path, driving time and total mileage on the map.

### Development steps
1. To get the requirements, first convert these requirements into page sketches on white paper. Design a sketch for each state of the page so that you can clearly know what you need to do.
2. Make a development task list and development plan according to the sketch.
3. Create a project and build a file directory structure. Considering that there is no need for network request and data processing, MVVM mode can be directly used instead of MVVM mode.
4. Complete the development tasks one by one according to the development plan.<br>
4.1 when processing the request to obtain the location permission, the situation such as being rejected by the user shall be considered. You need to add the corresponding fields in info.plist.<br>
4.2 mapkit is introduced to develop map related functions. Create a click gesture to add an annotation.<br>
4.3 consider the display time of start button, i.e. some logic to be handled when exiting the navigation.<br>
4.4 after the navigation task of the destination is completed, when the user jumps to the journey summary page, he / she needs to input the navigation start / stop time and navigation path, so as to display the path on the thumbnail map, and display the journey time and total mileage on the page.
