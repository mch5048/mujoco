include "../pxd/lib.pxd"

cdef class Sim(object):
    cdef mjData * data
    cdef mjModel * model
    cdef State state
    cdef int forward_called_this_step