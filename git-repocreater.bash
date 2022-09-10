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
    GH_TOKEN="$(cat ~/.netrc | grep -A 2 "machine github.com" | grep "password" | sed "s/password//g" | sed "s/ //g" )"
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
    REPONAME="$(printf $1 | awk -F "/" '{print $NF}' | rev | cut -f 2- -d '.' | rev )"
    mkdir -p ~/.github/$REPONAME.git ;
    cp --force --recursive $1 ~/.github/$REPONAME.git ;
    cp --force --recursive ~/.github/GNU-GeneralPublicLicense-v3.0 ~/.github/$REPONAME.git/LICENSE.MD ;
    #
    ## Create a README.MD file
    if ! ls -a ~/.github/$REPONAME.git/README.MD ; then
        README="$(mktemp)"
        printf "\nCreate a README.MD: Control-D to continue\n" ;
        cat > $README ;
        printf "" ;
        cp --recursive --force $README ~/.github/$REPONAME.git/README.MD ;
        rm --force $README ;
    else
        printf "\nModify the README.MD: Control-D to continue\n" ;
        cat >> ~/.github/$REPONAME.git/README.MD |
        cat ~/.github/$REPONAME.git/README.MD ;
    fi
    cd ~/.github/$REPONAME.git ;
    git init ;
    git add * ;
    git commit -m "commit" ;
    git branch -M main ; 
    GITUSERTEMP="$(mktemp)"
    printf "$(gh auth status)" > "$GITUSERTEMP" ; 
    nano $GITUSERTEMP ;
    git remote add origin https://github.com/$GITUSERNAME/$REPONAME.git ; 
    DESCRIPTION="$(mktemp)" 
    printf "\nCreate a description: Control-D to continue\n" ; 
    cat >> $DESCRIPTION ;
    gh repo create $REPONAME --source . --public --remote origin --description "$(printf "$(cat $DESCRIPTION)")" ;
    rm --force $DESCRIPTION ;
    git push -u origin main ;
    git config pull.ffonly true ;
    git pull origin main ; 
    git push -u origin main ;
else
    printf "\nADD A FILE OR DIRECTORY AS ARGUMENT\n"
fi
