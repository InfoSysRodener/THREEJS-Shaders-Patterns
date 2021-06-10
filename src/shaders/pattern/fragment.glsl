#define PI 3.14159265358979323846

uniform vec2 u_resolution;
uniform float u_time;

varying vec2 vUv;

float random (vec2 st) {
    return fract(sin(dot(st.xy,vec2(12.9898,78.233))) * 43758.5453123);
}

vec2 rotate (vec2 uv, float rotation, vec2 mid){
    return vec2(
        cos(rotation) * (uv.x - mid.x) + sin(rotation) * (uv.y - mid.y) + mid.x,
        cos(rotation) * (uv.y - mid.y) - sin(rotation) * (uv.x - mid.x) + mid.y
    );
}

//	Classic Perlin 2D Noise 
//	by Stefan Gustavson
//
vec2 fade(vec2 t) {return t*t*t*(t*(t*6.0-15.0)+10.0);}
vec4 permute(vec4 x){return mod(((x*34.0)+1.0)*x, 289.0);}
float cnoise(vec2 P){
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod(Pi, 289.0); // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;
  vec4 i = permute(permute(ix) + iy);
  vec4 gx = 2.0 * fract(i * 0.0243902439) - 1.0; // 1/41 = 0.024...
  vec4 gy = abs(gx) - 0.5;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;
  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);
  vec4 norm = 1.79284291400159 - 0.85373472095314 * 
    vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11));
  g00 *= norm.x;
  g01 *= norm.y;
  g10 *= norm.z;
  g11 *= norm.w;
  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));
  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}


// Simplex 2D noise

vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }

float snoise(vec2 v){
  const vec4 C = vec4(0.211324865405187, 0.366025403784439,
           -0.577350269189626, 0.024390243902439);
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);
  vec2 i1;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = mod(i, 289.0);
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
  + i.x + vec3(0.0, i1.x, 1.0 ));
  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy),
    dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

