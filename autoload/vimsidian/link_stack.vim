let w:vimsidian_link_stack = [] " list of link stack items [{ 'path': path, 'line': line_number, 'col': column_number }]
let w:vimsidian_link_stack_curidx = 0 " current index of link stack
let s:vimsidian_link_stack_keys = ['path', 'line', 'col']

function! vimsidian#link_stack#win_new() abort
    let preWinnr = winnr('#')
    let preTabpagenr = tabpagenr('#')

    if preWinnr !=# 0
      let preTabpagenr = tabpagenr()
      let preWinId = win_getid(preWinnr, preTabpagenr)
    else
      let preWinId = win_getid(tabpagewinnr(preTabpagenr), preTabpagenr)
    endif

    let items = gettabwinvar(preTabpagenr, preWinId, 'vimsidian_link_stack')
    let curidx = gettabwinvar(preTabpagenr, preWinId, 'vimsidian_link_stack_curidx')

    if type(items) !=# type([]) || items ==# []
      call vimsidian#link_stack#empty()
    else
      let w:vimsidian_link_stack = items
    endif

    if type(curidx) !=# type(v:t_number) || type(curidx) !=# type(v:null)
      call vimsidian#link_stack#top_curidx()
    else
      let w:vimsidian_link_stack_curidx = curidx
    endif
endfunction

function! vimsidian#link_stack#push(linkStackItem) abort
  if vimsidian#link_stack#type_check_item(a:linkStackItem) ==# v:null
    return v:null
  endif

  if vimsidian#link_stack#is_exists() !=# v:true
    call vimsidian#link_stack#empty()
  endif

  if vimsidian#link_stack#is_existsCuridx() !=# v:true
    call vimsidian#link_stack#top_curidx()
  endif 

  let linkStackLastIndex = (len(w:vimsidian_link_stack) - 1)

  if linkStackLastIndex > w:vimsidian_link_stack_curidx
    call vimsidian#link_stack#pop_to_curidx()
  endif

  let newLinkStack = w:vimsidian_link_stack + [a:linkStackItem]

  if len(w:vimsidian_link_stack) > 0 && vimsidian#link_stack#equal_link_stack_item(w:vimsidian_link_stack[-1], a:linkStackItem)
      call vimsidian#link_stack#top_curidx()
      return w:vimsidian_link_stack
    else
      let w:vimsidian_link_stack = newLinkStack
      call vimsidian#link_stack#top_curidx()
      return w:vimsidian_link_stack
    endif
endfunction

function! vimsidian#link_stack#equal_link_stack_item(a, b) abort
  for k in s:vimsidian_link_stack_keys
    if a:a[k] !=# a:b[k]
      return v:null
    endif
  endfor

  return v:true
endfunction

function! vimsidian#link_stack#type_check_item(linkStackItem) abort
  if type(a:linkStackItem) !=# type({})
    return v:null
  endif

  for k in s:vimsidian_link_stack_keys
    if !has_key(a:linkStackItem, k)
      return v:null
    endif
  endfor

  return v:true
endfunction

function! vimsidian#link_stack#empty() abort
  let w:vimsidian_link_stack = []
endfunction

function! vimsidian#link_stack#pop_to_curidx() abort
  if w:vimsidian_link_stack_curidx ==# -1
    call vimsidian#link_stack#empty()
  else
    let w:vimsidian_link_stack = w:vimsidian_link_stack[0:w:vimsidian_link_stack_curidx]
  endif
endfunction

function! vimsidian#link_stack#top_curidx() abort
  let linkStackIdx = len(w:vimsidian_link_stack) - 1
  let w:vimsidian_link_stack_curidx = linkStackIdx
endfunction

function! vimsidian#link_stack#is_exists() abort
  if exists('w:vimsidian_link_stack')
    return v:true
  else
    return v:null
  endif
endfunction

function! vimsidian#link_stack#is_existsCuridx() abort
  if exists('w:vimsidian_link_stack_curidx')
    return v:true
  else
    return v:null
  endif
endfunction

function! vimsidian#link_stack#is_empty() abort
  if !exists('w:vimsidian_link_stack') || len(w:vimsidian_link_stack) ==# 0
    return v:true
  else
    return v:null
  endif
endfunction

function! vimsidian#link_stack#push_cursor_link(line, col) abort
  call vimsidian#link_stack#push({ 'path': expand('%:p'), 'line': a:line, 'col': a:col })
endfunction

function! vimsidian#link_stack#previous_entry() abort
  let linkStackIdx = len(w:vimsidian_link_stack) - 1
  if linkStackIdx ==# -1 || w:vimsidian_link_stack_curidx ==# -1
    return v:null
  endif

  let w:vimsidian_link_stack_curidx = (w:vimsidian_link_stack_curidx - 1)

  let c = { 'path': expand('%:p'), 'line': line('.'), 'col': col('.') }

  if linkStackIdx ==# (w:vimsidian_link_stack_curidx + 1)
    if w:vimsidian_link_stack[-1]['path'] !=# c['path']
      let w:vimsidian_link_stack = w:vimsidian_link_stack + [c]
    else
      let w:vimsidian_link_stack = w:vimsidian_link_stack[0:-2] + [c]
    endif
  endif

  let samePos = vimsidian#link_stack#equal_link_stack_item(w:vimsidian_link_stack[w:vimsidian_link_stack_curidx + 1], c)
  if samePos ==# v:true && w:vimsidian_link_stack_curidx > -1
    let w:vimsidian_link_stack_curidx = (w:vimsidian_link_stack_curidx - 1)
  endif

  return w:vimsidian_link_stack[w:vimsidian_link_stack_curidx + 1]
endfunction

function! vimsidian#link_stack#next_entry() abort
  let linkStackIdx = len(w:vimsidian_link_stack) - 1
  if linkStackIdx ==# -1 || (w:vimsidian_link_stack_curidx + 1) > linkStackIdx
    return v:null
  endif

  let w:vimsidian_link_stack_curidx = (w:vimsidian_link_stack_curidx + 1)

  let c = { 'path': expand('%:p'), 'line': line('.'), 'col': col('.') }
  let samePos = vimsidian#link_stack#equal_link_stack_item(w:vimsidian_link_stack[w:vimsidian_link_stack_curidx], c)

  if samePos ==# v:true && linkStackIdx >= w:vimsidian_link_stack_curidx + 1
    let w:vimsidian_link_stack_curidx = (w:vimsidian_link_stack_curidx + 1)
  endif

  return w:vimsidian_link_stack[w:vimsidian_link_stack_curidx]
endfunction

function! vimsidian#link_stack#show() abort
  echo '  LINE:COLUMN:PATH'
  let linkStackIdx = (len(w:vimsidian_link_stack) - 1)

  for i in range(0, linkStackIdx)
    let line = w:vimsidian_link_stack[i]['line'] . ':' . w:vimsidian_link_stack[i]['col'] . ':' . w:vimsidian_link_stack[i]['path']
    if i ==# (w:vimsidian_link_stack_curidx + 1)
      echo '> ' . line
    else
      echo '  ' . line
    endif
  endfor
  if vimsidian#link_stack#is_empty() ==# v:true || linkStackIdx == w:vimsidian_link_stack_curidx
    echo '> '
  endif
endfunction
