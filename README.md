# Dev environment completely in docker. This keeps your desktop nice and clean so when something goes wrong in your dev env it dosen't screw up your entire system.

## Goals of this project
Create a linux work space that 
* portable
* consistent
* destroyable

Start container with volumes attached

## TODO
[x] create running image with vim and zsh
[ ] implement yarn instead of npm
[ ] compile YouCompleteMe with c# and rust
[ ]
[ ]
[ ]

## Usage
~~~bash
docker run -it -v ~/Code:/code -v ~/Google/Learn:/learn --name container_name ie/java:dev
~~~

Attach to that container

~~~
docker exec -it container_name zsh
~~~

## Give credit where credit is due
This project wouldn't be possible without the prior art.
Thank you to the following inspirations.

@JAremko for alpine-vim  
@skwp for Yadr dotfiles
