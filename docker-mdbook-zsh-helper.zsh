scriptPathMdbookZshrc=$(realpath "$0")
scriptDirPathMdBookZshrc=$(dirname $scriptPathMdbookZshrc)
mdbookVimwikiDirectory=~vimwiki/notes

docker_id="5f93c7b0820f"


# inspired by
# https://www.reddit.com/r/commandline/comments/1737pqp/comment/k43275c/?utm_source=share&utm_medium=web2x&context=3
mmdbm () {
    # usage: bm bookmark (bookmarks current directory)
    [ -f ~/.config/mdbookmarks ] || touch ~/.config/mdbookmarks
    if grep -E $PWD'$' ~/.config/mdbookmarks
    then
        echo ...already exists
    else
        echo "$PWD" >> ~/.config/mdbookmarks
    fi
}

mmdto () {
    q=" $*"
    q=${q// -/ !}
    # allows typing "to foo -bar", which becomes "foo !bar" in the fzf query
    cd "$(fzf -1 +m -q "$q" < ~/.config/mdbookmarks)"
}

mmdecho() { 
    q=" $*"
    q=${q// -/ !}
    # allows typing "to foo -bar", which becomes "foo !bar" in the fzf query
    directory=$(fzf -1 +m -q "$q" < ~/.config/mdbookmarks)

    #echo ${directory:t}
    echo $directory
}

mmdls() {
  #ls -la $mdbookVimwikiDirectory

  cat ~/.config/mdbookmarks
}

mmdstart() {
  directory=$(mmdecho $1)
  docker run --network=docker-mdbook_default -v $directory:/book -p 3000:3000 $docker_id serve -n 0.0.0.0 .
  # mmdto $1
  # docker-compose
}

mmdopen() {
  directory=$(mmdecho $1)
  v $directory
}

mmdvzshrc() {
  v $scriptPathMdbookZshrc
  source $scriptPathMdbookZshrc
}

