"=============================================================================
" FILE: helpers.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! vimshell#helpers#get_editor_name() "{{{
  if !exists('g:vimshell_editor_command')
    " Set editor command.
    let g:vimshell_editor_command = g:vimshell_cat_command

    if has('clientserver') && (has('gui_running') || has('gui'))
      if has('gui_macvim')
        " MacVim check.
        if executable('/Applications/MacVim.app/Contents/MacOS/Vim')
          let progname = 'Applications/MacVim.app/Contents/MacOS/Vim'
        elseif executable(expand('~/Applications/MacVim.app/Contents/MacOS/Vim'))
          let progname = expand('~/Applications/MacVim.app/Contents/MacOS/Vim')
        else
          echoerr 'You installed MacVim in not default directory!'.
                \ ' You must set g:vimshell_editor_command manually.'
          return g:vimshell_cat_command
        endif

        let progname = '/Applications/MacVim.app/Contents/MacOS/Vim'
      else
        let progname = has('gui_running') ? v:progname : 'vim'
      endif

      let progname .= ' -g'

      let g:vimshell_editor_command = printf('%s %s --remote-tab-wait-silent',
            \ progname, (v:servername == '' ? '' : ' --servername='.v:servername))
    endif
  endif

  return g:vimshell_editor_command
endfunction"}}}
function! vimshell#helpers#execute_internal_command(command, args, context) "{{{
  if empty(a:context)
    let context = { 'has_head_spaces' : 0, 'is_interactive' : 1 }
  else
    let context = a:context
  endif

  if !has_key(context, 'fd') || empty(context.fd)
    let context.fd = { 'stdin' : '', 'stdout' : '', 'stderr' : '' }
  endif

  let internal = vimshell#init#_internal_commands(a:command)
  if empty(internal)
    call vimshell#error_line(context.fd,
          \ printf('Internal command : "%s" is not found.', a:command))
    return
  elseif internal.kind ==# 'execute'
    " Convert args.
    let args = type(get(a:args, 0, '')) == type('') ?
          \ [{ 'args' : a:args, 'fd' : context.fd}] : a:args
    return internal.execute(args, context)
  else
    return internal.execute(a:args, context)
  endif
endfunction"}}}
function! vimshell#helpers#imdisable() "{{{
  " Disable input method.
  if exists('g:loaded_eskk') && eskk#is_enabled()
    call eskk#disable()
  elseif exists('b:skk_on') && b:skk_on && exists('*SkkDisable')
    call SkkDisable()
  elseif exists('&iminsert')
    let &l:iminsert = 0
  endif
endfunction"}}}
function! vimshell#helpers#get_current_args(...) "{{{
  let cur_text = a:0 == 0 ? vimshell#get_cur_text() : a:1

  let statements = vimproc#parser#split_statements(cur_text)
  if empty(statements)
    return []
  endif

  let commands = vimproc#parser#split_commands(statements[-1])
  if empty(commands)
    return []
  endif

  let args = vimproc#parser#split_args_through(commands[-1])
  if vimshell#get_cur_text() =~ '\\\@!\s\+$'
    " Add blank argument.
    call add(args, '')
  endif

  return args
endfunction"}}}
function! vimshell#helpers#split(command) "{{{
  let old_pos = [ tabpagenr(), winnr(), bufnr('%'), getpos('.') ]
  if a:command != ''
    let command =
          \ a:command !=# 'nicely' ? a:command :
          \ winwidth(0) > 2 * &winwidth ? 'vsplit' : 'split'
    execute command
  endif

  let new_pos = [ tabpagenr(), winnr(), bufnr('%'), getpos('.') ]

  return [new_pos, old_pos]
endfunction"}}}
function! vimshell#helpers#restore_pos(pos) "{{{
  if tabpagenr() != a:pos[0]
    execute 'tabnext' a:pos[0]
  endif

  if winnr() != a:pos[1]
    execute a:pos[1].'wincmd w'
  endif

  if bufnr('%') !=# a:pos[2]
    execute 'buffer' a:pos[2]
  endif

  call setpos('.', a:pos[3])
endfunction"}}}
function! vimshell#helpers#execute(cmdline, ...) "{{{
  if !empty(b:vimshell.continuation)
    " Kill process.
    call vimshell#interactive#hang_up(bufname('%'))
  endif

  let context = a:0 >= 1? a:1 : vimshell#get_context()
  let context.is_interactive = 0
  try
    call vimshell#parser#eval_script(a:cmdline, context)
  catch
    if v:exception !~# '^Vim:Interrupt'
      let message = v:exception . ' ' . v:throwpoint
      call vimshell#error_line(context.fd, message)
    endif
    return 1
  endtry

  return b:vimshell.system_variables.status
endfunction"}}}
function! vimshell#helpers#execute_async(cmdline, ...) "{{{
  if !empty(b:vimshell.continuation)
    " Kill process.
    call vimshell#interactive#hang_up(bufname('%'))
  endif

  let context = a:0 >= 1 ? a:1 : vimshell#get_context()
  let context.is_interactive = 1
  try
    return vimshell#parser#eval_script(a:cmdline, context)
  catch
    if v:exception !~# '^Vim:Interrupt'
      let message = v:exception . ' ' . v:throwpoint
      call vimshell#error_line(context.fd, message)
    endif

    let context = vimshell#get_context()
    let b:vimshell.continuation = {}
    call vimshell#print_prompt(context)
    call vimshell#start_insert(mode() ==# 'i')
    return 1
  endtry
endfunction"}}}
function! vimshell#helpers#get_command_path(program) "{{{
  " Command search.
  try
    return vimproc#get_command_name(a:program)
  catch /File ".*" is not found./
    " Not found.
    return ''
  endtry
endfunction"}}}

function! vimshell#helpers#set_alias(name, value) "{{{
  if !exists('b:vimshell')
    let b:vimshell = {}
  endif
  if !has_key(b:vimshell, 'alias_table')
    let b:vimshell.alias_table = {}
  endif

  if a:value == ''
    " Delete alias.
    call remove(b:vimshell.alias_table, a:name)
  else
    let b:vimshell.alias_table[a:name] = a:value
  endif
endfunction"}}}
function! vimshell#helpers#get_alias(name) "{{{
  return get(b:vimshell.alias_table, a:name, '')
endfunction"}}}
function! vimshell#helpers#set_galias(name, value) "{{{
  if !exists('b:vimshell')
    let b:vimshell = {}
  endif
  if !has_key(b:vimshell, 'galias_table')
    let b:vimshell.galias_table = {}
  endif

  if a:value == ''
    " Delete alias.
    call remove(b:vimshell.galias_table, a:name)
  else
    let b:vimshell.galias_table[a:name] = a:value
  endif
endfunction"}}}
function! vimshell#helpers#get_galias(name) "{{{
  return get(b:vimshell.galias_table, a:name, '')
endfunction"}}}

function! vimshell#helpers#get_program_pattern() "{{{
  return
        \'^\s*\%([^[:blank:]]\|\\[^[:alnum:]._-]\)\+\ze\%(\s*\%(=\s*\)\?\)'
endfunction"}}}
function! vimshell#helpers#get_alias_pattern() "{{{
  return '^\s*[[:alnum:].+#_@!%:-]\+'
endfunction"}}}

function! vimshell#helpers#complete(arglead, cmdline, cursorpos) "{{{
  let _ = []

  " Option names completion.
  try
    let _ += filter(vimshell#variables#options(),
          \ 'stridx(v:val, a:arglead) == 0')
  catch
  endtry

  " Directory name completion.
  let _ += filter(map(split(glob(a:arglead . '*'), '\n'),
        \ "isdirectory(v:val) ? v:val.'/' : v:val"),
        \ 'stridx(v:val, a:arglead) == 0')

  return sort(_)
endfunction"}}}
function! vimshell#helpers#vimshell_execute_complete(arglead, cmdline, cursorpos) "{{{
  " Get complete words.
  let cmdline = a:cmdline[len(matchstr(
        \ a:cmdline, vimshell#helpers#get_program_pattern())):]

  let args = vimproc#parser#split_args_through(cmdline)
  if empty(args) || cmdline =~ '\\\@!\s\+$'
    " Add blank argument.
    call add(args, '')
  endif

  return map(vimshell#complete#helper#command_args(args), 'v:val.word')
endfunction"}}}

function! vimshell#helpers#check_cursor_is_end() "{{{
  return vimshell#get_cur_line() ==# getline('.')
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
