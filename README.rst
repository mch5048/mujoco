.. inclusion-marker-do-not-remove

MuJoCo for Python!
==================

This is a simple python wrapper around the MuJoCo physics simulation. I wrote it when I couldn't fix the `GLEW initialization error <https://github.com/openai/mujoco-py/issues/44>`_ with `mujoco-py  <https://github.com/openai/mujoco-py>`_. Please note: this library is a partial replacement (not a supplement) to 
``mujoco-py``. It is does not have all of the features of ``mujoco-py`` but it is much simpler and easier to understand. If there are additional capabilities you want added, please feel free to 
`post an issue <https://github.com/lobachevzky/mujoco/issues/new>`_.

Installation
------------

Working on getting a ``pypi`` script working. In the mean time, install from source:

.. code-block:: bash

  pip install -e /path/to/cloned/directory

Usage
-----
Examples are located in the ``examples/`` directory.

If you want your code to use EGL (which is faster on linux GPUs), you must define the environment variable ``EGL=1``. Otherwise, the code defaults to GLFW. Note that when using EGL, you cannot render to the screen (you can still render offscreen).

Design
------
One of the main design decisions behind this implementation was to use the exact same libraries that Emo's original MuJoCo code uses in the provided Makefile. That way if my version doesn't work, you can bet that Emo's code doesn't work either. I think the reason why ``mujoco-py`` stopped working is that it tried to get fancy with the libraries and dynamically switch between EGL- and GLFW-friendly graphics libraries.

Documentation
-------------
Sadly, I haven't been able to load my docs to readthedocs.org yet, because of difficulties over importing mujoco headers (suggestions welcome). However, if you wish to build the docs yourself, the following commands should do it for you:

.. code-block:: bash

  cd /path/to/cloned/directory
  make
  cd docs/
  make html
