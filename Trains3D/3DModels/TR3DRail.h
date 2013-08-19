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

#define RailTies_vertexcount 	240
#define RailTies_polygoncount 	120


float RailTies_vertex[RailTies_vertexcount][8]={
		{0.00000, 1.95000, 0.00000, 0.00000, 1.00000, -0.11793, 0.00979, -0.42429},
		{0.00000, 0.00000, 0.00000, 0.00000, 1.00000, -0.11793, 0.01646, -0.42429},
		{1.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.11793, 0.01646, -0.42429},
		{1.00000, 1.95000, 0.00000, 0.00000, 1.00000, 0.11793, 0.00979, -0.42429},
		{0.00000, 1.95000, 0.00000, 0.00000, -1.00000, 0.11793, 0.00979, -0.46461},
		{0.00000, 0.00000, 0.00000, 0.00000, -1.00000, 0.11793, 0.01646, -0.46461},
		{1.00000, 0.00000, 0.00000, 0.00000, -1.00000, -0.11793, 0.01646, -0.46461},
		{1.00000, 1.95000, 0.00000, 0.00000, -1.00000, -0.11793, 0.00979, -0.46461},
		{0.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, -0.46461},
		{0.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, -0.46461},
		{1.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, -0.42429},
		{1.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, -0.42429},
		{0.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, -0.42429},
		{0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, -0.42429},
		{1.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, -0.46461},
		{1.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, -0.46461},
		{0.00000, 1.95000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, -0.42429},
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, -0.46461},
		{1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, -0.46461},
		{1.00000, 1.95000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, -0.42429},
		{0.00000, 1.95000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, -0.46461},
		{0.00000, 0.00000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, -0.42429},
		{1.00000, 0.00000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, -0.42429},
		{1.00000, 1.95000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, -0.46461},
		{0.00000, 1.95000, 0.00000, 0.00000, 1.00000, -0.11793, 0.00979, -0.32754},
		{0.00000, 0.00000, 0.00000, 0.00000, 1.00000, -0.11793, 0.01646, -0.32754},
		{1.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.11793, 0.01646, -0.32754},
		{1.00000, 1.95000, 0.00000, 0.00000, 1.00000, 0.11793, 0.00979, -0.32754},
		{0.00000, 1.95000, 0.00000, 0.00000, -1.00000, 0.11793, 0.00979, -0.36785},
		{0.00000, 0.00000, 0.00000, 0.00000, -1.00000, 0.11793, 0.01646, -0.36785},
		{1.00000, 0.00000, 0.00000, 0.00000, -1.00000, -0.11793, 0.01646, -0.36785},
		{1.00000, 1.95000, 0.00000, 0.00000, -1.00000, -0.11793, 0.00979, -0.36785},
		{0.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, -0.36785},
		{0.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, -0.36785},
		{1.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, -0.32754},
		{1.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, -0.32754},
		{0.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, -0.32754},
		{0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, -0.32754},
		{1.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, -0.36785},
		{1.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, -0.36785},
		{0.00000, 1.95000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, -0.32754},
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, -0.36785},
		{1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, -0.36785},
		{1.00000, 1.95000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, -0.32754},
		{0.00000, 1.95000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, -0.36785},
		{0.00000, 0.00000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, -0.32754},
		{1.00000, 0.00000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, -0.32754},
		{1.00000, 1.95000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, -0.36785},
		{0.00000, 1.95000, 0.00000, 0.00000, 1.00000, -0.11793, 0.00979, -0.23078},
		{0.00000, 0.00000, 0.00000, 0.00000, 1.00000, -0.11793, 0.01646, -0.23078},
		{1.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.11793, 0.01646, -0.23078},
		{1.00000, 1.95000, 0.00000, 0.00000, 1.00000, 0.11793, 0.00979, -0.23078},
		{0.00000, 1.95000, 0.00000, 0.00000, -1.00000, 0.11793, 0.00979, -0.27109},
		{0.00000, 0.00000, 0.00000, 0.00000, -1.00000, 0.11793, 0.01646, -0.27109},
		{1.00000, 0.00000, 0.00000, 0.00000, -1.00000, -0.11793, 0.01646, -0.27109},
		{1.00000, 1.95000, 0.00000, 0.00000, -1.00000, -0.11793, 0.00979, -0.27109},
		{0.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, -0.27109},
		{0.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, -0.27109},
		{1.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, -0.23078},
		{1.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, -0.23078},
		{0.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, -0.23078},
		{0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, -0.23078},
		{1.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, -0.27109},
		{1.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, -0.27109},
		{0.00000, 1.95000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, -0.23078},
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, -0.27109},
		{1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, -0.27109},
		{1.00000, 1.95000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, -0.23078},
		{0.00000, 1.95000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, -0.27109},
		{0.00000, 0.00000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, -0.23078},
		{1.00000, 0.00000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, -0.23078},
		{1.00000, 1.95000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, -0.27109},
		{0.00000, 1.95000, 0.00000, 0.00000, 1.00000, -0.11793, 0.00979, -0.13402},
		{0.00000, 0.00000, 0.00000, 0.00000, 1.00000, -0.11793, 0.01646, -0.13402},
		{1.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.11793, 0.01646, -0.13402},
		{1.00000, 1.95000, 0.00000, 0.00000, 1.00000, 0.11793, 0.00979, -0.13402},
		{0.00000, 1.95000, 0.00000, 0.00000, -1.00000, 0.11793, 0.00979, -0.17433},
		{0.00000, 0.00000, 0.00000, 0.00000, -1.00000, 0.11793, 0.01646, -0.17433},
		{1.00000, 0.00000, 0.00000, 0.00000, -1.00000, -0.11793, 0.01646, -0.17433},
		{1.00000, 1.95000, 0.00000, 0.00000, -1.00000, -0.11793, 0.00979, -0.17433},
		{0.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, -0.17433},
		{0.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, -0.17433},
		{1.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, -0.13402},
		{1.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, -0.13402},
		{0.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, -0.13402},
		{0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, -0.13402},
		{1.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, -0.17433},
		{1.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, -0.17433},
		{0.00000, 1.95000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, -0.13402},
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, -0.17433},
		{1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, -0.17433},
		{1.00000, 1.95000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, -0.13402},
		{0.00000, 1.95000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, -0.17433},
		{0.00000, 0.00000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, -0.13402},
		{1.00000, 0.00000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, -0.13402},
		{1.00000, 1.95000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, -0.17433},
		{0.00000, 1.95000, 0.00000, 0.00000, 1.00000, -0.11793, 0.00979, -0.03726},
		{0.00000, 0.00000, 0.00000, 0.00000, 1.00000, -0.11793, 0.01646, -0.03726},
		{1.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.11793, 0.01646, -0.03726},
		{1.00000, 1.95000, 0.00000, 0.00000, 1.00000, 0.11793, 0.00979, -0.03726},
		{0.00000, 1.95000, 0.00000, 0.00000, -1.00000, 0.11793, 0.00979, -0.07758},
		{0.00000, 0.00000, 0.00000, 0.00000, -1.00000, 0.11793, 0.01646, -0.07758},
		{1.00000, 0.00000, 0.00000, 0.00000, -1.00000, -0.11793, 0.01646, -0.07758},
		{1.00000, 1.95000, 0.00000, 0.00000, -1.00000, -0.11793, 0.00979, -0.07758},
		{0.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, -0.07758},
		{0.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, -0.07758},
		{1.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, -0.03726},
		{1.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, -0.03726},
		{0.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, -0.03726},
		{0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, -0.03726},
		{1.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, -0.07758},
		{1.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, -0.07758},
		{0.00000, 1.95000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, -0.03726},
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, -0.07758},
		{1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, -0.07758},
		{1.00000, 1.95000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, -0.03726},
		{0.00000, 1.95000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, -0.07758},
		{0.00000, 0.00000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, -0.03726},
		{1.00000, 0.00000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, -0.03726},
		{1.00000, 1.95000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, -0.07758},
		{0.00000, 1.95000, 0.00000, 0.00000, 1.00000, -0.11793, 0.00979, 0.05950},
		{0.00000, 0.00000, 0.00000, 0.00000, 1.00000, -0.11793, 0.01646, 0.05950},
		{1.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.11793, 0.01646, 0.05950},
		{1.00000, 1.95000, 0.00000, 0.00000, 1.00000, 0.11793, 0.00979, 0.05950},
		{0.00000, 1.95000, 0.00000, 0.00000, -1.00000, 0.11793, 0.00979, 0.01918},
		{0.00000, 0.00000, 0.00000, 0.00000, -1.00000, 0.11793, 0.01646, 0.01918},
		{1.00000, 0.00000, 0.00000, 0.00000, -1.00000, -0.11793, 0.01646, 0.01918},
		{1.00000, 1.95000, 0.00000, 0.00000, -1.00000, -0.11793, 0.00979, 0.01918},
		{0.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, 0.01918},
		{0.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, 0.01918},
		{1.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, 0.05950},
		{1.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, 0.05950},
		{0.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, 0.05950},
		{0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, 0.05950},
		{1.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, 0.01918},
		{1.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, 0.01918},
		{0.00000, 1.95000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, 0.05950},
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, 0.01918},
		{1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, 0.01918},
		{1.00000, 1.95000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, 0.05950},
		{0.00000, 1.95000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, 0.01918},
		{0.00000, 0.00000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, 0.05950},
		{1.00000, 0.00000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, 0.05950},
		{1.00000, 1.95000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, 0.01918},
		{0.00000, 1.95000, 0.00000, 0.00000, 1.00000, -0.11793, 0.00979, 0.15626},
		{0.00000, 0.00000, 0.00000, 0.00000, 1.00000, -0.11793, 0.01646, 0.15626},
		{1.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.11793, 0.01646, 0.15626},
		{1.00000, 1.95000, 0.00000, 0.00000, 1.00000, 0.11793, 0.00979, 0.15626},
		{0.00000, 1.95000, 0.00000, 0.00000, -1.00000, 0.11793, 0.00979, 0.11594},
		{0.00000, 0.00000, 0.00000, 0.00000, -1.00000, 0.11793, 0.01646, 0.11594},
		{1.00000, 0.00000, 0.00000, 0.00000, -1.00000, -0.11793, 0.01646, 0.11594},
		{1.00000, 1.95000, 0.00000, 0.00000, -1.00000, -0.11793, 0.00979, 0.11594},
		{0.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, 0.11594},
		{0.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, 0.11594},
		{1.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, 0.15626},
		{1.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, 0.15626},
		{0.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, 0.15626},
		{0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, 0.15626},
		{1.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, 0.11594},
		{1.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, 0.11594},
		{0.00000, 1.95000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, 0.15626},
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, 0.11594},
		{1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, 0.11594},
		{1.00000, 1.95000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, 0.15626},
		{0.00000, 1.95000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, 0.11594},
		{0.00000, 0.00000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, 0.15626},
		{1.00000, 0.00000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, 0.15626},
		{1.00000, 1.95000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, 0.11594},
		{0.00000, 1.95000, 0.00000, 0.00000, 1.00000, -0.11793, 0.00979, 0.25302},
		{0.00000, 0.00000, 0.00000, 0.00000, 1.00000, -0.11793, 0.01646, 0.25302},
		{1.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.11793, 0.01646, 0.25302},
		{1.00000, 1.95000, 0.00000, 0.00000, 1.00000, 0.11793, 0.00979, 0.25302},
		{0.00000, 1.95000, 0.00000, 0.00000, -1.00000, 0.11793, 0.00979, 0.21270},
		{0.00000, 0.00000, 0.00000, 0.00000, -1.00000, 0.11793, 0.01646, 0.21270},
		{1.00000, 0.00000, 0.00000, 0.00000, -1.00000, -0.11793, 0.01646, 0.21270},
		{1.00000, 1.95000, 0.00000, 0.00000, -1.00000, -0.11793, 0.00979, 0.21270},
		{0.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, 0.21270},
		{0.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, 0.21270},
		{1.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, 0.25302},
		{1.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, 0.25302},
		{0.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, 0.25302},
		{0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, 0.25302},
		{1.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, 0.21270},
		{1.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, 0.21270},
		{0.00000, 1.95000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, 0.25302},
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, 0.21270},
		{1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, 0.21270},
		{1.00000, 1.95000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, 0.25302},
		{0.00000, 1.95000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, 0.21270},
		{0.00000, 0.00000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, 0.25302},
		{1.00000, 0.00000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, 0.25302},
		{1.00000, 1.95000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, 0.21270},
		{0.00000, 1.95000, 0.00000, 0.00000, 1.00000, -0.11793, 0.00979, 0.34977},
		{0.00000, 0.00000, 0.00000, 0.00000, 1.00000, -0.11793, 0.01646, 0.34977},
		{1.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.11793, 0.01646, 0.34977},
		{1.00000, 1.95000, 0.00000, 0.00000, 1.00000, 0.11793, 0.00979, 0.34977},
		{0.00000, 1.95000, 0.00000, 0.00000, -1.00000, 0.11793, 0.00979, 0.30946},
		{0.00000, 0.00000, 0.00000, 0.00000, -1.00000, 0.11793, 0.01646, 0.30946},
		{1.00000, 0.00000, 0.00000, 0.00000, -1.00000, -0.11793, 0.01646, 0.30946},
		{1.00000, 1.95000, 0.00000, 0.00000, -1.00000, -0.11793, 0.00979, 0.30946},
		{0.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, 0.30946},
		{0.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, 0.30946},
		{1.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, 0.34977},
		{1.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, 0.34977},
		{0.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, 0.34977},
		{0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, 0.34977},
		{1.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, 0.30946},
		{1.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, 0.30946},
		{0.00000, 1.95000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, 0.34977},
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, 0.30946},
		{1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, 0.30946},
		{1.00000, 1.95000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, 0.34977},
		{0.00000, 1.95000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, 0.30946},
		{0.00000, 0.00000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, 0.34977},
		{1.00000, 0.00000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, 0.34977},
		{1.00000, 1.95000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, 0.30946},
		{0.00000, 1.95000, 0.00000, 0.00000, 1.00000, -0.11793, 0.00979, 0.44653},
		{0.00000, 0.00000, 0.00000, 0.00000, 1.00000, -0.11793, 0.01646, 0.44653},
		{1.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.11793, 0.01646, 0.44653},
		{1.00000, 1.95000, 0.00000, 0.00000, 1.00000, 0.11793, 0.00979, 0.44653},
		{0.00000, 1.95000, 0.00000, 0.00000, -1.00000, 0.11793, 0.00979, 0.40622},
		{0.00000, 0.00000, 0.00000, 0.00000, -1.00000, 0.11793, 0.01646, 0.40622},
		{1.00000, 0.00000, 0.00000, 0.00000, -1.00000, -0.11793, 0.01646, 0.40622},
		{1.00000, 1.95000, 0.00000, 0.00000, -1.00000, -0.11793, 0.00979, 0.40622},
		{0.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, 0.40622},
		{0.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, 0.40622},
		{1.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.11793, 0.01646, 0.44653},
		{1.00000, 1.95000, -1.00000, 0.00000, 0.00000, -0.11793, 0.00979, 0.44653},
		{0.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, 0.44653},
		{0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, 0.44653},
		{1.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.11793, 0.01646, 0.40622},
		{1.00000, 1.95000, 1.00000, 0.00000, 0.00000, 0.11793, 0.00979, 0.40622},
		{0.00000, 1.95000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, 0.44653},
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.11793, 0.01646, 0.40622},
		{1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, 0.40622},
		{1.00000, 1.95000, 0.00000, 1.00000, 0.00000, 0.11793, 0.01646, 0.44653},
		{0.00000, 1.95000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, 0.40622},
		{0.00000, 0.00000, 0.00000, -1.00000, 0.00000, -0.11793, 0.00979, 0.44653},
		{1.00000, 0.00000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, 0.44653},
		{1.00000, 1.95000, 0.00000, -1.00000, 0.00000, 0.11793, 0.00979, 0.40622},
		};


