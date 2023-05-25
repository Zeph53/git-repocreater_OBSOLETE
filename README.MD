# GIT-REPOCREATER  

This is a little Bash script to basically instantly upload stuff to GitHub.  
Just add an argument to the command used to run the script.  
Then it should create the repository directly on GitHub.  

It prompts you to login, automatically creates a .netrc style access token,  
configures gh and git to use it, permanantly logging you in.  

It then takes the file/folder added to the command execution as an argument,  
creates a repository directly on GitHub and then prompts the user to  
create a description or edit the current one. 
Afterwards, prompts the user to create a README.MD.  
Then simply uploads the files to the repository.  
Automatically.  

It can also be used to update the repository, or synchronize the local files with it.

## Installation  
Just download the ZIP and extract it somewhere, or clone the repository.  
#### Open the terminal and enter:  
    sudo git clone https://github.com/Zeph53/git-repocreater/
    sudo cd git-repocreater/
If you really wanted to, it can be added to "/usr/bin". Which makes it globally executable within Bash.  
#### Open the terminal and enter:  
    sudo git clone https://github.com/Zeph53/git-repocreater/
    sudo cp -r git-repocreater/git-repocreater.bash /usr/bin/
    sudo gio trash --force git-repocreater/
## Uninstallation  
To uninstall the script, simply remove the script from your system.  
#### Open the terminal and enter:  
    sudo gio trash --force ~/git-repocreater/
Or, if you installed it to "/usr/bin", remove the script from the binaries directory.  
#### Open the terminal and enter:  
    sudo gio trash --force /usr/bin/git-repocreater.bash
## Usage  
Simply execute the script with the file or folder that you would like to create a repository of as an argument.  
#### For example, with the terminal open:  
    sudo git-repocreater.bash "~/git-repocreater/git-repocreater.bash"
And then follow the directions presented by the terminal.  
## Troubleshooting  
The user must use their GitHub username rather than their email address to create an access token in ~/.netrc.
## Things to add  
More commentsing of lines.
Addition of some directions for the README.MD section.
##  Bugs
Synchronizing local files may not function properly.
The description for the repo isn't perfectly editable.
The README.MD section isn't perfectly editable.
Email addresses can't be parsed.
##
