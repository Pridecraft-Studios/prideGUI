#version 150

#define INVENTORY_TEXT_COLOUR 0xffffff

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

out float sphericalVertexDistance;
out float cylindricalVertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

bool ingui(mat4 projectionMat) {
    return projectionMat[2][3] == 0.0;
}
int toint(vec3 col) {
  ivec3 icol = ivec3(col*255);
  return (icol.r << 16) + (icol.g << 8) + icol.b;
}
vec3 tovec(int col) {
    return vec3(col >> 16, (col >> 8) % 256, col % 256) / 255.;
}

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);

    vec4 col = Color;
    if(ingui(ProjMat) && toint(col.rgb) == 0x404040) {
        col.rgb = tovec(INVENTORY_TEXT_COLOUR);
    }

    vertexColor = col * texelFetch(Sampler2, UV2 / 16, 0);

    texCoord0 = UV0;
}
