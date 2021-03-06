include "mujoco/sim.pyx"

import numpy as np
from cython cimport view
from codecs import encode
from pxd.lib cimport setCamera
from pxd.renderGlfw cimport GraphicsState, initOpenGL, closeOpenGL, \
        renderOnscreen, addLabel, clearLastKey, clearMouseDy, clearMouseDx

cdef class SimGlfw(BaseSim):
    """ 
    Sim that uses GLFW functionality, which supports both offscreen and onscreen rendering.
    """
    cdef GraphicsState graphics_state

    def init_opengl(self):
        """ Initialize GLFW. """
        initOpenGL(&self.graphics_state, &self.state)

    def close_opengl(self):
        """ Does nothing, because glfwTerminate has a bug. """
        closeOpenGL()

    def render(self, str camera_name=None, dict labels=None):
        """
        Display the view from camera corresponding to ``camera_name`` in an onscreen GLFW window. 
        ``labels`` must be a dict of ``{label: pos}``, where ``label`` is a value that can be 
        cast to a ``str`` and ``pos`` is a ``list``, ``tuple``, or ``ndarray`` with elements
        corresponding to ``(x, y, z)``.
        """
        cdef float[::view.contiguous] view

        if camera_name is None:
            camid = -1
        else:
            camid = self.get_id(ObjType.CAMERA, camera_name)
        setCamera(camid, &self.state)

        if labels:
            assert isinstance(labels, dict), \
                    '`labels` must be a dict not a {}.'.format(type(labels))
            for label, pos in labels.items():
                if type(pos) in (list, tuple):
                    pos = np.array(pos)
                assert pos.shape == (3,), \
                        'shape of `pos` must be (3,) not {}.'.format(pos.shape)
                view = pos.astype(np.float32)
                addLabel(encode(str(label)), &view[0], &self.state)

        return renderOnscreen(&self.graphics_state)

    def get_last_key_press(self):
        if self.graphics_state.lastKeyPress:
            key = chr(self.graphics_state.lastKeyPress)
            clearLastKey(&self.graphics_state)
            return key

    def get_mouse_dx(self):
        mouse_dx = self.graphics_state.mouseDx
        clearMouseDx(&self.graphics_state)
        return mouse_dx

    def get_mouse_dy(self):
        mouse_dy = self.graphics_state.mouseDy
        clearMouseDy(&self.graphics_state)
        return mouse_dy