int RailTies_index[RailTies_polygoncount][3]={
		{0, 1, 2},
		{2, 3, 0},
		{4, 5, 6},
		{6, 7, 4},
		{8, 9, 10},
		{10, 11, 8},
		{12, 13, 14},
		{14, 15, 12},
		{16, 17, 18},
		{18, 19, 16},
		{20, 21, 22},
		{22, 23, 20},
		{24, 25, 26},
		{26, 27, 24},
		{28, 29, 30},
		{30, 31, 28},
		{32, 33, 34},
		{34, 35, 32},
		{36, 37, 38},
		{38, 39, 36},
		{40, 41, 42},
		{42, 43, 40},
		{44, 45, 46},
		{46, 47, 44},
		{48, 49, 50},
		{50, 51, 48},
		{52, 53, 54},
		{54, 55, 52},
		{56, 57, 58},
		{58, 59, 56},
		{60, 61, 62},
		{62, 63, 60},
		{64, 65, 66},
		{66, 67, 64},
		{68, 69, 70},
		{70, 71, 68},
		{72, 73, 74},
		{74, 75, 72},
		{76, 77, 78},
		{78, 79, 76},
		{80, 81, 82},
		{82, 83, 80},
		{84, 85, 86},
		{86, 87, 84},
		{88, 89, 90},
		{90, 91, 88},
		{92, 93, 94},
		{94, 95, 92},
		{96, 97, 98},
		{98, 99, 96},
		{100, 101, 102},
		{102, 103, 100},
		{104, 105, 106},
		{106, 107, 104},
		{108, 109, 110},
		{110, 111, 108},
		{112, 113, 114},
		{114, 115, 112},
		{116, 117, 118},
		{118, 119, 116},
		{120, 121, 122},
		{122, 123, 120},
		{124, 125, 126},
		{126, 127, 124},
		{128, 129, 130},
		{130, 131, 128},
		{132, 133, 134},
		{134, 135, 132},
		{136, 137, 138},
		{138, 139, 136},
		{140, 141, 142},
		{142, 143, 140},
		{144, 145, 146},
		{146, 147, 144},
		{148, 149, 150},
		{150, 151, 148},
		{152, 153, 154},
		{154, 155, 152},
		{156, 157, 158},
		{158, 159, 156},
		{160, 161, 162},
		{162, 163, 160},
		{164, 165, 166},
		{166, 167, 164},
		{168, 169, 170},
		{170, 171, 168},
		{172, 173, 174},
		{174, 175, 172},
		{176, 177, 178},
		{178, 179, 176},
		{180, 181, 182},
		{182, 183, 180},
		{184, 185, 186},
		{186, 187, 184},
		{188, 189, 190},
		{190, 191, 188},
		{192, 193, 194},
		{194, 195, 192},
		{196, 197, 198},
		{198, 199, 196},
		{200, 201, 202},
		{202, 203, 200},
		{204, 205, 206},
		{206, 207, 204},
		{208, 209, 210},
		{210, 211, 208},
		{212, 213, 214},
		{214, 215, 212},
		{216, 217, 218},
		{218, 219, 216},
		{220, 221, 222},
		{222, 223, 220},
		{224, 225, 226},
		{226, 227, 224},
		{228, 229, 230},
		{230, 231, 228},
		{232, 233, 234},
		{234, 235, 232},
		{236, 237, 238},
		{238, 239, 236},
		};


