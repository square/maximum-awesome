let s:rainbow_conf = {
\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\	'operators': '_,_',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\	'separately': {
\		'*': {},
\		'lisp': {
\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\		},
\		'haskell': {
\			'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/\v\{\ze[^-]/ end=/}/ fold'],
\		},
\		'tex': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\		},
\		'vim': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\		},
\		'xml': {
\			'syn_name_prefix': 'xmlRainbow',
\			'parentheses': ['start=/\v\<\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'))?)*\>/ end=#</\z1># fold'],
\		},
\		'xhtml': {
\			'parentheses': ['start=/\v\<\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'))?)*\>/ end=#</\z1># fold'],
\		},
\		'html': {
\			'parentheses': ['start=/\v\<((script|style|area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\		},
\		'perl': {
\			'syn_name_prefix': 'perlBlockFoldRainbow',
\		},
\		'php': {
\			'syn_name_prefix': 'phpBlockRainbow',
\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold', 'start=/(/ end=/)/ containedin=@htmlPreproc contains=@phpClTop', 'start=/\[/ end=/\]/ containedin=@htmlPreproc contains=@phpClTop', 'start=/{/ end=/}/ containedin=@htmlPreproc contains=@phpClTop'],
\		},
\		'stylus': {
\			'parentheses': ['start=/{/ end=/}/ fold contains=@colorableGroup'],
\		},
\		'css': 0,
\		'sh': 0,
\	}
\}

fun s:eq(x, y)
	return type(a:x) == type(a:y) && a:x == a:y
endfun

fun rainbow_main#gen_config(ft)
	let g = exists('g:rainbow_conf')? g:rainbow_conf : {}
	"echom 'g:rainbow_conf:' string(g)
	let s = get(g, 'separately', {})
	"echom 'g:rainbow_conf.separately:' string(s)
	let dft_conf = extend(copy(s:rainbow_conf), g) | unlet dft_conf.separately
	"echom 'default config options:' string(dft_conf)
	let dx_conf = s:rainbow_conf.separately['*']
	"echom 'default star config:' string(dx_conf)
	let ds_conf = get(s:rainbow_conf.separately, a:ft, dx_conf)
	"echom 'default separately config:' string(ds_conf)
	let ux_conf = get(s, '*', ds_conf)
	"echom 'user star config:' string(ux_conf)
	let us_conf = get(s, a:ft, ux_conf)
	"echom 'user separately config:' string(us_conf)
	let conf = (s:eq(us_conf, 'default') ? ds_conf : us_conf)
	"echom 'almost finally config:' string(conf)
	return s:eq(conf, 0) ? 0 : extend(extend({'syn_name_prefix': substitute(a:ft, '\v\A+(\a)', '\u\1', 'g').'Rainbow'}, dft_conf), conf)
endfun

fun rainbow_main#gen_configs(ft)
	return filter(map(split(a:ft, '\v\.'), 'rainbow_main#gen_config(v:val)'), 'type(v:val) == type({})')
endfun

fun rainbow_main#load()
	let b:rainbow_confs = rainbow_main#gen_configs(&ft)
	for conf in b:rainbow_confs
		call rainbow#syn(conf)
		call rainbow#hi(conf)
	endfor
endfun

fun rainbow_main#clear()
	if !exists('b:rainbow_confs') | return | endif
	for conf in b:rainbow_confs
		call rainbow#hi_clear(conf)
		call rainbow#syn_clear(conf)
	endfor
	unlet b:rainbow_confs
endfun

fun rainbow_main#toggle()
	if exists('b:rainbow_confs')
		call rainbow_main#clear()
	else
		call rainbow_main#load()
	endif
endfun

