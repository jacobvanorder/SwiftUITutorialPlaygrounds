# SwiftUITutorialPlaygrounds

## Why?

Oh man! SwiftUI! It's gonna be great! Wait, what's that?

> Tools for SwiftUI development are only available when running on macOS 10.15 beta.

Well, what are you going to do? Let's try playgrounds!

* ✅ Lesson 1: Creating and Combining Views
* ✅ Lesson 2: Building Lists and Navigation
* ❌ Lesson 3: Handling User Input
* ❌ Lesson 4: Drawing Paths and Shapes
* ❌ Lesson 5: Animating Views and Transitions
* ❌ Lesson 6: Composing Complex Interfaces
* ❌ Lesson 7: Working with UI Controls
* ❌ Lesson 8: Interfacing with UIKit

## Lessons Learned

Ultimately, I had to give up. It got to the point where it was a _worse_ experience compared to just Build & Running in Xcode. Why?

* Source files outside of the Playground wouldn't autocomplete which is crucial for something not well known or documented
* Source files weren't able to pull in code from the main Playground file resulting in an all-or-nothing approach to the code either being in the main Playground or in source files. This defeated the idea I was going for where the playground would be strictly the SwiftUI code which would live update
* I ran into technical issues associated with Playgrounds like `CGGraphicContext` being grumpy, not being able to use .jpgs, and many others
* Crashing, crashing, crashing.

## So, what did you do?

I bought a USB thumb drive of decent speed and installed Catalina on that. It works _fine_.