#define RailGravel_vertexcount 	24
#define RailGravel_polygoncount 	12


float RailGravel_vertex[RailGravel_vertexcount][8]={
		{0.00000, 1.00000, 0.00000, 0.00000, 1.00000, -0.15000, 0.00000, 0.50000},
		{0.00000, 0.00000, 0.00000, 0.00000, 1.00000, -0.15000, 0.01000, 0.50000},
		{0.50000, 0.00000, 0.00000, 0.00000, 1.00000, 0.15000, 0.01000, 0.50000},
		{0.50000, 1.00000, 0.00000, 0.00000, 1.00000, 0.15000, 0.00000, 0.50000},
		{0.00000, 1.00000, 0.00000, 0.00000, -1.00000, 0.15000, 0.00000, -0.50000},
		{0.00000, 0.00000, 0.00000, 0.00000, -1.00000, 0.15000, 0.01000, -0.50000},
		{0.50000, 0.00000, 0.00000, 0.00000, -1.00000, -0.15000, 0.01000, -0.50000},
		{0.50000, 1.00000, 0.00000, 0.00000, -1.00000, -0.15000, 0.00000, -0.50000},
		{0.00000, 1.00000, -1.00000, 0.00000, 0.00000, -0.15000, 0.00000, -0.50000},
		{0.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.15000, 0.01000, -0.50000},
		{0.50000, 0.00000, -1.00000, 0.00000, 0.00000, -0.15000, 0.01000, 0.50000},
		{0.50000, 1.00000, -1.00000, 0.00000, 0.00000, -0.15000, 0.00000, 0.50000},
		{0.00000, 1.00000, 1.00000, 0.00000, 0.00000, 0.15000, 0.00000, 0.50000},
		{0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.15000, 0.01000, 0.50000},
		{0.50000, 0.00000, 1.00000, 0.00000, 0.00000, 0.15000, 0.01000, -0.50000},
		{0.50000, 1.00000, 1.00000, 0.00000, 0.00000, 0.15000, 0.00000, -0.50000},
		{0.00000, 1.00000, 0.00000, 1.00000, 0.00000, -0.15000, 0.01000, 0.50000},
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.15000, 0.01000, -0.50000},
		{0.50000, 0.00000, 0.00000, 1.00000, 0.00000, 0.15000, 0.01000, -0.50000},
		{0.50000, 1.00000, 0.00000, 1.00000, 0.00000, 0.15000, 0.01000, 0.50000},
		{0.00000, 1.00000, 0.00000, -1.00000, 0.00000, -0.15000, 0.00000, -0.50000},
		{0.00000, 0.00000, 0.00000, -1.00000, 0.00000, -0.15000, 0.00000, 0.50000},
		{0.50000, 0.00000, 0.00000, -1.00000, 0.00000, 0.15000, 0.00000, 0.50000},
		{0.50000, 1.00000, 0.00000, -1.00000, 0.00000, 0.15000, 0.00000, -0.50000},
		};


