# DataBounce Task Management

- An application designed to parse real time productivity data into an interactive persistent enviroment using the [Gosu framework](http://code.google.com/p/gosu/) to render graphics and sound.

![Screenshot](https://raw.githubusercontent.com/llexileon/datavisual/master/assets/screen1.png)

- My aim was to create an asthetically pleasing executive desk toy augmented with real time productivity data.

- This application pulls data from the [DataSymbiote](http://datasymbiote.herokuapp.com) API developed by [Alex Wong](https://github.com/mazzastar) and [Joseph Wolf](https://github.com/josephwolf). You can create a free [DataSymbiote](http://datasymbiote.herokuapp.com) account in order to enter your own task list and priorities for DataBounce to render.

# Usage

    gem install gosu
    git clone git://github.com/llexileon/datavisual.git
    cd datavisual
    ./game.rb


# Controls

* Enter [DataSymbiote](http://datasymbiote.herokuapp.com) login on the title screen and click B to activate DataBounce
* Click tasks to freeze them, simultaneously accessing title, description and urgency. Click again to unfreeze.
* L to return to Login Screen at any time
* M to mute / unmute audio
* Q or ESC to quit

# Thanks

* Soundtrack from http://www.playonloop.com
* Sound FX sourced from http://www.freesfx.co.uk/
* Special thanks to [Alex Wong](https://github.com/mazzastar) for his assistance with the necessary DateTime calculations.
