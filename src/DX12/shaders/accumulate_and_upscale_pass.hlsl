#include "msr_global.hlsli"

void accumulateFrameColor(float4 currFrameUpsampledColor, inout float4 historyUpscaledColor)
{
	historyUpscaledColor.a += currFrameUpsampledColor.a;
	float alpha = currFrameUpsampledColor.a / historyUpscaledColor.a;
	historyUpscaledColor.rgb = lerp(historyUpscaledColor.rgb, currFrameUpsampledColor.rgb, alpha);
	historyUpscaledColor.a = clamp(historyUpscaledColor.a, 0, 40);
}

[numthreads(8, 8, 1)]
void mainCS(
    int2 iGroupId : SV_GroupID,
    int2 iDispatchThreadId : SV_DispatchThreadID,
    int2 iGroupThreadId : SV_GroupThreadID,
    int iGroupIndex : SV_GroupIndex)
{
	uint2 iHrPx = iDispatchThreadId;
	float2 fLrPx = (float2(iHrPx) + broadcast_f2(0.5)) / upscaleFactor;
	float2 iLrPx = uint2(floor(fLrPx));
	
	// this uv can be used in jittered texture as if no jitter has happened
	float2 unjitteredUv = (fLrPx + jitter) / float2(renderSize);
	// this position can be seen as jittered sampling position when rasterizing low res framebuffer
	float2 jitteredSamplePos = float2(iLrPx) + broadcast_f2(0.5) - jitter;

	float4 historyUpscaledColor = r_internalColor[iHrPx];
	float4 currUpsampledColor = r_inputColor[iLrPx];
	currUpsampledColor.a = 1.0;
	accumulateFrameColor(currUpsampledColor, historyUpscaledColor);
	rw_outputColor[iHrPx] = historyUpscaledColor;
	rw_internalColor[iHrPx] = historyUpscaledColor;
}

