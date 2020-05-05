#version 450 core

precision highp float;
precision highp int; 

layout(location = 0) in vec2 fragInput_TEXCOORD;
layout(location = 0) out vec4 rast_FragData0; 

struct VSOutput
{
    vec4 position;
    vec2 texCoord;
};
layout(set = 0, binding = 1) uniform texture2D texture0;
layout(set = 0, binding = 2) uniform sampler samplerState0;
vec4 HLSLmain(VSOutput input1)
{
    return texture(sampler2D(texture0, samplerState0), (input1).texCoord);
}
void main()
{
    VSOutput input1;
    input1.position = vec4(gl_FragCoord.xyz, 1.0 / gl_FragCoord.w);
    input1.texCoord = fragInput_TEXCOORD;
    vec4 result = HLSLmain(input1);
    rast_FragData0 = result;
}
