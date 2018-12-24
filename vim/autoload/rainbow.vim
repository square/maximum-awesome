if exists('s:loaded') | finish | endif | let s:loaded = 1

fun s:resolve_parenthesis(p)
	let ls = split(a:p, '\v%(%(start|step|end)\=(.)%(\1@!.)*\1[^ ]*|\w+%(\=[^ ]*)?) ?\zs', 0)
	let [paren, containedin, contains, op] = ['', '', 'TOP', '']
	for s in ls
		let [k, v] = [matchstr(s, '^[^=]\+\ze='), matchstr(s, '^[^=]\+=\zs.*')]
		if k == 'step'
			let op = v
		elseif k == 'contains'
			let contains = v
		elseif k == 'containedin'
			let containedin = v
		else
			let paren .= s
		endif
	endfor
	return [paren, containedin, contains, op]
endfun

fun rainbow#syn(config)
	let conf = a:config
	let prefix = conf.syn_name_prefix
	let maxlvl = has('gui_running')? len(conf.guifgs) : len(conf.ctermfgs)
	for i in range(len(conf.parentheses))
		let p = conf.parentheses[i]
		if type(p) == type([])
			let op = len(p)==3? p[1] : has_key(conf, 'operators')? conf.operators : ''
			let conf.parentheses[i] = op != ''? printf('start=#%s# step=%s end=#%s#', p[0], op, p[-1]) : printf('start=#%s# end=#%s#', p[0], p[-1])
		endif
	endfor
	let def_rg = 'syn region %s matchgroup=%s containedin=%s contains=%s %s'
	let def_op = 'syn match %s %s containedin=%s contained'

	let b:rainbow_loaded = maxlvl
	for parenthesis_args in conf.parentheses
		let [paren, containedin, contains, op] = s:resolve_parenthesis(parenthesis_args)
		if op == '' |let op = conf.operators |endif
		for lvl in range(maxlvl)
			if op != '' |exe printf(def_op, prefix.'_o'.lvl, op, prefix.'_r'.lvl) |endif
			if lvl == 0
				if containedin == ''
					exe printf(def_rg, prefix.'_r0', prefix.'_p0', prefix.'_r'.(maxlvl - 1), contains, paren)
				endif
			else
				exe printf(def_rg, prefix.'_r'.lvl, prefix.'_p'.lvl.(' contained'), prefix.'_r'.((lvl + maxlvl - 1) % maxlvl), contains, paren)
			endif
		endfor
		if containedin != ''
			exe printf(def_rg, prefix.'_r0', prefix.'_p0 contained', containedin.','.prefix.'_r'.(maxlvl - 1), contains, paren)
		endif
	endfor
	exe 'syn cluster '.prefix.'Regions contains='.join(map(range(maxlvl), '"'.prefix.'_r".v:val'),',')
	exe 'syn cluster '.prefix.'Parentheses contains='.join(map(range(maxlvl), '"'.prefix.'_p".v:val'),',')
	exe 'syn cluster '.prefix.'Operators contains='.join(map(range(maxlvl), '"'.prefix.'_o".v:val'),',')
	if has_key(conf, 'after') | for cmd in conf.after | exe cmd | endfor | endif
endfun

fun rainbow#syn_clear(config)
	let conf = a:config
	let prefix = conf.syn_name_prefix
	let maxlvl = has('gui_running')? len(conf.guifgs) : len(conf.ctermfgs)

	for id in range(maxlvl)
		exe 'syn clear '.prefix.'_r'.id
		exe 'syn clear '.prefix.'_o'.id
	endfor
endfun

fun rainbow#hi(config)
	let conf = a:config
	let prefix = conf.syn_name_prefix
	let maxlvl = has('gui_running')? len(conf.guifgs) : len(conf.ctermfgs)

	for id in range(maxlvl)
		let ctermfg = conf.ctermfgs[id % len(conf.ctermfgs)]
		let guifg = conf.guifgs[id % len(conf.guifgs)]
		exe 'hi '.prefix.'_p'.id.' ctermfg='.ctermfg.' guifg='.guifg
		exe 'hi '.prefix.'_o'.id.' ctermfg='.ctermfg.' guifg='.guifg
	endfor
endfun

fun rainbow#hi_clear(config)
	let conf = a:config
	let prefix = conf.syn_name_prefix
	let maxlvl = has('gui_running')? len(conf.guifgs) : len(conf.ctermfgs)

	for id in range(maxlvl)
		exe 'hi clear '.prefix.'_p'.id
		exe 'hi clear '.prefix.'_o'.id
	endfor
endfun

