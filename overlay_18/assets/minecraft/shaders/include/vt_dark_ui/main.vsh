#define NEW_INVENTORY_TEXT_COLOUR 0xbcbcbc


bool _ingui(mat4 projectionMat) {
    return projectionMat[2][3] == 0.0;
}
int _toint(vec3 col) {
  ivec3 icol = ivec3(col*255);
  return (icol.r << 16) + (icol.g << 8) + icol.b;
}
vec3 _tovec(int col) {
    return vec3(col >> 16, (col >> 8) % 256, col % 256) / 255.;
}

#define ORIGINAL_INVENTORY_TEXT_COLOUR 0x404040

vec4 recolourText(vec4 colourAttribute, mat4 projectionMatrix) {
    if(!_ingui(projectionMatrix)) return colourAttribute;

    if(_toint(colourAttribute.rgb) == ORIGINAL_INVENTORY_TEXT_COLOUR) {
        return vec4(_tovec(NEW_INVENTORY_TEXT_COLOUR), colourAttribute.a);
    }
    return colourAttribute;
}