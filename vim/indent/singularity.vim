" Singularity indent file

" Only load this script if no other indent script has been loaded
if exists("b:did_indent")
    finish
endif
let b:did_indent=1

" Configure other indent options
setlocal nocindent
setlocal nosmartindent
setlocal autoindent

" Declare function to determine indent level
setlocal indentexpr=GetSingularityIndent(v:lnum)

" Declare which keys trigger the indentation function
setlocal indentkeys=!^F,o,O,0%,<:>

" Indentation level function
" Returns the level of indentation as an integer
" -1 means to retain the current indentation level
function! GetSingularityIndent(lnum)
    let lnum = a:lnum

    " The first line is at indent level 0
    if lnum == 1
        return 0
    endif

    let this_line = getline(lnum)

    " Catch indentation triggered when typing %, for section headings set
    " indent to level 0
    if this_line =~ '^\s*%'
        return 0
    endif

    " Trigger indentation when typing :, if line matches a keyword set indent
    " to level 0
    if this_line =~ '^\s*\(bootstrap\|from\|includecmd\|mirrorurl\|updateurl\|osversion\|include\|library\|registry\|namespace\|stage\|product\|user\|regcode\|productpgp\|registerurl\|modules\|otherurln\|fingerprints\|confurl\|setopt\):\c'
        return 0
    endif


    " Search backwards for the section lnum belongs to
    let clnum = lnum - 1
    while clnum > 0
        let current_line = getline(clnum)

        " If parent section is one of
        " %setup,%files,%post,%test,%environment,%startscript,%runscript,%labels,%help
        " increase indent one step
        if current_line =~ '^%\(help\|setup\|files\|labels\|environment\|pre\|post\|runscript\|test\|startscript\|arguments\)'
            return indent(clnum) + &shiftwidth
        endif

        " If parent section is one of
        " %apprun *,%applabels *,%appinstall *,%appenv *,%apphelp *,%appfiles *
        " increase indent one step
        if current_line =~ '^%\(appinstall\|applabels\|appfiles\|appenv\|apptest\|apphelp\|apprun\|appstart\)\s*[a-zA-Z]*'
            return indent(clnum) + &shiftwidth
        endif

        let clnum = clnum - 1
    endwhile

    " Otherwise return same indent level
    return -1
endfunction
