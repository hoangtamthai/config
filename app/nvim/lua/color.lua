vim.cmd [[
highlight clear
function s:highlight(group, bg, fg, style)
  let gui = a:style == '' ? '' : 'gui=' . a:style
  let fg = a:fg == '' ? '' : 'guifg=' . a:fg
  let bg = a:bg == '' ? '' : 'guibg=' . a:bg
  exec 'hi ' . a:group . ' ' . bg . ' ' . fg  . ' ' . gui
endfunction

let s:Color0 = '#D4D4D4'
let s:Color1 = '#DB6698'
let s:Color2 = '#E2C5D2'
let s:Color3 = '#9ECBA3'
let s:Color4 = '#e77f92'
let s:Color5 = '#CE9178'
let s:Color6 = '#b174cc'
let s:Color7 = '#280812'
let s:Color8 = '#ea95b1'
let s:Color9 = '#1a1117'
let s:Color10 = '#d4d4d4'
let s:Color11 = '#560f23'
let s:Color12 = '#333223'
let s:Color13 = '#470d12'
let s:Color14 = '#45222e'
let s:Color15 = '#858585'
let s:Color16 = '#8c888b'
let s:Color17 = '#130205'
let s:Color18 = '#ffffff'
let s:Color19 = '#777575'
let s:Color20 = '#45222e'
let s:Color21 = '#a56173'

call s:highlight('Operator', '', s:Color2, '')
call s:highlight('Keyword', '', s:Color1, '')
call s:highlight('Identifier', '', s:Color2, '')
call s:highlight('Function', '', s:Color3, '')
call s:highlight('Type', '', s:Color4, '')
call s:highlight('Conditional', '', s:Color1, '')
call s:highlight('Conceal', '0', s:Color21, '')
call s:highlight('Repeat', '', s:Color1, '')
call s:highlight('Type', '', s:Color1, '')
call s:highlight('String', '', s:Color5, '')
call s:highlight('Number', '', s:Color6, '')
call s:highlight('MatchParen', s:Color3, '', '')
call s:highlight('Constant', '', s:Color6, '')
call s:highlight('StatusLine', s:Color8, s:Color7, '')
call s:highlight('WildMenu', s:Color9, s:Color10, '')
call s:highlight('Pmenu', s:Color9, s:Color10, '')
call s:highlight('PmenuSel', s:Color10, s:Color11, '')
call s:highlight('PmenuThumb', s:Color9, s:Color10, '')
call s:highlight('DiffAdd', s:Color12, '', '')
call s:highlight('DiffDelete', s:Color13, '', '')
call s:highlight('Normal', s:Color9, s:Color2, '')
call s:highlight('Visual', s:Color14, '', '')
call s:highlight('Cursor', s:Color14, '', 'reverse')
call s:highlight('CursorLine', s:Color14, '', '')
call s:highlight('CursorLineNr', '', s:Color1, '')
call s:highlight('ColorColumn', s:Color14, '', '')
call s:highlight('SignColumn', s:Color9, '', '')
call s:highlight('LineNr', '', s:Color15, '')
call s:highlight('TabLine', s:Color17, s:Color16, '')
call s:highlight('TabLineSel', s:Color18, s:Color11, '')
call s:highlight('TabLineFill', s:Color17, s:Color16, '')
call s:highlight('TSPunctDelimiter', '', s:Color10, '')
call s:highlight('Statement', '', s:Color4, '')
call s:highlight('NonText', '', s:Color19, '')
call s:highlight('Directory', '', s:Color4, '')
call s:highlight('Comment', '', s:Color19, '')
call s:highlight('Search', s:Color20, s:Color2, '')
call s:highlight('SpecialKey', '', s:Color4, '')
call s:highlight('Special', '', s:Color1, '')
call s:highlight('Title', '', s:Color4, '')
call s:highlight('Include', '', s:Color4, '')
]]
