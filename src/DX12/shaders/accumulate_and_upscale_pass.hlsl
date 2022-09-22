// SRVs
Texture2D<float4> r_inputColor : register(t0);
Texture2D<float> r_inputDepth : register(t1);
Texture2D<float2> r_inputMotion : register(t2);

// UAVs
RWTexture2D<float4> rw_outputColor : register(u0);

#include "msr_global.hlsli"

[numthreads(8, 8, 1)]
void mainCS(
    int2 iGroupId : SV_GroupID,
    int2 iDispatchThreadId : SV_DispatchThreadID,
    int2 iGroupThreadId : SV_GroupThreadID,
    int iGroupIndex : SV_GroupIndex)
{
	uint2 iHrPx = iDispatchThreadId;
	float2 fLrPx = (float2(iHrPx) + float2(0.5, 0.5)) / upscaleFactor;
	float2 iLrPx = uint2(floor(fLrPx));
	
	float2 unjitteredUv = (fLrPx + jitter) / float2(renderSize);
	float4 unjitteredInputColor = r_inputColor.SampleLevel(s_linearClamp, unjitteredUv, 0);

	rw_outputColor[iHrPx] = unjitteredInputColor;
}

