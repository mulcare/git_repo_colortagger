#! /usr/local/bin/fish
#
# git repo colortagger for osx
# 
# A small tool to scan home dir for dirs containing git repos, then make sure
# they are tagged with the 'red' tag in Finder on OSX.


set red 0000000000000000000C00000000000000000000000000000000000000000000

set repos (find ~/ -name ".git" | sed 's/.git$//')

for repo in $repos
  set attrs (xattr $repo)
  
  if test -n "$attrs"
    for attr in $attrs
      if test "$attr" = "com.apple.FinderInfo"
        set has_finderinfo TRUE
      end
    end  
  
    if test has_finderinfo
      set color (xattr -p com.apple.FinderInfo $repo | sed 's/ *00 *//g')
      if test "$color" = "0C "
        echo "$repo already marked...skipping."
      else
        xattr -wx com.apple.FinderInfo \ $red $repo
	echo "$repo not marked...marking."
      end

    else
      xattr -wx com.apple.FinderInfo \ $red $repo
      echo "$repo not marked...marking."
    end
  
  else
    xattr -wx com.apple.FinderInfo \ $red $repo
    echo "$repo not marked...marking."
  end

end

