uniform mat4 u_Color;
varying vec2 v_TexCoord;
varying vec2 v_TexCoord2;
uniform sampler2D u_Tex0;

const float ALPHA_TOLERANCE = 0.01;

void main()
{
    vec4 baseColor = texture2D(u_Tex0, v_TexCoord);
    vec4 texcolor = texture2D(u_Tex0, v_TexCoord2);
    if(texcolor.r > 0.9) {
        baseColor *= texcolor.g > 0.9 ? u_Color[0] : u_Color[1];
    } else if(texcolor.g > 0.9) {
        baseColor *= u_Color[2];
    } else if(texcolor.b > 0.9) {
        baseColor *= u_Color[3];
    }

    vec4 pixel1 = texture2D(u_Tex0, vec2(v_TexCoord.x + 0.001, v_TexCoord.y));
    vec4 pixel2 = texture2D(u_Tex0, vec2(v_TexCoord.x - 0.001, v_TexCoord.y));
    vec4 pixel3 = texture2D(u_Tex0, vec2(v_TexCoord.x, v_TexCoord.y + 0.001));
    vec4 pixel4 = texture2D(u_Tex0, vec2(v_TexCoord.x, v_TexCoord.y - 0.001));
    
    bool neighbourColor = pixel4.a > ALPHA_TOLERANCE || pixel3.a > ALPHA_TOLERANCE || pixel2.a > ALPHA_TOLERANCE;


    if (baseColor.a < ALPHA_TOLERANCE && neighbourColor) {
        baseColor.rgb = vec3(1.0, 0.0, 0.0);
        baseColor.a = 0.7;
    }
    
    gl_FragColor = baseColor;
    if(gl_FragColor.a < 0.01) discard;
}