<p align="center">
  <img width="100" height="100" src="https://github.com/dangvugiahuy/chumeodiHERE/blob/main/img/icon1024x1024.png">
</p>

# Bird Bird 🐦

This application is based on game Flappy Bird


## Functions

- Play: Use Timer to perform the action that calls the game's UI update function, Inside the game's UI update function: change the coordinates of objects on the screen such as water pipes, ground, birds combined using DispatchQueue to perform actions to update the interface of all objects object after changing coordinates asynchronously.
- Scoring: Use CGRect.intersects to check for collisions between the bird and the water pipe, and calculate a score.
- Save Score: Use NSUserDefaults to store the highest score after playing, if the score of the current play is not as high as the previous play, the system will not save the results.


## Tech Stack

**Client:** UIKit

**Save data:** NSUserDefaults


## Demo

<p align="center">
  <img width="250" src="https://github.com/dangvugiahuy/chumeodiHERE/blob/main/gif/bird-bird.gif">
</p>
