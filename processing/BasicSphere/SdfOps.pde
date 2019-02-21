float length(PVector p) {
  float x = pow(p.x, 2);
  float y = pow(p.y, 2);
  float z = pow(p.z, 2);
  return sqrt(x+y+z);
}

float circle(PVector coord) {
    float w = img.width / 10.0;
    float radius = w / 2.0;
    PVector center = new PVector(0.0, 0.0);
    
    return PVector.dist(coord, center) - radius;
}

float sphere(PVector point, PVector center, float radius) {
  return length(point.sub(center)) - radius;
}

// Returns the distance to nearest object in the scene
float sdf(PVector point) {
    float sphere1 = sphere(point, new PVector(0.0, 0.0, 0.0), 1.0);
    float sphere2 = sphere(point, new PVector(1.0, 0.0, 0.0), 1.0);
    return min(sphere1, sphere2);
}


// Returns the distance along ray to nearest object, -1 otherwise
float march(PVector rayOrigin, PVector rayDirection) {
    float t = 0.0;
    PVector point = rayOrigin;
    
    for (int i = 0; i < 64; i++) {
      point = rayOrigin.add(rayDirection.mult(t));
        float dist = sdf(point);
        
        if (dist < 0.0001) {
          return t;
        }
        
        t += 0.0001 + dist; 
    }
    
    return -1.0;
}

PVector rayDirection(float fov, PVector resolution, PVector fragCoord) {
    PVector xy = fragCoord - resolution / 2.0;
    float z = resolution.y / tan(radians(fov) / 2.0);
    return normalize(PVector(-xy, -z));
}


PVector getRayDirection(PVector eye_position, PVector look_at_point, float fov, PVector fragCoord, PVector resolution) {
    PVector up = new PVector(0.0, 1.0, 0.0);
    
    PVector w = normalize(eye_position - look_at_point);
    PVector u = normalize(cross(w, up));
    PVector v = normalize(cross(w, u));
    
    // Camera to world matrix
    mat4 C2W =  mat4(vec4(u, 0.0f),
                vec4(v, 0.0f),
                vec4(w, 0.0f),
                vec4(0.0f, 0.0f, 0.0f, 1.0f));
    
    PVector viewDir = rayDirection(fov, resolution.xy, fragCoord);
    return normalize((C2W * vec4(viewDir, 0.0)).xyz);
    
}
