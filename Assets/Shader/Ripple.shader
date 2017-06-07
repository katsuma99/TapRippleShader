Shader "Custom/Ripple" {
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_StartTime("StartTime", Float) = 0
		_AnimationTime("AnimationTime", Float) = 0.4
		[MaterialToggle] PixelSnap("Pixel snap", Float) = 1
	}

		SubShader
	{
		Tags
	{
		"Queue" = "Transparent"
		"IgnoreProjector" = "True"
		"RenderType" = "Transparent"
		"PreviewType" = "Plane"
		"CanUseSpriteAtlas" = "True"
	}

		Cull Off
		Lighting Off
		ZWrite Off
		Fog{ Mode Off }
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
	{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma multi_compile DUMMY PIXELSNAP_ON
#include "UnityCG.cginc"

		struct appdata_t
		{
			float4 vertex   : POSITION;
			float4 color    : COLOR;
			float2 texcoord : TEXCOORD0;
			uint vertexId : SV_VertexID;
		};

		struct v2f
		{
			float4 vertex   : SV_POSITION;
			fixed4 color : COLOR;
			half2 texcoord  : TEXCOORD0;
		};

		v2f vert(appdata_t IN)
		{
			v2f OUT;
			OUT.vertex = UnityObjectToClipPos(IN.vertex);
			OUT.texcoord = IN.texcoord;
			OUT.color = IN.color;
			return OUT;
		}

		fixed3 shift_col(fixed3 RGB, half3 shift)
		{
			fixed3 RESULT = fixed3(RGB);
			float VSU = shift.z*shift.y*cos(shift.x*3.14159265 / 180);
			float VSW = shift.z*shift.y*sin(shift.x*3.14159265 / 180);

			RESULT.x = (.299*shift.z + .701*VSU + .168*VSW)*RGB.x
				+ (.587*shift.z - .587*VSU + .330*VSW)*RGB.y
				+ (.114*shift.z - .114*VSU - .497*VSW)*RGB.z;

			RESULT.y = (.299*shift.z - .299*VSU - .328*VSW)*RGB.x
				+ (.587*shift.z + .413*VSU + .035*VSW)*RGB.y
				+ (.114*shift.z - .114*VSU + .292*VSW)*RGB.z;

			RESULT.z = (.299*shift.z - .3*VSU + 1.25*VSW)*RGB.x
				+ (.587*shift.z - .588*VSU - 1.05*VSW)*RGB.y
				+ (.114*shift.z + .886*VSU - .203*VSW)*RGB.z;

			return (RESULT);
		}

		sampler2D _MainTex;
		float _StartTime;
	fixed4 frag(v2f IN) : SV_Target
	{

		fixed4 c = tex2D(_MainTex, IN.texcoord);
		c.rgb = IN.color.rgb;
		//c.rgb *= c.a;

	float2 pos = (IN.texcoord - float2(0.5,0.5)) * 2; //-1^1

	float width = 0.3;
		float dis = (_Time.y - _StartTime)*1.5 + 0.5 - length(pos);
	if (dis < 0 || dis > width*1.5)
		return fixed4(0,0,0,0);
	
	float alpha = clamp((width - dis) * 3,0.1,1);

	half3 shift = half3(_Time.w*10, 1, 1);
	
	return fixed4(shift_col(c,shift), c.a * alpha);
	}
		ENDCG
	}
	}
	

			SubShader{
		Lighting Off
		Blend SrcAlpha OneMinusSrcAlpha // Alpha blending
		Pass{
		CGPROGRAM
#pragma vertex vert_img
#pragma fragment frag

#include "UnityCG.cginc"

		uniform sampler2D _MainTex;

	float4 frag(v2f_img i) : COLOR{
		fixed4 c = tex2D(_MainTex, i.uv);
	return c;
	}
		ENDCG
	}
	}


}
