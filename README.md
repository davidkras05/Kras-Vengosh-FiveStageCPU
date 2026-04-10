# CPU-EE469

**UPDATE PLEASE READ**

I edited the `runlab.do` file to get everything working and I added the proper time delays at the start of each file because modelsim didn't like that. After that got working, I made the modelsim test file `regtest.do` by dragging the stuff I think would be useful to see in the modelsim. So just pull the latest version of the repo, open up modelsim, type "do runlab.do" into it and you should see the waveform. thing is its HELLA long. Not sure how to fix that. I am also not sure how to check if we are seeing the right waveform, mostly cause its HELLA LONG. So the final thing we have to do is figure out how to read it and how to make it not hella long.

In order to set up the modelsim for the future, you have to edit `runlab.do` do have a hypothetical test file name. for this one I did `regtest.do`, and then open model sim and type "do runlab.do" and then drag the signals you want into the area (double click to rename them for ease) and then go to file->save format, then name the file to whatever you set the test file name for in the `runlab.do` file. then it should work the next time you do "do runlab.do" in the modelsim. Check out the `runlab.do` and `regtest.do` files in the repo if you want to see how I did it.

I did this all cause I woke up early due to intense seasonal allergies and couldn't get back to sleep. allergies have their perks I guess?

- Dave

This is the github for our CPU project.

you can get your own copy by doing `git clone https://github.com/davidkras05/CPU-EE469.git` in cmd

To add a change from your repo copy onto the repo:

1. go to cmd and navigate using cd *location* to your repo copy
2. after your changes type `git add .` in cmd and press enter
3. then do `git commit -m "your message"` and press enter
4. finally, do `git push` and press enter

To get the latest repo copy, navigate to your repo copy in cmd and type `git pull`

If none of that works make sure the config commands have been sent

`git config --global user.name "your name"`
and more importantly:
`git config --global user.email "*type your github email*"`

I updated the gitignore to include qpf (quartus project files) and qsf (quartus settings files) which means you can feel free to store your project file straight in your repo copy to work on multiple files at once and also do compiling. Makes everything a lot easier.

- David