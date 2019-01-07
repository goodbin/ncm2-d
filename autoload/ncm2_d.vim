if exists("")
  finish
endif
let s:ncm2_d = 1

let g:ncm2_d#dcd_client_bin = get(g:, 'ncm2_d#dcd_client_bin', 'dcd-client')
let g:ncm2_d#dcd_client_args = get(g:, 'ncm2_d#dcd_client_args', [''])
let g:ncm2_d#dcd_server_bin = get(g:, 'ncm2_d#dcd_server_bin', 'dcd-server')
let g:ncm2_d#dcd_server_args = get(g:, 'ncm2_d#dcd_server_args', [''])
let g:ncm2_d#dcd_autostart_server = get(g:, 'ncm2#dcd_autostart_server', 1)

let g:ncm2_d#proc = yarp#py3('ncm2_d')

if g:ncm2_d#dcd_autostart_server == 1
  let g:ncm2_d_dcd#proc = yarp#py3('ncm2_d_dcd')
endif

let g:ncm2_d#source = extend(
      \ get(g:, 'ncm2_d#source', {}), {
      \ 'name': 'd',
      \ 'priority': 9,
      \ 'mark': 'd',
      \ 'early_cache': 1,
      \ 'subscope_enable': 1,
      \ 'scope': ['d'],
      \ 'word_pattern': '\w+',
      \ 'complete_pattern': ['\.'],
      \ 'complete_length': 1,
      \ 'on_complete': 'ncm2_d#on_complete',
      \ 'on_warmup': 'ncm2_d#on_warmup',
      \ }, 'keep')


func! ncm2_d#init()
  call ncm2#register_source(g:ncm2_d#source)
endfunc

func! ncm2_d#on_warmup(ctx)
  call g:ncm2_d#proc.jobstart()
  call g:ncm2_d_dcd#proc.jobstart()
endfunc

func! ncm2_d#on_complete(ctx)
  call g:ncm2_d#proc.try_notify('on_complete',
        \ a:ctx,
        \ ncm2_d#data(),
        \ getline(1, '$'))
endfunc

func! ncm2_d#error(msg)
  call g:ncm2_d#proc.error(a:msg)
endfunc

func! ncm2_d#data()
  return {
        \ 'dcd_client_bin': g:ncm2_d#dcd_client_bin,
        \ 'dcd_client_args': g:ncm2_d#dcd_client_args,
        \ 'dcd_server_bin': g:ncm2_d#dcd_server_bin,
        \ 'dcd_server_args': g:ncm2_d#dcd_server_args,
        \ }
endfunc

