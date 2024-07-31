# shader_studio

This app showcases my implementation of different shaders. 


## Implemented shaders
### Motion Blurred List
This shaders adds motion blur and varying distortion at the edges of the screen depending on the scroll speed.

![Simulator Screen Recording - iPhone 15 Pro - 2024-07-30 at 14 54 15](https://github.com/user-attachments/assets/c8c5fb76-285b-4468-afd3-cded2eaaaae7)

### RGB Split Distortion Effect
This is actually the Flutter implementation of a shader from https://x.com/dankuntz. It adds RGB Split and some distortion to the screen where the user touches.

![Simulator Screen Recording - iPhone 15 Pro - 2024-07-26 at 12 35 04](https://github.com/user-attachments/assets/56dbc8a3-a706-4814-842d-9b47f67ccd3b)

## Structure
Under 
- lib/shaders you will the shaders.
- lib/pages you will find the pages implementing the shaders.

## NOTICE 
Only works on iOS and macOS right now. For help with Android and Web feel free to contact me or open a PR.
