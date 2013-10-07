//
//  Shader.fsh
//  Trains3Di
//
//  Created by Anton Zherdev on 07.10.13.
//  Copyright (c) 2013 Anton Zherdev. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