int RailGravel_index[RailGravel_polygoncount][3]={
		{0, 1, 2},
		{2, 3, 0},
		{4, 5, 6},
		{6, 7, 4},
		{8, 9, 10},
		{10, 11, 8},
		{12, 13, 14},
		{14, 15, 12},
		{16, 17, 18},
		{18, 19, 16},
		{20, 21, 22},
		{22, 23, 20},
		};


#define Rails_vertexcount 	48
#define Rails_polygoncount 	24


float Rails_vertex[Rails_vertexcount][8]={
		{0.00000, 1.00000, 0.00000, 0.00000, 1.00000, -0.07152, 0.01640, 0.50000},
		{0.00000, 0.00000, 0.00000, 0.00000, 1.00000, -0.07152, 0.04050, 0.50000},
		{10.00000, 0.00000, 0.00000, 0.00000, 1.00000, -0.05764, 0.04050, 0.50000},
		{10.00000, 1.00000, 0.00000, 0.00000, 1.00000, -0.05764, 0.01640, 0.50000},
		{0.00000, 1.00000, 0.00000, 0.00000, -1.00000, -0.05764, 0.01640, -0.50000},
		{0.00000, 0.00000, 0.00000, 0.00000, -1.00000, -0.05764, 0.04050, -0.50000},
		{10.00000, 0.00000, 0.00000, 0.00000, -1.00000, -0.07152, 0.04050, -0.50000},
		{10.00000, 1.00000, 0.00000, 0.00000, -1.00000, -0.07152, 0.01640, -0.50000},
		{0.00000, 1.00000, -1.00000, 0.00000, 0.00000, -0.07152, 0.01640, -0.50000},
		{0.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.07152, 0.04050, -0.50000},
		{10.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.07152, 0.04050, 0.50000},
		{10.00000, 1.00000, -1.00000, 0.00000, 0.00000, -0.07152, 0.01640, 0.50000},
		{0.00000, 1.00000, 1.00000, 0.00000, 0.00000, -0.05764, 0.01640, 0.50000},
		{0.00000, 0.00000, 1.00000, 0.00000, 0.00000, -0.05764, 0.04050, 0.50000},
		{10.00000, 0.00000, 1.00000, 0.00000, 0.00000, -0.05764, 0.04050, -0.50000},
		{10.00000, 1.00000, 1.00000, 0.00000, 0.00000, -0.05764, 0.01640, -0.50000},
		{0.00000, 1.00000, 0.00000, 1.00000, 0.00000, -0.07152, 0.04050, 0.50000},
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.07152, 0.04050, -0.50000},
		{10.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.05764, 0.04050, -0.50000},
		{10.00000, 1.00000, 0.00000, 1.00000, 0.00000, -0.05764, 0.04050, 0.50000},
		{0.00000, 1.00000, 0.00000, -1.00000, 0.00000, -0.07152, 0.01640, -0.50000},
		{0.00000, 0.00000, 0.00000, -1.00000, 0.00000, -0.07152, 0.01640, 0.50000},
		{10.00000, 0.00000, 0.00000, -1.00000, 0.00000, -0.05764, 0.01640, 0.50000},
		{10.00000, 1.00000, 0.00000, -1.00000, 0.00000, -0.05764, 0.01640, -0.50000},
		{10.00000, 1.00000, 0.00000, 0.00000, 1.00000, 0.05764, 0.01640, 0.50000},
		{10.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.05764, 0.04050, 0.50000},
		{0.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.07152, 0.04050, 0.50000},
		{0.00000, 1.00000, 0.00000, 0.00000, 1.00000, 0.07152, 0.01640, 0.50000},
		{10.00000, 1.00000, 0.00000, 0.00000, -1.00000, 0.07152, 0.01640, -0.50000},
		{10.00000, 0.00000, 0.00000, 0.00000, -1.00000, 0.07152, 0.04050, -0.50000},
		{0.00000, 0.00000, 0.00000, 0.00000, -1.00000, 0.05764, 0.04050, -0.50000},
		{0.00000, 1.00000, 0.00000, 0.00000, -1.00000, 0.05764, 0.01640, -0.50000},
		{10.00000, 1.00000, 1.00000, 0.00000, 0.00000, 0.07152, 0.01640, 0.50000},
		{10.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.07152, 0.04050, 0.50000},
		{0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.07152, 0.04050, -0.50000},
		{0.00000, 1.00000, 1.00000, 0.00000, 0.00000, 0.07152, 0.01640, -0.50000},
		{10.00000, 1.00000, -1.00000, 0.00000, 0.00000, 0.05764, 0.01640, -0.50000},
		{10.00000, 0.00000, -1.00000, 0.00000, 0.00000, 0.05764, 0.04050, -0.50000},
		{0.00000, 0.00000, -1.00000, 0.00000, 0.00000, 0.05764, 0.04050, 0.50000},
		{0.00000, 1.00000, -1.00000, 0.00000, 0.00000, 0.05764, 0.01640, 0.50000},
		{10.00000, 1.00000, 0.00000, 1.00000, 0.00000, 0.05764, 0.04050, 0.50000},
		{10.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.05764, 0.04050, -0.50000},
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.07152, 0.04050, -0.50000},
		{0.00000, 1.00000, 0.00000, 1.00000, 0.00000, 0.07152, 0.04050, 0.50000},
		{10.00000, 1.00000, 0.00000, -1.00000, 0.00000, 0.05764, 0.01640, -0.50000},
		{10.00000, 0.00000, 0.00000, -1.00000, 0.00000, 0.05764, 0.01640, 0.50000},
		{0.00000, 0.00000, 0.00000, -1.00000, 0.00000, 0.07152, 0.01640, 0.50000},
		{0.00000, 1.00000, 0.00000, -1.00000, 0.00000, 0.07152, 0.01640, -0.50000},
		};


int Rails_index[Rails_polygoncount][3]={
		{0, 1, 2},
		{2, 3, 0},
		{4, 5, 6},
		{6, 7, 4},
		{8, 9, 10},
		{10, 11, 8},
		{12, 13, 14},
		{14, 15, 12},
		{16, 17, 18},
		{18, 19, 16},
		{20, 21, 22},
		{22, 23, 20},
		{24, 25, 26},
		{26, 27, 24},
		{28, 29, 30},
		{30, 31, 28},
		{32, 33, 34},
		{34, 35, 32},
		{36, 37, 38},
		{38, 39, 36},
		{40, 41, 42},
		{42, 43, 40},
		{44, 45, 46},
		{46, 47, 44},
		};


