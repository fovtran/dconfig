cat dynamic_debug/control |grep therm|grep target

# From a live system:                                                                                                                                                                                                                     │

nullarbor:~ # cat <debugfs>/dynamic_debug/control                                                                                                                                                                                 │
# filename:lineno [module]function flags format                                                                                                                                                                                   │
fs/aio.c:222 [aio]__put_ioctx =_ "__put_ioctx:\040freeing\040%p\012"                                                                                                                                                              │
fs/aio.c:248 [aio]ioctx_alloc =_ "ENOMEM:\040nr_events\040too\040high\012"                                                                                                                                                        │
fs/aio.c:1770 [aio]sys_io_cancel =_ "calling\040cancel\012"                                                                                                                                                                       │

# Example usage:                                                                                                                                                                                                                          │

# enable the message at line 1603 of file svcsock.c                                                                                                                                                                              │
nullarbor:~ # echo -n 'file svcsock.c line 1603 +p' > <debugfs>/dynamic_debug/control                                                                                                                                                                   │
# enable all the messages in file svcsock.c                                                                                                                                                                                      │
nullarbor:~ # echo -n 'file svcsock.c +p' > <debugfs>/dynamic_debug/control                                                                                                                                                                   │
# enable all the messages in the NFS server module                                                                                                                                                                               │
nullarbor:~ # echo -n 'module nfsd +p' > <debugfs>/dynamic_debug/control                                                                                                                                                                   │
# enable all 12 messages in the function svc_process()                                                                                                                                                                           │
nullarbor:~ # echo -n 'func svc_process +p' > <debugfs>/dynamic_debug/control                                                                                                                                                                   │
# disable all 12 messages in the function svc_process()                                                                                                                                                                          │
nullarbor:~ # echo -n 'func svc_process -p' > debugfs>/dynamic_debug/control  

