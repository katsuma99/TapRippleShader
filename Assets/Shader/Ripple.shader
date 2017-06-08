Shader "Custom/Ripple" {
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_StartTime("StartTime", Float) = 0
		_AnimationTime("AnimationTime", Float) = 1.5
			_Width("Width", Float) = 0.3
			_StartWidth("StartWidth", Float) = 0.3
			[MaterialToggle] _isAlpha("isAlpha",Float) = 1
			[MaterialToggle] _isColorShift("isColorShift",Float) = 1
		[MaterialToggle] PixelSnap("Pixel snap", Float) = 1
	}

		SubShader
	{
		Tags
	{
		"Queue" = "Transparent"
		"IgnoreProjector" = "True"
		"PreviewType" = "Plane"
	}

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

		struct v2f
		{
			float4 vertex   : SV_POSITION;
			half2 texcoord  : TEXCOORD0;
		};

		v2f vert(appdata_base IN)
		{
			v2f OUT;
			OUT.vertex = UnityObjectToClipPos(IN.vertex);
			OUT.texcoord = IN.texcoord;
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

			return RESULT;
		}

		sampler2D _MainTex;
		float _StartTime,_Width,_StartWidth, _AnimationTime, _isAlpha,_isColorShift;
	fixed4 frag(v2f IN) : SV_Target
	{

		fixed4 color = tex2D(_MainTex, IN.texcoord);
		float2 pos = (IN.texcoord - float2(0.5,0.5)) * 2; //-1^1
		float dis = (_Time.y - _StartTime) / _AnimationTime + _StartWidth - length(pos);
		
		if (dis < 0 || dis > _Width)
			return fixed4(0,0,0,0);
	
		float alpha = 1;
		if (_isAlpha == 1) 
		{
			alpha = clamp((_Width - dis) * 3, 0.1, 1);
		}

		fixed3 shiftColor = color;
		if (_isColorShift == 1)
		{
			half3 shift = half3(_Time.w * 10, 1, 1);
			shiftColor = shift_col(color, shift);
		}

		return fixed4(shiftColor, color.a * alpha);
	}
		ENDCG
	}
	}
			Fallback "Sprites/Default"


}
