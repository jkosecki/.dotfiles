[user]
	name = ${name}
	email = ${email}
[core]
	autocrlf = false
[branch]
	autosetuprebase = always
[merge]
  	ff = only
  	# I pretty much never mean to do a real merge, since I use a rebase workflow.
  	# Note: this global option applies to all merges, including those done during a git pull
  	# https://git-scm.com/docs/git-config#git-config-mergeff

  	conflictstyle = diff3
  	# Standard diff is two sets of final changes. This introduces the original text before each side's changes.
	# https://git-scm.com/docs/git-config#git-config-mergeconflictStyle

[commit]
  	gpgSign = false
  	# "other people can trust that the changes you've made really were made by you"
  	# https://help.github.com/articles/about-gpg/
  	# https://git-scm.com/docs/git-config#git-config-commitgpgSign

[push]
  	default = simple
  	# "push the current branch back to the branch whose changes are usually integrated into the current branch"
  	# "refuse to push if the upstream branch’s name is different from the local one"
  	#	 https://git-scm.com/docs/git-config#git-config-pushdefault

  	followTags = true
  	# Because I get sick of telling git to do it manually
  	# https://git-scm.com/docs/git-config#git-config-pushfollowTags

[status]
  	showUntrackedFiles = all
  	# Sometimes a newly-added folder, since it's only one line in git status, can slip under the radar.
  	# https://git-scm.com/docs/git-config#git-config-statusshowUntrackedFiles

[transfer]
  	fsckobjects = true
  	# To combat repository corruption!
  	# Note: this global option applies during receive and transmit
  	# https://git-scm.com/docs/git-config#git-config-transferfsckObjects
	# via https://groups.google.com/forum/#!topic/binary-transparency/f-BI4o8HZW0

[alias]
    master = "!git checkout master; git pull --rebase"

    commits = log --branches --not --remotes
    commitall = "!git add --all; git commit -m"

    newbranch = "!git master; git checkout -b"
    refresh = "!git_refresh"
    delete = "!git_branch_delete"

    alias = config --get-regexp ^alias\\.

    changes = diff --name-status --color master
    showlast = "!git show --name-only `git rev-parse HEAD`"
   
    l = log --oneline --graph
    logtree = log --graph --oneline --decorate --all
    glog = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
   
    assume = update-index --assume-unchanged
    unassume = update-index --no-assume-unchanged
    assumed = "!git ls-files -v | grep ^h | cut -c 3-"
    unassumeall = "!git assumed | xargs git update-index --no-assume-unchanged"
    assumeall = "!git st -s | awk {'print $2'} | xargs git assume"
   
    cp = cherry-pick
    st = status -s
    cl = clone
    ci = commit
    co = checkout
    br = branch
    diffw = diff --word-diff
    dc = diff --cached
    f = "!git ls-files | grep -i"
	bv = "!git br -v"
	fev = "!git fetch; git bv"
   
    r = reset
    r1 = reset HEAD^
    r2 = reset HEAD^^
    rh = reset --hard
    rh1 = reset HEAD^ --hard
    rh2 = reset HEAD^^ --hard
   
    pop = stash pop
    stashshow = stash show --name-only
    sl = stash list
    sa = stash apply
    ss = stash save
    latest = diff HEAD^ HEAD
    lasthash = log -1 --pretty=format:"%H"
   
[color]
    ui = true
[format]
    pretty = oneline
