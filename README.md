# vimsidian-link-stack

Keep a stack of link jump history in each window (w:vimsidian_link_stack).  
Provides jump and jumpback functionality to entries in the link stack.  
Like CTRL+t/CTRL+] for tags using ctags in vim. (:h tags)  

Details: <https://github.com/kis9a/vimsidian/pull/10>, <https://github.com/kis9a/vimsidian/issues/9>

* [GitHub - kis9a/vimsidian: Vim plugin for PKM like obsidian.md](https://github.com/kis9a/vimsidian)

## Installation

Use your favorite plugin manager.

- Example: [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'kis9a/vimsidian'
Plug 'kis9a/vimsidian-link-stack'
```

## Examples

written in `~/.vim/ftplugin/markdown.vim`

```vim
let g:vimsidian_enable_link_stack = 1

" Example mapping like ctags jump
nnoremap <buffer> <C-]> :VimsidianMoveToLink<CR>
nnoremap <buffer> <silent> <C-t> :VimsidianLinkStackPrev<CR>
nnoremap <buffer> <silent> sn :VimsidianLinkStackNext<CR>
nnoremap <buffer> <silent> ss :VimsidianLinkStackShow<CR>

let $VIMSIDIAN_PATH_PATTERN = g:vimsidian_path_main . '/*.md'
if g:vimsidian_enable_link_stack
  autocmd VimEnter,WinNew $VIMSIDIAN_PATH_PATTERN VimsidianLinkStackWinNew
endif

let $VIMSIDIAN_PATH_PATTERN = g:vimsidian_path_main . '/*.md'
if g:vimsidian_enable_link_stack
  autocmd VimEnter,WinNew $VIMSIDIAN_PATH_PATTERN VimsidianLinkStackWinNew
endif
```

## Developments

<details close>
<summary>If you contribute to this repository, please use the following tools for linting and testing</summary>
<br/>

### Linting

Use [vim-parser](https://github.com/ynkdir/vim-vimlparser), [vim-vimlint](https://github.com/syngan/vim-vimlint)

```
make init
make lint
```

When using [vint](https://github.com/Vimjas/vint)

```
make vint-int
make lint-vint
```

### Testing

Use [vim-themis](https://github.com/thinca/vim-themis/issues)

```
make init
make test
```

</details>


## LICENSE

[WTFPL license - Do What The F\*ck You Want To Public License](./LICENSE.md)
