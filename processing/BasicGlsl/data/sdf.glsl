// https://www.shadertoy.com/view/3sfXRN

uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iTime;                 // shader playback time (in seconds)
uniform float     iTimeDelta;            // render time (in seconds)
uniform int       iFrame;                // shader playback frame
//uniform float     iChannelTime[4];       // channel playback time (in seconds)
//uniform vec3      iChannelResolution[4]; // channel resolution (in pixels)
//uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
//uniform samplerXX iChannel0..3;          // input channel. XX = 2D/Cube
uniform vec4      iDate;                 // (year, month, day, time in seconds)
uniform float     iSampleRate;           // sound sample rate (i.e., 44100)

// **********************************************
// Camera Functions

vec3 RayDirection(float fov, vec2 resolution, vec2 fragCoord) {
    vec2 xy = fragCoord - resolution / 2.0;
    float z = resolution.y / tan(radians(fov) / 2.0);
    return normalize(vec3(-xy, -z));
}


vec3 GetRayDirection(vec3 eye_position, vec3 look_at_point, float fov, vec2 fragCoord, vec2 resolution) {
    vec3 up = vec3(0.0f, 1.0f, 0.0f);
    
    vec3 w = normalize(eye_position - look_at_point);
    vec3 u = normalize(cross(w, up));
    vec3 v = normalize(cross(w, u));
    
    // Camera to world matrix
    mat4 C2W =  mat4(vec4(u, 0.0f),
                vec4(v, 0.0f),
                vec4(w, 0.0f),
                vec4(0.0f, 0.0f, 0.0f, 1.0f));
    
    vec3 viewDir = RayDirection(fov, resolution.xy, fragCoord);
    return normalize((C2W * vec4(viewDir, 0.0)).xyz);   
}

// **********************************************
// Scene configuration

float sphere(vec3 point, vec3 center, float radius) {
	return length(point-center)-radius;
}

float box(vec3 point, vec3 center, vec3 dimensions) {
  	return length(max(abs(point - center)-dimensions,0.0));
}

float smin( float a, float b, float k ) {
    float h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
    return mix( b, a, h ) - k*h*(1.0-h);
}

// Returns the distance to nearest object in the scene
float sdf(vec3 point) {
    float box = box(point, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
    float sphere1 = sphere(point, vec3(1.0, 0.0, 0.0), 1.0);
    return smin(box, sphere1, 0.2);
}

vec3 normal(vec3 point) {
    float xPos = sdf(vec3(point.x + 0.0001, point.y, point.z));
    float xNeg = sdf(vec3(point.x - 0.0001, point.y, point.z));
    
    float yPos = sdf(vec3(point.x, point.y + 0.0001, point.z));
    float yNeg = sdf(vec3(point.x, point.y - 0.0001, point.z));
    
    float zPos = sdf(vec3(point.x, point.y, point.z + 0.0001));
    float zNeg = sdf(vec3(point.x, point.y, point.z - 0.0001));
    
    return normalize(vec3(xPos - xNeg, yPos - yNeg, zPos - zNeg));
}

// **********************************************
// Ray-marching

// Returns the distance along ray to nearest object, -1 otherwise
float march(vec3 rayOrigin, vec3 rayDirection) {
    float t = 0.0;
    vec3 point = rayOrigin;
    
    for (int i = 0; i < 256; i++) {
    	point = rayOrigin + t * rayDirection;
        float dist = sdf(point);
        
        if (dist < 0.00001) return t;
        
        t += 0.00001 + dist; 
    }
    
    return -1.0;
}

vec4 background(vec3 direction) {
	return vec4(direction, 1.0); //texture(iChannel0, direction);
}

vec4 shade(float t, vec3 eye, vec3 direction) {
	vec3 point = eye + t * direction;
    return vec4(normal(point), 1.0);
}

// **********************************************
// Main

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec3 eye = vec3(7.5f, 1.0f, 7.5f);	    // Position of the camera
    vec3 look_at = vec3(0.0f, 0.0f, 0.0f);  // A point the camera is looking at
    
    #if MOVE_CAMERA
    eye.x *= sin(iTime * CAMERA_SPEED);
    eye.z *= cos(iTime * CAMERA_SPEED);
    eye.y *= sin(iTime * CAMERA_SPEED);
    #endif
    
    // Math stuff, computes the direction of the current ray by setting
    // up a camera matrix with the given position and looking direction.
    vec3 worldDir = GetRayDirection(eye, look_at, 45.0, fragCoord, iResolution.xy);
    
    float t = march(eye, worldDir);
    
    if (t < 0.0) {
    	// Didnt hit any objects
        fragColor = background(worldDir);
    } else {
    	// Hit something
        fragColor = shade(t, eye, worldDir);
    }
}

void main() {
	mainImage(gl_FragColor, gl_FragCoord.xy);
}

