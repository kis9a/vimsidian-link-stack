if exists('g:loaded_vimsidian_link_stack_plugin') && g:loaded_vimsidian_link_stack_plugin
  finish
endif

if !empty($VIMSIDIAN_TEST_PATH)
  let g:vimsidian_path = $VIMSIDIAN_TEST_PATH
endif

if !exists('g:vimsidian_path')
  echoerr '[VIMSIDIAN] Required g:vimsidian_path variable'
  finish
endif

if !exists('g:vimsidian_enable_link_stack')
  let g:vimsidian_enable_link_stack = 1
endif

if !exists('g:vimsidian_link_stack_open_mode')
  let g:vimsidian_link_stack_open_mode = 'e!'
endif

command! VimsidianLinkStackShow call vimsidian#link_stack#command#show()
command! VimsidianLinkStackPrev call vimsidian#link_stack#command#move_to_previous_entry()
command! VimsidianLinkStackNext call vimsidian#link_stack#command#move_to_next_entry()
command! VimsidianLinkStackWinNew call vimsidian#link_stack#command#win_new()

let g:loaded_vimsidian_link_stack_plugin = 1
