// Headerfile *.h (generated by Cheetah3D)
//
// There are the following name conventions:
// 	NAME			=name of the object in Cheetah3D. Caution!! Avoid giving two objects the same name
// 	NAME_vertex		=float array which contains the vertex,normal and uvcoord data 
// 	NAME_index		=int array which contains the polygon index data
// 	NAME_vertexcount	=number of vertices
// 	NAME_polygoncount	=number of triangles
//
// The vertex data is saved in the following format:
// 	u0,v0,normalx0,normaly0,normalz0,x0,y0,z0
// 	u1,v1,normalx1,normaly1,normalz1,x1,y1,z1
// 	u2,v2,normalx2,normaly2,normalz2,x2,y2,z2
// 	...
// You can draw the mesh the following way:
// 	glEnableClientState(GL_INDEX_ARRAY);
// 	glEnableClientState(GL_NORMAL_ARRAY);
// 	glEnableClientState(GL_VERTEX_ARRAY);
// 	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
// 	glInterleavedArrays(GL_T2F_N3F_V3F,0,NAME_vertex);
// 	glDrawElements(GL_TRIANGLES,NAME_polygoncount*3,GL_UNSIGNED_INT,NAME_index);
//

#define Rail_vertexcount 	4
#define Rail_polygoncount 	2


static float Rail_vertex[Rail_vertexcount][8]={
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.10000, 0.00500, -0.50000},
		{1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.10000, 0.00500, -0.50000},
		{1.00000, 1.00000, 0.00000, 1.00000, 0.00000, 0.10000, 0.00500, 0.50000},
		{0.00000, 1.00000, 0.00000, 1.00000, 0.00000, -0.10000, 0.00500, 0.50000},
		};


static  int Rail_index[Rail_polygoncount][3]={
		{0, 1, 2},
		{2, 3, 0},
		};


