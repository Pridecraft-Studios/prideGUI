#version 150

#moj_import <minecraft:light.glsl>
#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:vt_dark_ui/main.vsh>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

out float sphericalVertexDistance;
out float cylindricalVertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

bool isgui(mat4 ProjMat) {
    return ProjMat[2][3] == 0.0;
}

#ifndef VT_WARM_GLOW_ENABLED
vec4 minecraft_sample_lightmap(sampler2D lightMap, ivec2 uv) {
    return texelFetch(lightMap, uv / 16, 0);
}
#endif

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);

    // warm glow
    vec4 lightColour = isgui(ProjMat) ? texelFetch(Sampler2, UV2 / 16, 0) : minecraft_sample_lightmap(Sampler2, UV2);
    vertexColor = recolourText(Color, ProjMat) * lightColour;
    texCoord0 = UV0;
}
