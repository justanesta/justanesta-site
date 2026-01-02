---
layout: layouts/bit.njk
title: "Customizing My Bash Prompt"
date: 2026-01-02
description: "A write up of how I implemented my new bash prompt and some reference resources of further customization options"
tags:
  - linux
  - bash  
  - bit
---

While in the process of improving all my dotfile configurations I came across the `$PS1` environment variable in my `~/.bashrc` file that specifies what my default interactive prompt looks like in [bash](https://www.gnu.org/software/bash/). Since I got my laptop running Pop!_OS it has been the default configuration below:

```bash
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
```

Which would render in the `$HOME` directory as: <span style="color: #00FF00; background-color: #282828;">justanesta@pop-os</span><span style="background-color: #282828;">:</span><span style="color: #0000AA; background-color: #282828;">~$ &nbsp;</span>

While this was a perfectly suitable default. I don't really understand the point of having the hostname (specified by the `\h` variable) in the command prompt. I also have never really loved the traditional dollar sign `$` at the end of command prompts.

I have seen countless examples of people customizing their command prompts and thought it was high time I roll out one of my own. After getting inspired by [this](https://webpro.nl/articles/getting-started-with-dotfiles#prompt) elegant and simple example from developer [Lars Kappert](https://webpro.nl/) I played around with [this](https://bash-prompt-generator.org/) helpful click-and-drop visual Bash Prompt Generator as well as [these](https://courses.cs.washington.edu/courses/cse374/16wi/lectures/PS1-guide.html) [helpful](https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797) [reference](https://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html) [resources](https://ss64.com/bash/syntax-prompt.html) and came up with the following:

```bash
PS1="${CLR_USER}\u${CLR_RESET} ${CLR_PATH}\w${CLR_RESET} ${CLR_GIT}\$(__git_prompt)${CLR_RESET} > "
```
Where here `__git_prompt` was customized elsewhere in the `~/.bashrc` file with the current git branch name (if applicable), otherwise nothing.

```bash
__git_branch() {
  # Prints current branch name, or nothing if not in a git repo
  git symbolic-ref --short HEAD 2>/dev/null
}

__git_prompt() {
  local b="$(__git_branch)"
  if [ -n "$b" ]; then
    printf "%s" "$b"
  fi
}
```

All this gave me what I really wanted: My username, the current working directory, and the current git branch name if the current working directory has an associated git repository. In my current working directory for this site it now looks like:

<span style="color: #00FF00; background-color: #282828;">justanesta&nbsp;</span><span style="color: #AAAA00; background-color: #282828;">~/projects/justanesta-site&nbsp;</span><span style="color: #AA0000; background-color: #282828;">main&nbsp;</span><span style="background-color: #282828;">></span>

Looking forward to customizing more options in my dotfiles and having them managed in version control so that they are portable to different machines and even operating systems!