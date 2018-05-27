# Using the wavefront-obj gem

This gem is a very simple and small wrapper around the wavefront obj file format, which is a human
readable format to store 3d objects. In it's simplest form, the obj file contains objects, vertices and
faces.

For example, this is a simple obj file (taken from [Stefan's Blog post](http://stefankracht.de/news/creating-3d-models-with-ruby)) defining a cube:

```obj
o my awesome cube
v 1 -1 -1
v 1 -1 1
v -1 -1 1
v -1 -1 -1
v 1 1 -1
v -1 1 -1
v -1 1 1
v 1 1 1
f 1 2 3 4
f 5 6 7 8
f 1 5 8 2
f 2 8 7 3
f 3 7 6 4
f 5 1 4 6
```

The vertices are points in the 3d space (x, y, z coodinates) and the faces simply reference them by their implicit index (1 based)

All I have done for this demo is take the simple cube example from Stefan's post and recreated the things I did in the SketchUp example. 