void main(){
    //#1
    // gl_FragColor = vec4(vUv, 0.3, 1.0);

    //#2
    //float strength =  vUv.y;

    //#3
    // float strength = 1.0 - vUv.y;

    //#4 
    // float strength = vUv.y * 10.0;

    // //#5
    // float strength = step(0.4,mod(vUv.y * 10.0, 1.0));
    // strength *= step(0.8,mod(vUv.x * 10.0, 1.0));

    // #6
    // float barX = step(0.4,mod(vUv.y * 10.0, 1.0));
    // barX *= step(0.8,mod(vUv.x * 10.0, 1.0));

    // float barY = step(0.4,mod(vUv.x * 10.0, 1.0));
    // barY *= step(0.8,mod(vUv.y * 10.0, 1.0));

    // float strength = barX + barY;


    // #7
    // float barX = step(0.4,mod(vUv.x * 10.0 + 0.2, 1.0));
    // barX *= step(0.8,mod(vUv.y * 10.0 + 0.2, 1.0));

    // float barY = step(0.8, mod(vUv.x * 10.0 + 0.4, 1.0));
    // barY *= step(0.4, mod(vUv.y * 10.0, 1.0));
    
    // float strength = barX + barY;

    // #8
    // float strength = abs(vUv.x - 0.5);

    // #9
    // float strength = min(abs(vUv.x - 0.5), abs(vUv.y - 0.5));

    //# 10
    // float strength = max(abs(vUv.x - 0.5), abs(vUv.y - 0.5));

    //# 11
    // float strength = step(0.2, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));

    //# 12
    // float square1 = step(0.2, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));
    // float square2 = 1.0 - step(0.25, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));
    // float strength = square1 * square2;

    // #13
    // float strength = floor(vUv.x * 10.0) / 10.0;

    // #14
    // float strength = floor(vUv.x * 10.0) / 10.0;
    // strength *= floor(vUv.y * 10.0) / 10.0;

    // #15
    // float strength = random(vUv);

    // #16
    // vec2 gridUv = vec2(
    //     floor(vUv.x * 10.0) / 10.0,
    //     floor(vUv.y * 10.0 + vUv.x * 5.0) / 10.0
    // );
    // float strength = random(gridUv);

    // #17
    // float strength = length(vUv);   

    // #18
    // float strength = distance(vUv, vec2(0.5));

    // #19
    // float strength = 1.0 - distance(vUv, vec2(0.5));  

    // #20
    // float strength = 0.015 / distance(vUv, vec2(0.5));

    // #21 
    // vec2 lightUv = vec2(
    //     vUv.x * 0.2 + 0.4,
    //     vUv.y 
    // );
    // float strength = 0.015 / distance(lightUv, vec2(0.5));  

    // #22
    // vec2 lightX = vec2(vUv.x * 0.1 + 0.45, vUv.y * 0.5 + 0.25);
    // vec2 lightY = vec2(vUv.y * 0.1 + 0.45, vUv.x * 0.5 + 0.25);
    // float strength = 0.015 / distance(lightX, vec2(0.5));  
    // strength *= 0.015 / distance(lightY, vec2(0.5));

    // #23
    // vec2 rotatedUv = rotate(vUv, PI * 0.25 , vec2(0.5));

    // vec2 lightX = vec2(rotatedUv.x * 0.1 + 0.45, rotatedUv.y * 0.5 + 0.25);
    // vec2 lightY = vec2(rotatedUv.y * 0.1 + 0.45, rotatedUv.x * 0.5 + 0.25);
    // float strength = 0.015 / distance(lightX, vec2(0.5));  
    // strength *= 0.015 / distance(lightY, vec2(0.5));


    // #24
    // float strength = step(0.25, distance(vUv, vec2(0.5)));

    // #25
    // float strength = abs(distance(vUv, vec2(0.5)) - 0.25);

    // #26
    // float strength = step(0.01 , abs(distance(vUv, vec2(0.5)) - 0.25));

    // #27
    // float strength = 1.0 - step(0.01 , abs(distance(vUv, vec2(0.5)) - 0.25));

    // #28
    // vec2 waveUv = vec2(
    //     vUv.x,
    //     vUv.y + sin(vUv.x * 30.0) * 0.1
    // );

    // float strength = 1.0 - step(0.01 , abs(distance(waveUv, vec2(0.5)) - 0.25));

    // #29
    // vec2 waveUv = vec2(
    //     vUv.x + sin(vUv.y * 30.0) * 0.1,
    //     vUv.y + sin(vUv.x * 30.0) * 0.1
    // );

    // float strength = 1.0 - step(0.01 , abs(distance(waveUv, vec2(0.5)) - 0.25));

    // #30
    // vec2 waveUv = vec2(
    //     vUv.x + sin(vUv.y * 100.0) * 0.1,
    //     vUv.y + sin(vUv.x * 100.0) * 0.1
    // );
    // float strength = 1.0 - step(0.01 , abs(distance(waveUv, vec2(0.5)) - 0.25));

    // #31  (ANGLE)
    // float angle = atan(vUv.x , vUv.y);
    // float strength = angle;

    // #32
    // float angle = atan(vUv.x - 0.5, vUv.y - 0.5);
    // float strength = angle;

    // #33 
    // float angle = atan(vUv.x - 0.5, vUv.y - 0.5);
    // angle /= PI * 2.0;
    // angle += 0.5;
    // float strength = angle;


    // #34
    //  float angle = atan(vUv.x - 0.5, vUv.y - 0.5);
    // angle /= PI * 2.0;
    // angle += 0.5;
    // angle = mod(angle * 20.0, 1.0);
    // float strength = angle;


    // #35
    // float angle = atan(vUv.x - 0.5, vUv.y - 0.5);
    // angle /= PI * 2.0;
    // angle += 0.5;
    // float sinusoid = sin(angle * 100.0);

    // float radius = 0.25 + sinusoid * 0.02;
    // float strength = 1.0 - step(0.01, abs(distance(vUv, vec2(0.5)) - radius));

    // Noise
    // #36
    // float strength = snoise(vUv * 10.0);

    // #37
    float strength = step(0.0 , snoise(vUv * 10.0));

    // #38
    // float strength = 1.0 - step(0.2 , snoise(vUv * 20.0));
    // vec3 blackColor = vec3(0.0);
    // vec3 uvColor = vec3(vUv, 0.5);

    // vec3 mixedColor = mix(blackColor, uvColor, strength);
 
    // gl_FragColor = vec4(mixedColor, 1.0);
    gl_FragColor = vec4(strength,strength,strength, 1.0);
}