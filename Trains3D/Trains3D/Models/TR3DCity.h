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

#define City_vertexcount 	144
#define City_polygoncount 	72


float City_vertex[City_vertexcount][8]={
		{0.00000, 1.00000, 0.00000, 0.00000, 1.00000, -0.30000, 0.00000, -0.20357},
		{0.00000, 0.00000, 0.00000, 0.00000, 1.00000, -0.30000, 0.15000, -0.20357},
		{1.00000, 0.00000, 0.00000, 0.00000, 1.00000, -0.15000, 0.15000, -0.20357},
		{1.00000, 1.00000, 0.00000, 0.00000, 1.00000, -0.15000, 0.00000, -0.20357},
		{0.00000, 1.00000, 0.00000, 0.00000, -1.00000, -0.15000, 0.00000, -0.35357},
		{0.00000, 0.00000, 0.00000, 0.00000, -1.00000, -0.15000, 0.15000, -0.35357},
		{1.00000, 0.00000, 0.00000, 0.00000, -1.00000, -0.30000, 0.15000, -0.35357},
		{1.00000, 1.00000, 0.00000, 0.00000, -1.00000, -0.30000, 0.00000, -0.35357},
		{0.00000, 1.00000, -1.00000, 0.00000, 0.00000, -0.30000, 0.00000, -0.35357},
		{0.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.30000, 0.15000, -0.35357},
		{1.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.30000, 0.15000, -0.20357},
		{1.00000, 1.00000, -1.00000, 0.00000, 0.00000, -0.30000, 0.00000, -0.20357},
		{0.00000, 1.00000, 1.00000, 0.00000, 0.00000, -0.15000, 0.00000, -0.20357},
		{0.00000, 0.00000, 1.00000, 0.00000, 0.00000, -0.15000, 0.15000, -0.20357},
		{1.00000, 0.00000, 1.00000, 0.00000, 0.00000, -0.15000, 0.15000, -0.35357},
		{1.00000, 1.00000, 1.00000, 0.00000, 0.00000, -0.15000, 0.00000, -0.35357},
		{0.00000, 1.00000, 0.00000, 1.00000, 0.00000, -0.30000, 0.15000, -0.20357},
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.30000, 0.15000, -0.35357},
		{1.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.15000, 0.15000, -0.35357},
		{1.00000, 1.00000, 0.00000, 1.00000, 0.00000, -0.15000, 0.15000, -0.20357},
		{0.00000, 1.00000, 0.00000, -1.00000, 0.00000, -0.30000, 0.00000, -0.35357},
		{0.00000, 0.00000, 0.00000, -1.00000, 0.00000, -0.30000, 0.00000, -0.20357},
		{1.00000, 0.00000, 0.00000, -1.00000, 0.00000, -0.15000, 0.00000, -0.20357},
		{1.00000, 1.00000, 0.00000, -1.00000, 0.00000, -0.15000, 0.00000, -0.35357},
		{0.00000, 1.00000, 0.00000, 0.00000, 1.00000, -0.07500, 0.00000, -0.20357},
		{0.00000, 0.00000, 0.00000, 0.00000, 1.00000, -0.07500, 0.15000, -0.20357},
		{1.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.07500, 0.15000, -0.20357},
		{1.00000, 1.00000, 0.00000, 0.00000, 1.00000, 0.07500, 0.00000, -0.20357},
		{0.00000, 1.00000, 0.00000, 0.00000, -1.00000, 0.07500, 0.00000, -0.35357},
		{0.00000, 0.00000, 0.00000, 0.00000, -1.00000, 0.07500, 0.15000, -0.35357},
		{1.00000, 0.00000, 0.00000, 0.00000, -1.00000, -0.07500, 0.15000, -0.35357},
		{1.00000, 1.00000, 0.00000, 0.00000, -1.00000, -0.07500, 0.00000, -0.35357},
		{0.00000, 1.00000, -1.00000, 0.00000, 0.00000, -0.07500, 0.00000, -0.35357},
		{0.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.07500, 0.15000, -0.35357},
		{1.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.07500, 0.15000, -0.20357},
		{1.00000, 1.00000, -1.00000, 0.00000, 0.00000, -0.07500, 0.00000, -0.20357},
		{0.00000, 1.00000, 1.00000, 0.00000, 0.00000, 0.07500, 0.00000, -0.20357},
		{0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.07500, 0.15000, -0.20357},
		{1.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.07500, 0.15000, -0.35357},
		{1.00000, 1.00000, 1.00000, 0.00000, 0.00000, 0.07500, 0.00000, -0.35357},
		{0.00000, 1.00000, 0.00000, 1.00000, 0.00000, -0.07500, 0.15000, -0.20357},
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.07500, 0.15000, -0.35357},
		{1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.07500, 0.15000, -0.35357},
		{1.00000, 1.00000, 0.00000, 1.00000, 0.00000, 0.07500, 0.15000, -0.20357},
		{0.00000, 1.00000, 0.00000, -1.00000, 0.00000, -0.07500, 0.00000, -0.35357},
		{0.00000, 0.00000, 0.00000, -1.00000, 0.00000, -0.07500, 0.00000, -0.20357},
		{1.00000, 0.00000, 0.00000, -1.00000, 0.00000, 0.07500, 0.00000, -0.20357},
		{1.00000, 1.00000, 0.00000, -1.00000, 0.00000, 0.07500, 0.00000, -0.35357},
		{0.00000, 1.00000, 0.00000, 0.00000, 1.00000, 0.15000, 0.00000, -0.20357},
		{0.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.15000, 0.15000, -0.20357},
		{1.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.30000, 0.15000, -0.20357},
		{1.00000, 1.00000, 0.00000, 0.00000, 1.00000, 0.30000, 0.00000, -0.20357},
		{0.00000, 1.00000, 0.00000, 0.00000, -1.00000, 0.30000, 0.00000, -0.35357},
		{0.00000, 0.00000, 0.00000, 0.00000, -1.00000, 0.30000, 0.15000, -0.35357},
		{1.00000, 0.00000, 0.00000, 0.00000, -1.00000, 0.15000, 0.15000, -0.35357},
		{1.00000, 1.00000, 0.00000, 0.00000, -1.00000, 0.15000, 0.00000, -0.35357},
		{0.00000, 1.00000, -1.00000, 0.00000, 0.00000, 0.15000, 0.00000, -0.35357},
		{0.00000, 0.00000, -1.00000, 0.00000, 0.00000, 0.15000, 0.15000, -0.35357},
		{1.00000, 0.00000, -1.00000, 0.00000, 0.00000, 0.15000, 0.15000, -0.20357},
		{1.00000, 1.00000, -1.00000, 0.00000, 0.00000, 0.15000, 0.00000, -0.20357},
		{0.00000, 1.00000, 1.00000, 0.00000, 0.00000, 0.30000, 0.00000, -0.20357},
		{0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.30000, 0.15000, -0.20357},
		{1.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.30000, 0.15000, -0.35357},
		{1.00000, 1.00000, 1.00000, 0.00000, 0.00000, 0.30000, 0.00000, -0.35357},
		{0.00000, 1.00000, 0.00000, 1.00000, 0.00000, 0.15000, 0.15000, -0.20357},
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.15000, 0.15000, -0.35357},
		{1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.30000, 0.15000, -0.35357},
		{1.00000, 1.00000, 0.00000, 1.00000, 0.00000, 0.30000, 0.15000, -0.20357},
		{0.00000, 1.00000, 0.00000, -1.00000, 0.00000, 0.15000, 0.00000, -0.35357},
		{0.00000, 0.00000, 0.00000, -1.00000, 0.00000, 0.15000, 0.00000, -0.20357},
		{1.00000, 0.00000, 0.00000, -1.00000, 0.00000, 0.30000, 0.00000, -0.20357},
		{1.00000, 1.00000, 0.00000, -1.00000, 0.00000, 0.30000, 0.00000, -0.35357},
		{1.00000, 1.00000, 0.00000, 0.00000, -1.00000, -0.15000, 0.00000, 0.20357},
		{1.00000, 0.00000, 0.00000, 0.00000, -1.00000, -0.15000, 0.15000, 0.20357},
		{0.00000, 0.00000, 0.00000, 0.00000, -1.00000, -0.30000, 0.15000, 0.20357},
		{0.00000, 1.00000, 0.00000, 0.00000, -1.00000, -0.30000, 0.00000, 0.20357},
		{1.00000, 1.00000, 0.00000, 0.00000, 1.00000, -0.30000, 0.00000, 0.35357},
		{1.00000, 0.00000, 0.00000, 0.00000, 1.00000, -0.30000, 0.15000, 0.35357},
		{0.00000, 0.00000, 0.00000, 0.00000, 1.00000, -0.15000, 0.15000, 0.35357},
		{0.00000, 1.00000, 0.00000, 0.00000, 1.00000, -0.15000, 0.00000, 0.35357},
		{1.00000, 1.00000, -1.00000, 0.00000, 0.00000, -0.30000, 0.00000, 0.20357},
		{1.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.30000, 0.15000, 0.20357},
		{0.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.30000, 0.15000, 0.35357},
		{0.00000, 1.00000, -1.00000, 0.00000, 0.00000, -0.30000, 0.00000, 0.35357},
		{1.00000, 1.00000, 1.00000, 0.00000, 0.00000, -0.15000, 0.00000, 0.35357},
		{1.00000, 0.00000, 1.00000, 0.00000, 0.00000, -0.15000, 0.15000, 0.35357},
		{0.00000, 0.00000, 1.00000, 0.00000, 0.00000, -0.15000, 0.15000, 0.20357},
		{0.00000, 1.00000, 1.00000, 0.00000, 0.00000, -0.15000, 0.00000, 0.20357},
		{1.00000, 1.00000, 0.00000, 1.00000, 0.00000, -0.15000, 0.15000, 0.20357},
		{1.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.15000, 0.15000, 0.35357},
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.30000, 0.15000, 0.35357},
		{0.00000, 1.00000, 0.00000, 1.00000, 0.00000, -0.30000, 0.15000, 0.20357},
		{1.00000, 1.00000, 0.00000, -1.00000, 0.00000, -0.15000, 0.00000, 0.35357},
		{1.00000, 0.00000, 0.00000, -1.00000, 0.00000, -0.15000, 0.00000, 0.20357},
		{0.00000, 0.00000, 0.00000, -1.00000, 0.00000, -0.30000, 0.00000, 0.20357},
		{0.00000, 1.00000, 0.00000, -1.00000, 0.00000, -0.30000, 0.00000, 0.35357},
		{1.00000, 1.00000, 0.00000, 0.00000, -1.00000, 0.07500, 0.00000, 0.20357},
		{1.00000, 0.00000, 0.00000, 0.00000, -1.00000, 0.07500, 0.15000, 0.20357},
		{0.00000, 0.00000, 0.00000, 0.00000, -1.00000, -0.07500, 0.15000, 0.20357},
		{0.00000, 1.00000, 0.00000, 0.00000, -1.00000, -0.07500, 0.00000, 0.20357},
		{1.00000, 1.00000, 0.00000, 0.00000, 1.00000, -0.07500, 0.00000, 0.35357},
		{1.00000, 0.00000, 0.00000, 0.00000, 1.00000, -0.07500, 0.15000, 0.35357},
		{0.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.07500, 0.15000, 0.35357},
		{0.00000, 1.00000, 0.00000, 0.00000, 1.00000, 0.07500, 0.00000, 0.35357},
		{1.00000, 1.00000, -1.00000, 0.00000, 0.00000, -0.07500, 0.00000, 0.20357},
		{1.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.07500, 0.15000, 0.20357},
		{0.00000, 0.00000, -1.00000, 0.00000, 0.00000, -0.07500, 0.15000, 0.35357},
		{0.00000, 1.00000, -1.00000, 0.00000, 0.00000, -0.07500, 0.00000, 0.35357},
		{1.00000, 1.00000, 1.00000, 0.00000, 0.00000, 0.07500, 0.00000, 0.35357},
		{1.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.07500, 0.15000, 0.35357},
		{0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.07500, 0.15000, 0.20357},
		{0.00000, 1.00000, 1.00000, 0.00000, 0.00000, 0.07500, 0.00000, 0.20357},
		{1.00000, 1.00000, 0.00000, 1.00000, 0.00000, 0.07500, 0.15000, 0.20357},
		{1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.07500, 0.15000, 0.35357},
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, -0.07500, 0.15000, 0.35357},
		{0.00000, 1.00000, 0.00000, 1.00000, 0.00000, -0.07500, 0.15000, 0.20357},
		{1.00000, 1.00000, 0.00000, -1.00000, 0.00000, 0.07500, 0.00000, 0.35357},
		{1.00000, 0.00000, 0.00000, -1.00000, 0.00000, 0.07500, 0.00000, 0.20357},
		{0.00000, 0.00000, 0.00000, -1.00000, 0.00000, -0.07500, 0.00000, 0.20357},
		{0.00000, 1.00000, 0.00000, -1.00000, 0.00000, -0.07500, 0.00000, 0.35357},
		{1.00000, 1.00000, 0.00000, 0.00000, -1.00000, 0.30000, 0.00000, 0.20357},
		{1.00000, 0.00000, 0.00000, 0.00000, -1.00000, 0.30000, 0.15000, 0.20357},
		{0.00000, 0.00000, 0.00000, 0.00000, -1.00000, 0.15000, 0.15000, 0.20357},
		{0.00000, 1.00000, 0.00000, 0.00000, -1.00000, 0.15000, 0.00000, 0.20357},
		{1.00000, 1.00000, 0.00000, 0.00000, 1.00000, 0.15000, 0.00000, 0.35357},
		{1.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.15000, 0.15000, 0.35357},
		{0.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.30000, 0.15000, 0.35357},
		{0.00000, 1.00000, 0.00000, 0.00000, 1.00000, 0.30000, 0.00000, 0.35357},
		{1.00000, 1.00000, -1.00000, 0.00000, 0.00000, 0.15000, 0.00000, 0.20357},
		{1.00000, 0.00000, -1.00000, 0.00000, 0.00000, 0.15000, 0.15000, 0.20357},
		{0.00000, 0.00000, -1.00000, 0.00000, 0.00000, 0.15000, 0.15000, 0.35357},
		{0.00000, 1.00000, -1.00000, 0.00000, 0.00000, 0.15000, 0.00000, 0.35357},
		{1.00000, 1.00000, 1.00000, 0.00000, 0.00000, 0.30000, 0.00000, 0.35357},
		{1.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.30000, 0.15000, 0.35357},
		{0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.30000, 0.15000, 0.20357},
		{0.00000, 1.00000, 1.00000, 0.00000, 0.00000, 0.30000, 0.00000, 0.20357},
		{1.00000, 1.00000, 0.00000, 1.00000, 0.00000, 0.30000, 0.15000, 0.20357},
		{1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.30000, 0.15000, 0.35357},
		{0.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.15000, 0.15000, 0.35357},
		{0.00000, 1.00000, 0.00000, 1.00000, 0.00000, 0.15000, 0.15000, 0.20357},
		{1.00000, 1.00000, 0.00000, -1.00000, 0.00000, 0.30000, 0.00000, 0.35357},
		{1.00000, 0.00000, 0.00000, -1.00000, 0.00000, 0.30000, 0.00000, 0.20357},
		{0.00000, 0.00000, 0.00000, -1.00000, 0.00000, 0.15000, 0.00000, 0.20357},
		{0.00000, 1.00000, 0.00000, -1.00000, 0.00000, 0.15000, 0.00000, 0.35357},
		};


int City_index[City_polygoncount][3]={
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
		};

