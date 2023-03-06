# Stellar-Nvim

Stellar-Nvim is an extensible configuration for Neovim. It takes advantage of modern Neovim 8.0+ features such as
the Language Server Protocol and Treesitter.

Stellar-Nvim evolved from my personal neovim configuration and I made it because I wanted to have something extensible
that others could use as well, if they wish to. I also love to experiment with my configuration and I figured that
making something like this would allow me to have a really deep understanding of what's happening on the lower level.

You are free to use this configuration and customize it to your liking, or just learn from it and implement your own
config from scratch! I don't expect this project to grow too big since again, this is mostly just something I threw
together to learn about these newer features in neovim, but if you do like the project and you know of a way to improve
it, it is fully open to pull requests or if you don't know how to make something yourself, you can make a
feature request by opening a github issue.

## This project is still heavily Work In Progress

I started working on this project only very recently and it is far from what I want it to be. While I do try to keep
the main branch mostly stable and kind of usable, I can't promise you anything since this project isn't supposed to
be ready just yet. If you do find some bug, please report it with an issue, or if you feel like it, you can always try
to fix it yourself and submit a pull request, that's the best way to learn something new!

## Sample image

NOTE: This sample image is outdated!

![Screenshot_2021-12-06_14-31-37](https://user-images.githubusercontent.com/20902250/144854879-f35de259-cea1-4415-9a3b-b093fe008836.png)

## Usage

My goal with this repository is to make my neovim configuration easily available for anyone to take chunks of, or use
in it's entirety. I'll be keeping the lua codebase more or less clean, and idiomatic (although I don't have nowhere
near enough experience with lua to do that flawlessly, so I might make mistakes - Feel free to correct them in a PR!).

This means the code-base should be relatively easy to modify to fit your needs, if you so desire. I will also do my
best to make it at least somewhat readable and possible to edit by someone without much lua knowledge (though some
functions, especially those for the Language Server Protocol) can get pretty complex, because there's just no other way
around it.

## Separation from my dotfiles

Previously, this was a part of my [dotfiles](https://github.com/ItsDrike/dotfiles), however I decided to separate it
into it's own repository, because it slowly grew to become the most updated part of my dotfiles and an isolated
repository simply made more sense, because there were some people who came to my dotfiles just to see my neovim
configuration. I wanted to turn my configuration into something that's very easily usable with a readme that explains
how to do certain things using this configuration. But doing all this from within my dotfiles alone was very
inconvenient and that repository was really just meant to hold all of my system config, so I didn't want to clutter too
much of it's readme just explaining how the neovim configuration works. However to keep things consistent, there is
still a git submodule in my dotfiles repository linking back to this one.

Note: I've manually copied the git history affecting `home/.config/nvim` from my dotfiles repository to this one so
that there is still a stable record of what was done to my neovim configuration and when. This however doesn't include
my old vim configuration because it was in `home/.config/vim` or in `home/.vimrc` instead, so if you are interested in
that, you can still check the original commit history in my dotfiles repository.

## Attribution

The open-source community has an incredible amount of resources that people have offered to others free of charge and
we all depend on many of these sources. This project is no different and there were many open-source projects that were
utilized in some parts of this project. For that reason, I'd like to thank all of these projects and their contributors
for keeping their content open and available to everyone. This is the list of projects that helped me build this
repository to the stage it's in now. Many of the aliases, config files and other resources aren't my original
creations, but rather just small improvements and adjustments to get everything set in the way I like. Below is the
list of all projects which helped the existence of this repository:

- [Lukesmith's dotfiles/voidrice](https://github.com/LukeSmithxyz/voidrice)
- [Jess Archer's dotfiles](https://github.com/jessarcher/dotfiles)
- [lspsaga nvim plugin](https://github.com/glepnir/lspsaga.nvim)
- [CosmicVim](https://github.com/CosmicNvim/CosmicNvim)
- [LunarVim](https://github.com/LunarVim/LunarVim) (heavy inspiration)
- [LazyVim](https://github.com/LazyVim/LazyVim) (heavy inspiration)
- [Lewis6991's dotfiles](https://github.com/lewis6991/dotfiles)
