let s:suite = themis#suite('vimsidian')
let s:assert = themis#helper('assert')

if empty($VIMSIDIAN_TEST_PATH)
  let g:vimsidian_path = $VIMSIDIAN_TEST_PATH
  echoerr '$VIMSIDIAN_TEST_PATH is empty'
endif

if empty(glob($VIMSIDIAN_TEST_PATH))
  echoerr '$VIMSIDIAN_TEST_PATH: ' . $VIMSIDIAN_TEST_PATH . ' is does not exists'
endif

function! s:edit_A() abort
  execute 'e ' . $VIMSIDIAN_TEST_PATH . '/A.md'
endfunction

function! s:edit_B() abort
  execute 'e ' . $VIMSIDIAN_TEST_PATH . '/sub/B.md'
endfunction

function! s:suite.link_stack_push() abort
  call s:assert.equal(vimsidian#link_stack#push('string'), v:null)

  let w:vimsidian_link_stack = []
  let s:v1 = {'path': 'path', 'line': 3, 'col': 5}
  let s:v2 = {'path': 'pathhh', 'line': 1, 'col': 2}
  call s:assert.equal(vimsidian#link_stack#push(s:v1), [s:v1])
  call s:assert.equal(vimsidian#link_stack#push(s:v1), [s:v1])
  call s:assert.equal(vimsidian#link_stack#push(s:v1), w:vimsidian_link_stack)
  call s:assert.equal(vimsidian#link_stack#push(s:v2), [s:v1, s:v2])
  call s:assert.equal(vimsidian#link_stack#push(s:v1), [s:v1, s:v2, s:v1])
endfunction

function! s:suite.local_window_variable_scoped() abort
  call s:edit_A()
  let w:vimsidian_foo = ['A']
  let Atabpagenr = tabpagenr()
  let Awinid = win_getid()

  execute 'tab split'
  if !exists('w:vimsidian_foo')
    let w:vimsidian_foo = 'NOT EXISTS'
  endif

  call s:assert.equal(w:vimsidian_foo, 'NOT EXISTS')

  execute 'tab split'
  let w:vimsidian_foo = ['B']
  call settabwinvar(tabpagenr(), win_getid(), 'vimsidian_foo', ['C'])
  call s:assert.equal(w:vimsidian_foo, ['C'])
  call s:assert.equal(gettabwinvar(Atabpagenr, Awinid, 'vimsidian_foo'), ['A'])

  call add(w:vimsidian_foo, 'D')
  call s:assert.equal(w:vimsidian_foo, ['C', 'D'])
  call s:assert.equal(gettabwinvar(Atabpagenr, Awinid, 'vimsidian_foo'), ['A'])
endfunction

" function! s:suite.link_stack_winnew() abort
"   call s:edit_A()
"   let Atabpagenr = tabpagenr()
"   let Awinid = win_getid()
"   let s:v1 = {'path': 'path', 'line': 3, 'col': 5}
"   let w:vimsidian_link_stack = [s:v1]

"   execute 'tab split'
"   let A1tabpagenr = win_getid()
"   let A1winid = win_getid()
"   call s:assert.not_equal(Awinid, A1winid)
"   call s:assert.not_equal(Atabpagenr, A1tabpagenr)

"   call cursor(3, 1)
"   let [line, col] = vimsidian#unit#CursorLinkPosition()
"   let v = { 'path': expand('%:p'), 'line': line, 'col': col }
"   call vimsidian#link_stack#push(v)
"   call s:assert.equal(w:vimsidian_link_stack, [s:v1, v])

"   call s:assert.equal(gettabwinvar(Atabpagenr, Awinid, 'vimsidian_link_stack'), [s:v1])
" endfunction

function! s:suite.link_top_curidx() abort
  let w:vimsidian_link_stack = []
  call vimsidian#link_stack#top_curidx()
  call s:assert.equal(w:vimsidian_link_stack_curidx, -1)

  let s:v1 = {'path': 'path', 'line': 3, 'col': 5}
  let w:vimsidian_link_stack = [s:v1]

  call vimsidian#link_stack#top_curidx()
  call s:assert.equal(w:vimsidian_link_stack_curidx, 0)

  let w:vimsidian_link_stack = [s:v1, s:v1, s:v1, s:v1]
  call vimsidian#link_stack#top_curidx()
  call s:assert.equal(w:vimsidian_link_stack_curidx, 3)
endfunction

function! s:suite.link_stack_pop_to_curidx() abort
  let s:v1 = {'path': 'path', 'line': 3, 'col': 5}
  let w:vimsidian_link_stack = [s:v1, s:v1, s:v1]
  let w:vimsidian_link_stack_curidx = 1

  call vimsidian#link_stack#pop_to_curidx()
  call s:assert.equal(w:vimsidian_link_stack, [s:v1, s:v1])

  let w:vimsidian_link_stack_curidx = 0
  call vimsidian#link_stack#pop_to_curidx()
  call s:assert.equal(w:vimsidian_link_stack, [s:v1])
endfunction

function! s:suite.link_stack_previous_entry() abort
  let s:v0 = {'path': 'path', 'line': 0, 'col': 0}
  let s:v1 = {'path': 'path', 'line': 1, 'col': 1}
  let s:v2 = {'path': 'path', 'line': 2, 'col': 2}

  let w:vimsidian_link_stack = []
  let w:vimsidian_link_stack_curidx = -1
  call s:assert.equal(vimsidian#link_stack#previous_entry(), v:null)

  let w:vimsidian_link_stack = [s:v0]
  let w:vimsidian_link_stack_curidx = 0
  call s:assert.equal(vimsidian#link_stack#previous_entry(), s:v0)

  let w:vimsidian_link_stack = [s:v0]
  let w:vimsidian_link_stack_curidx = 0
  call s:assert.equal(vimsidian#link_stack#previous_entry(), s:v0)

  let w:vimsidian_link_stack_curidx = -1
  call s:assert.equal(vimsidian#link_stack#previous_entry(), v:null)

  let w:vimsidian_link_stack = [s:v0, s:v1]
  let w:vimsidian_link_stack_curidx = 1
  call s:assert.equal(vimsidian#link_stack#previous_entry(), s:v1)

  let w:vimsidian_link_stack = [s:v0, s:v1, s:v2]
  let w:vimsidian_link_stack_curidx = 2
  call s:assert.equal(vimsidian#link_stack#previous_entry(), s:v2)

  let w:vimsidian_link_stack_curidx = 1
  call s:assert.equal(vimsidian#link_stack#previous_entry(), s:v1)

  let w:vimsidian_link_stack_curidx = 0
  call s:assert.equal(vimsidian#link_stack#previous_entry(), s:v0)

  let w:vimsidian_link_stack_curidx = -1
  call s:assert.equal(vimsidian#link_stack#previous_entry(), v:null)
endfunction

function! s:suite.link_stack_next_entry() abort
  let s:v0 = {'path': 'path', 'line': 0, 'col': 0}
  let s:v1 = {'path': 'path', 'line': 1, 'col': 1}
  let s:v2 = {'path': 'path', 'line': 2, 'col': 2}

  let w:vimsidian_link_stack = []
  let w:vimsidian_link_stack_curidx = -1
  call s:assert.equal(vimsidian#link_stack#next_entry(), v:null)

  let w:vimsidian_link_stack = [s:v0]
  let w:vimsidian_link_stack_curidx = -1
  call s:assert.equal(vimsidian#link_stack#next_entry(), s:v0)

  let w:vimsidian_link_stack_curidx = 0
  call s:assert.equal(vimsidian#link_stack#next_entry(), v:null)

  let w:vimsidian_link_stack = [s:v0, s:v1]
  let w:vimsidian_link_stack_curidx = -1
  call s:assert.equal(vimsidian#link_stack#next_entry(), s:v0)

  let w:vimsidian_link_stack_curidx = 0
  call s:assert.equal(vimsidian#link_stack#next_entry(), s:v1)

  let w:vimsidian_link_stack_curidx = 1
  call s:assert.equal(vimsidian#link_stack#next_entry(), v:null)

  let w:vimsidian_link_stack = [s:v0, s:v1, s:v2]
  let w:vimsidian_link_stack_curidx = -1
  call s:assert.equal(vimsidian#link_stack#next_entry(), s:v0)

  let w:vimsidian_link_stack_curidx = 0
  call s:assert.equal(vimsidian#link_stack#next_entry(), s:v1)

  let w:vimsidian_link_stack_curidx = 1
  call s:assert.equal(vimsidian#link_stack#next_entry(), s:v2)

  let w:vimsidian_link_stack_curidx = 2
  call s:assert.equal(vimsidian#link_stack#next_entry(), v:null)
endfunction
