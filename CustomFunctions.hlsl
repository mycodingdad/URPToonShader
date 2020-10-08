void LWRPLightingFunction_float(float3 ObjPos, out float3 Direction, out float3 Color, out float ShadowAttenuation)
{
#ifdef LIGHTWEIGHT_LIGHTING_INCLUDED
   
      //Actual light data from the pipeline
      Light light = GetMainLight(GetShadowCoord(GetVertexPositionInputs(ObjPos)));
      Direction = light.direction;
      Color = light.color;
      ShadowAttenuation = light.shadowAttenuation;
      
#else
   
      //Hardcoded data, used for the preview shader inside the graph
      //where light functions are not available
    Direction = float3(-0.5, 0.5, -0.5);
    Color = float3(1, 1, 1);
    ShadowAttenuation = 0.7;
      
#endif
}

void MainLight_float(float3 WorldPos, out float3 Direction, out float3 Color, out float DistanceAtten, out float ShadowAtten)
{
#if SHADERGRAPH_PREVIEW
   Direction = half3(0.5, 0.5, 0);
   Color = 1;
   DistanceAtten = 1;
   ShadowAtten = 1;
#else
#if SHADOWS_SCREEN
   float4 clipPos = TransformWorldToHClip(WorldPos);
   float4 shadowCoord = ComputeScreenPos(clipPos);
#else
    float4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
#endif
    Light mainLight = GetMainLight(shadowCoord);
    Direction = mainLight.direction;
    Color = mainLight.color;
    DistanceAtten = mainLight.distanceAttenuation;
    ShadowAtten = mainLight.shadowAttenuation;
#endif
}