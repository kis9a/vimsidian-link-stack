function! vimsidian#link_stack#command#show() abort
  call vimsidian#link_stack#show()
endfunction

function! vimsidian#link_stack#command#win_new() abort
  call vimsidian#link_stack#win_new()
endfunction

function! vimsidian#link_stack#command#move_to_previous_entry() abort
  let entry = vimsidian#link_stack#previous_entry()
  if type(entry) ==# type(v:null)
    call s:info('No previous entry in link stack')
    return
  endif

  if vimsidian#link_stack#type_check_item(entry) ==# v:null
    call s:info('Invalid type entry ' . entry)
    return
  endif

  call s:openFile(g:vimsidian_link_stack_open_mode, entry['path'])
  call cursor(entry['line'], entry['col'])
endfunction

function! vimsidian#link_stack#command#move_to_next_entry() abort
  let entry = vimsidian#link_stack#next_entry()
  if type(entry) ==# type(v:null)
    call s:info('No next entry in link stack')
    return
  endif

  if vimsidian#link_stack#type_check_item(entry) ==# v:null
    call s:info('Invalid type entry ' . entry)
    return
  endif

  call s:openFile(g:vimsidian_link_stack_open_mode, entry['path'])
  call cursor(entry['line'], entry['col'])
endfunction

" This is executed from the MoveToLink command in vimsidian.
function! vimsidian#link_stack#command#move_to_link(file, line, col) abort
  call vimsidian#link_stack#push_cursor_link(a:line, a:col)
  call s:openFile(g:vimsidian_link_stack_open_mode, a:file)
endfunction

" utils
function! s:info(message) abort
    echom 'vimsidian_link_stack: ' . a:message
endfunction

function! s:openFile(opener, file) abort
  execute join([a:opener,  a:file], ' ')
endfunction
