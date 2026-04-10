# CPU-EE469

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