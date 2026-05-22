#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>
#moj_import <vt_dark_ui/main.vsh>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

bool isgui(mat4 ProjMat) {
    return ProjMat[2][3] == 0.0;
}

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(Position, FogShape);
    
    // warm glow
    vec4 lightColour = isgui(ProjMat) ? texelFetch(Sampler2, UV2 / 16, 0) : minecraft_sample_lightmap(Sampler2, UV2);
    vertexColor = recolourText(Color, ProjMat) * lightColour;
    texCoord0 = UV0;
}
