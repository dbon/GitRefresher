# pass workspace dir as parameter to check the entire workspace for git status
set -e

workspace=$1

if [ -z "$workspace" ]
then
    workspace=~/workspace
fi

for current_dir in "$workspace/"*; do

    if [[ -d "$current_dir" ]]
    then

        cd "$current_dir"

        # count all .git folders inside $current_dir
        subdircount=`find . -name ".git" -maxdepth 1 -type d | wc -l`

        # check if .git folder exists
        if [ $subdircount -eq 1 ]
        then
            echo "$current_dir"
            git status --short
            continue
        fi

        for project in "$current_dir/"*; do

            if [[ -d "$project" ]]
            then
                cd "$project"

                # count all .git folders inside $current_dir
                subdircount=`find . -name ".git" -maxdepth 1 -type d | wc -l`

                # check if .git folder exists
                if [ $subdircount -eq 1 ]
                then
                    echo "$project"
                    # Update Refs
                    git remote update > /dev/null
                    # Show Status (you'll also see if your local repo is behind remote)
                    git status
                    continue
                fi

            else
                echo "[ERROR]: $current_dir is not a directory"
            fi
        done
    else
        echo "[ERROR]: $current_dir is not a directory"
    fi
done