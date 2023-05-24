#!/bin/bash

#
##

#
##

#
## Generate username and token for github in ~/.netrc
if ! grep -q "machine github.com" ~/.netrc; then
    read -p "GITHUB-USERNAME: " -a USERNAME ;
    read -s -p "GITHUB-PASSWORD: " -a PASSWORD ;
    printf "\n" ;
    printf "
machine github.com
    login $USERNAME
    password $PASSWORD\n" >> ~/.netrc ;
fi

#
## Login to GH
if ! gh auth status; then
    GH_TOKEN="$( cat ~/.netrc | grep -A 2 "machine github.com" | grep "password" | sed "s/password//g" | sed "s/ //g" )"
    printf "$GH_TOKEN\n" | gh auth login --with-token ;
    gh auth status ;
    gh config set git_protocol https ;
    gh auth setup-git ;
fi

#
## Create a repository
if [[ $1 ]]; then
    #
    ## Copy argument's contents to working sources dir
    REPONAME="$( printf $1 | awk -F "/" '{print $NF}' | rev | cut -f 2- -d '.' | rev )"
    mkdir -p ~/.github/$REPONAME.git ;
    cp --force --recursive $1 ~/.github/$REPONAME.git ;
    if ! ls -a ~/.github/GNU-GeneralPublicLicense-v3.0.txt ; then
        curl https://www.gnu.org/licenses/gpl-3.0.txt -o ~/.github/GNU-GeneralPublicLicense-v3.0.txt ;
    fi
    cp --force --recursive ~/.github/GNU-GeneralPublicLicense-v3.0.txt ~/.github/$REPONAME.git/LICENSE.MD ;
    #
    ## Create a README.MD file
    if ! ls -a ~/.github/$REPONAME.git/README.MD ; then
        README="$( mktemp )"
        printf "\nCreate a README.MD: Control-D to continue\n" ;
        cat > $README ;
        printf "" ;
        cp --recursive --force $README ~/.github/$REPONAME.git/README.MD ;
        rm --force $README ;
    else
        printf "\nModify the README.MD, press Control-D to continue:\n" ;
        cat >> ~/.github/$REPONAME.git/README.MD |
        cat ~/.github/$REPONAME.git/README.MD ;
    fi
    cd ~/.github/$REPONAME.git ;
    git init ;
    git add * ;
    git commit -m "commit" ;
    git branch -M main ;

    GITUSERNAMETEMP="$( cat ~/.config/gh/hosts.yml | grep "user" | awk '{printf $NF}' )"
    GITUSERNAME="$( printf $GITUSERNAMETEMP )"
    git remote add origin https://github.com/$GITUSERNAME/$REPONAME.git ; 


    DESCRIPTIONTEMP="$( mktemp )" 
    printf "\nCreate a description in the '"About"' section of your repository, press Control-D to continue:\n" ; 
    OLDDESCRIPTION="$( mktemp )" 
    gh repo view https://github.com/$GITUSERNAME/$REPONAME.git --jq "" --json description | awk -F '"' '{printf$4}' > $OLDDESCRIPTION 
    cat $OLDDESCRIPTION - $(printf $OLDDESCRIPTION) >> $DESCRIPTIONTEMP ;
    DESCRIPTION="$( printf "$(cat $DESCRIPTIONTEMP )")"


    gh repo create $REPONAME --source . --public --remote origin ;
    gh repo edit https://github.com/$GITUSERNAME/$REPONAME.git --description "$DESCRIPTION" ;
    rm --force $DESCRIPTIONTEMP ;
    git config pull.ffonly true ;
    git push -u https://github.com/$GITUSERNAME/$REPONAME.git main ;
    git pull https://github.com/$GITUSERNAME/$REPONAME.git main ; 
    git push -u https://github.com/$GITUSERNAME/$REPONAME.git main ;
else
    printf "
    ADD A FILE OR DIRECTORY AS ARGUMENT
    For example: $ git-repocreater.bash "/home/user/scripts/a-script-i-wanna-backup.sh"
    Out comes a repository on GitHub based on the name on the file/directory \n\n"
fi
