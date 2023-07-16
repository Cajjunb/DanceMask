# Dance Mask

## Description
The Webcam Motion Detection project is built using the Processing programming language. It captures images from the webcam, applies optical flow detection algorithms, specifically the Horn & Schunck algorithm, and calculates the amount of motion between consecutive frames. When a minimum threshold of motion is detected, it draws pixels from a PNG image file at the location of detected motion.

## Features
- Webcam image capture
- Optical flow detection using the Horn & Schunck algorithm
- Motion calculation between frames
- Dynamic drawing of pixels from a PNG image based on detected motion

## Requirements
- Processing IDE
- Webcam connected to the computer

## Installation
1. Clone the repository or download the project files to your local machine.
2. Open the project in the Processing IDE.

## Usage
1. Open the main project file in the Processing IDE.
2. Make sure your webcam is connected and properly configured.
3. Press the "Run" button or use the shortcut (Ctrl+R / Cmd+R) to compile and execute the application.
4. The webcam feed will be displayed, and motion detection will start.
5. Move in front of the webcam or introduce motion in the scene to trigger the drawing of pixels from the PNG image.
6. Adjust the motion detection threshold or other parameters as desired.
7. PS: YOU NEED THE APROPRIATE LIBRARIES TO RUN!

## Example of it's function:
![Motion Detection](motion-capture-example.gif)

## Contributing
Contributions are welcome! If you have suggestions, bug reports, or would like to contribute to the project, please follow the guidelines outlined in the CONTRIBUTING.md file.

## Credits
This project is maintained by [Leandro Ramalho Motta Ferreira]. If you have any questions or inquiries, please contact [cajjunb@gmail.com].

## License
This project is licensed under the [MIT License](LICENSE).
