// SRVs
Texture2D<float4> r_inputColor : register(t0);
Texture2D<float> r_inputDepth : register(t1);
Texture2D<float2> r_inputMotion : register(t2);
Texture2D<float4> r_internalColor : register(t3);

// UAVs
RWTexture2D<float4> rw_outputColor : register(u0);
RWTexture2D<float4> rw_internalColor : register(u1);

// constants
cbuffer cb : register(b0)
{
	float2 jitter;
	uint2 renderSize;
	uint2 displaySize;
	float upscaleFactor;
	uint isOddFrame;
};

// static samplers
SamplerState s_pointClamp : register(s0);
SamplerState s_linearClamp : register(s1);

// utils
static const float EPSILON = 1e-06f;

float2 broadcast_f2(float val)
{
	return float2(val, val);
}

float3 broadcast_f3(float val)
{
	return float3(val, val, val);
}

float4 broadcast_f4(float val)
{
	return float4(val, val, val, val);
}

