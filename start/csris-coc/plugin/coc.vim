" Common CoC configuration for language buffers.

call coc#config('coc.preferences.formatOnSaveFiletypes', ['rust'])
call coc#config('rust-analyzer.check.command', 'clippy')
call coc#config('rust-analyzer.inlayHints.chainingHints.enable', v:false)
call coc#config('rust-analyzer.inlayHints.closureReturnTypeHints.enable', 'never')
call coc#config('rust-analyzer.inlayHints.parameterHints.enable', v:false)
call coc#config('rust-analyzer.inlayHints.typeHints.enable', v:false)
call coc#config('rust-analyzer.rustfmt.extraArgs', ['+nightly'])
call coc#config('suggest.autoTrigger', 'none')

function! s:setup_coc_buffer() abort
    " Check if CoC is loaded
    if !exists(':CocInfo')
        return
    endif

    " Use CoC as Vim's tag provider.
    setlocal tagfunc=CocTagFunc

    " Use K to show documentation.
    nnoremap <silent><buffer> K :call <SID>show_documentation()<CR>

    " Use <C-Space> to trigger completion.
    inoremap <silent><buffer><expr> <C-@> coc#refresh()

    " Use gy, gi, and gr to go to type definitions, impls, and references.
    nmap <silent><buffer> gy <Plug>(coc-type-definition)
    nmap <silent><buffer> gi <Plug>(coc-implementation)
    nmap <silent><buffer> gr <Plug>(coc-references)

    " Use [g and ]g to navigate diagnostic messages.
    nmap <silent><buffer> [g <Plug>(coc-diagnostic-prev)
    nmap <silent><buffer> ]g <Plug>(coc-diagnostic-next)

    " Use \rn to rename.
    nmap <silent><buffer> <leader>rn <Plug>(coc-rename)

    " Use \ca to invoke code actions.
    nmap <silent><buffer> <leader>ca <Plug>(coc-codeaction-cursor)
    xmap <silent><buffer> <leader>ca <Plug>(coc-codeaction-selected)

    " Support b:undo_ftplugin.
    let l:undo_coc = 'setlocal tagfunc<'
        \ . ' | silent! nunmap <buffer> K'
        \ . ' | silent! iunmap <buffer> <C-Space>'
        \ . ' | silent! nunmap <buffer> gy'
        \ . ' | silent! nunmap <buffer> gi'
        \ . ' | silent! nunmap <buffer> gr'
        \ . ' | silent! nunmap <buffer> [g'
        \ . ' | silent! nunmap <buffer> ]g'
        \ . ' | silent! nunmap <buffer> <leader>rn'
        \ . ' | silent! nunmap <buffer> <leader>ca'

    if exists('b:undo_ftplugin')
        let b:undo_ftplugin .= ' | ' . l:undo_coc
    else
        let b:undo_ftplugin = l:undo_coc
    endif
endfunction

function! s:show_documentation() abort
    if exists('*coc#rpc#ready') && coc#rpc#ready()
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . ' ' . shellescape(expand('<cword>'))
    endif
endfunction

augroup csris_coc
    autocmd!
    autocmd FileType rust,typescript,typescriptreact,javascript,javascriptreact
        \ call <SID>setup_coc_buffer()
augroup END
