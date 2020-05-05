struct VSOutput
{
    float4 position : SV_POSITION;
    float2 texCoord : TEXCOORD;
};
Texture2D<float4> texture0 : register(t1, space0);
SamplerState samplerState0 : register(s2);
float4 main(VSOutput input) : SV_TARGET
{
    return texture0.Sample(samplerState0, input.texCoord);
};

