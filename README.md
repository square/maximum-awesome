# Maximum Awesome

Config files for vim and tmux, lovingly tended by a small subculture of
peace-loving hippies. Built for Mac OS X.

## What's in it?

* [MacVim](https://github.com/macvim-dev/macvim) (independent or for use in a terminal)
* [iTerm 2](http://www.iterm2.com/)
* [tmux](http://tmux.github.io/)
* Awesome syntax highlighting with the [Solarized color scheme](http://ethanschoonover.com/solarized)
* Want to know more? [Fly Vim, First Class](https://corner.squareup.com/2013/08/fly-vim-first-class.html)

### vim

* `,d` brings up [NERDTree](https://github.com/scrooloose/nerdtree), a sidebar buffer for navigating and manipulating files
* `,t` brings up [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim), a project file filter for easily opening specific files
* `,b` restricts ctrlp.vim to open buffers
* `,a` starts project search with [ag.vim](https://github.com/rking/ag.vim) using [the silver searcher](https://github.com/ggreer/the_silver_searcher) (like ack, but faster)
* `ds`/`cs` delete/change surrounding characters (e.g. `"Hey!"` + `ds"` = `Hey!`, `"Hey!"` + `cs"'` = `'Hey!'`) with [vim-surround](https://github.com/tpope/vim-surround)
* `gcc` toggles current line comment
* `gc` toggles visual selection comment lines
* `vii`/`vai` visually select *in* or *around* the cursor's indent
* `Vp`/`vp` replaces visual selection with default register *without* yanking selected text (works with any visual selection)
* `,[space]` strips trailing whitespace
* `<C-]>` jump to definition using ctags
* `,l` begins aligning lines on a string, usually used as `,l=` to align assignments
* `<C-hjkl>` move between windows, shorthand for `<C-w> hjkl`

### tmux

* `<C-a>` is the prefix
* mouse scroll initiates tmux scroll
* `prefix v` makes a vertical split
* `prefix s` makes a horizontal split

If you have three or more panes:
* `prefix +` opens up the main-horizontal-layout
* `prefix =` opens up the main-vertical-layout

You can adjust the size of the smaller panes in `tmux.conf` by lowering or increasing the `other-pane-height` and `other-pane-width` options.

## Install

    rake

## Update

    rake

This will update all installed plugins using Vundle's `:PluginInstall!`
command. Any errors encountered during this process may be resolved by clearing
out the problematic directories in ~/.vim/bundle. `:help PluginInstall`
provides more detailed information about Vundle.

## Customize
In your home directory, Maximum Awesome creates `.vimrc.local`, `.vimrc.bundles.local` and `.tmux.conf.local` files where you can customize
Vim and tmux to your heart’s content. However, we’d love to incorporate your changes and improve Vim and tmux
for everyone, so feel free to fork Maximum Awesome and open some pull requests!

## Uninstall

    rake uninstall

Note that this won't remove everything, but your vim configuration should be reset to whatever it was before installing. Some uninstallation steps will be manual.

## Contribute

Before creating your pull request, consider whether the feature you want to add
is something that you think *every* user of maximum-awesome should have. Is it
support for a very common language people would ordinarily use vim to write? Is
it a useful utility that does not change many defaults and composes well with
other parts of maximum-awesome? If so then perhaps it would be a good fit. If
not, perhaps keep it in your `*.local` files. This does not apply to bug fixes.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Any contributors to the master maximum-awesome repository must sign the
[Individual Contributor License Agreement (CLA)][cla].  It's a short form that
covers our bases and makes sure you're eligible to contribute.

[cla]: https://spreadsheets.google.com/spreadsheet/viewform?formkey=dDViT2xzUHAwRkI3X3k5Z0lQM091OGc6MQ&ndplr=1

When you have a change you'd like to see in the master repository, [send a pull
request](https://github.com/square/maximum-awesome/pulls). Before we merge your
request, we'll make sure you're in the list of people who have signed a CLA.

## Acknowledgements

Thanks to the vimsters at Square who put this together. Thanks to Tim Pope for
his awesome vim plugins.
