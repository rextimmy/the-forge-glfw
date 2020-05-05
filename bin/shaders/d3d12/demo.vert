struct VSInput
{
    float3 position : POSITION;
    float2 texCoord : TEXCOORD;
};
struct VSOutput
{
    float4 position : SV_POSITION;
    float2 texCoord : TEXCOORD;
};
cbuffer UniformBlockRootConstant : register(b0)
{
    float4x4 worldViewProj;
};

VSOutput main(VSInput input)
{
    VSOutput result;
    (result.position = mul(worldViewProj, float4(input.position, 1.0)));
    (result.texCoord = input.texCoord);
    return result;
};

