#define egDrawJasModel(NAME) {\
    glEnableClientState(GL_INDEX_ARRAY);\
    glEnableClientState(GL_NORMAL_ARRAY);\
    glEnableClientState(GL_VERTEX_ARRAY);\
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);\
    glInterleavedArrays(GL_T2F_N3F_V3F,0,NAME ## _vertex);\
	glDrawElements(GL_TRIANGLES,NAME ## _polygoncount*3,GL_UNSIGNED_INT,NAME ## _index);\
}
