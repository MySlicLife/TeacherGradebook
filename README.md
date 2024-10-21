# teacher_gradebook

A teacher's dream gradebook (eventually...). This is my first ever coding project, and it was made in flutter and dart. Using Isar for storage and BLoC for state management. The heavy focus was on a working app that was (visually) easy to debug. The future plans are to have the app follow a modern Neumorphic design. 

## Getting Started

Getting started is easy! Download the teacher.gradebook.exe from the latest releases and run the executable, thats it!. The program will automatically check for updates and download them if it finds a new one!.

##Roadmap
# v.0.2
This update will (hopefully) have a lot of the UI features since the bones are already there.
# UI
  - Fully working dark and light mode
  - Making the theme match for all of the elements
    - The landing page and welcome page will follow the main app theme that the user picks in the settings page.
    - The course page where you can select the courses will be in the theme of the year that you selected the color of
    - The grade page where you can modify the student's grades will be in the theme that the class is made to be.
    - There will be a toggle in the settings to use the colors that you select for the years or the colors that you specify in the settings
    - Create custom UI elements like buttons, text fields, for all of the things needed in the app
    - Have the background color for the student tile be their grade?
    - Change the student tile to have the following text elements (Student number for the class [alphabetical], Student's name, (Grade))
    - Have the student tiles be reorderable so that if a new student gets added they can be moved around OR have it so that the students are             ordered by last name
- Functionality
  - Add statistics for the grade page so the user can see the statistics for the class
    - This will include highest grade, lowest grade, mean grade, standard deviation of grades, and count of each grade type
    - Make student's average be based on the weighted grades and not the unweighted grades
  - Add an assignments page where you can click on an assignment and see statistics about it
    - Change the values as you need
    - Show the grade for every student
    - Assignment statistics, max, min, mean, median, standard deviation
    - Add the ability to change which grade type it is (test, homework, misc)


The roadmap will get crossed off as features get added so that you guys can keep track of the progress as I go!. Remember if there is ever an update that gets release it will automatically show up in your app!
