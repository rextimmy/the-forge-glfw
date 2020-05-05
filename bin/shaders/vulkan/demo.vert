#version 450 core

precision highp float;
precision highp int; 
vec4 MulMat(mat4 lhs, vec4 rhs)
{
    vec4 dst;
	dst[0] = lhs[0][0]*rhs[0] + lhs[0][1]*rhs[1] + lhs[0][2]*rhs[2] + lhs[0][3]*rhs[3];
	dst[1] = lhs[1][0]*rhs[0] + lhs[1][1]*rhs[1] + lhs[1][2]*rhs[2] + lhs[1][3]*rhs[3];
	dst[2] = lhs[2][0]*rhs[0] + lhs[2][1]*rhs[1] + lhs[2][2]*rhs[2] + lhs[2][3]*rhs[3];
	dst[3] = lhs[3][0]*rhs[0] + lhs[3][1]*rhs[1] + lhs[3][2]*rhs[2] + lhs[3][3]*rhs[3];
    return dst;
}


layout(location = 0) in vec3 POSITION;
layout(location = 1) in vec2 TEXCOORD;
layout(location = 0) out vec2 vertOutput_TEXCOORD;

struct VSInput
{
    vec3 position;
    vec2 texCoord;
};
struct VSOutput
{
    vec4 position;
    vec2 texCoord;
};
layout(row_major, push_constant) uniform UniformBlockRootConstant_Block
{
    mat4 worldViewProj;
}UniformBlockRootConstant;

VSOutput HLSLmain(VSInput input1)
{
    VSOutput result;
    ((result).position = MulMat(UniformBlockRootConstant.worldViewProj,vec4((input1).position, 1.0)));
    ((result).texCoord = (input1).texCoord);
    return result;
}
void main()
{
    VSInput input1;
    input1.position = POSITION;
    input1.texCoord = TEXCOORD;
    VSOutput result = HLSLmain(input1);
    gl_Position = result.position;
    vertOutput_TEXCOORD = result.texCoord;
}
