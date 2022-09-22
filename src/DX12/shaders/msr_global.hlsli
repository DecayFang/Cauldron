// constants
cbuffer cb : register(b0)
{
	float2 jitter;
	uint2 renderSize;
	uint2 displaySize;
	float upscaleFactor;
};

// static samplers
SamplerState s_pointClamp : register(s0);
SamplerState s_linearClamp : register(s1);

// utils

