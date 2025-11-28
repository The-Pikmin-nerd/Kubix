shader_type spatial;

render_mode unshaded, blend_premul_alpha;

uniform float radius;
uniform float height;
uniform sampler2D noise;
uniform sampler3D noise3D;
instance uniform bool fromOutside;

void fragment() {
	mat4 inv_view_model = inverse(MODEL_MATRIX) * INV_VIEW_MATRIX;
	vec3 campos = (inv_view_model * vec4(0, 0, 0, 1)).xyz;
	vec3 ld = -normalize((inv_view_model * vec4(VIEW, 0)).xyz);  //ray direction in local space
	vec3 lp; //ray position in local space
	float step_size = 0.0265;
	if (fromOutside)
		lp = (inv_view_model * vec4(VERTEX, 1)).xyz; //if rendering from outside start ray from the surface of the cylinder
	else
		lp = campos; //if rendering from inside start ray from camera
	bool in_bounds = false, prev_in_bounds = false;
	
	float T = 1.0; //transmition
	vec3 L = vec3(0, 0, 0); //luminosity
	float et = TIME * 0.05;
	for (int i = 0; i < 180; i++)
	{
		step_size *= 1.0055; //gradually increase step size
		lp += ld * step_size;
		float l = length(lp.xz);
		float ang = atan(lp.z, lp.x);
		
		//2d polar noise texture sample
		float n = clamp(-max(0.0, 0.8 - l) + texture(noise, vec2(ang / (2.0 * PI) + et * 0.5, l * 0.35)).r, 0.0, 1.0);
		
		//3d polar noise texture sample
		float n3 = texture(noise3D, vec3(1.5 * ang / PI + et, lp.y, log(l * 5.0))).r;
		
		float ct = cos(et * 1.5), st = sin(et * 1.5);
		float n3o = texture(noise3D, vec3(lp.x * ct - lp.z * st, lp.y, lp.x * st + lp.z * ct) * 0.5).r; //3d cartesian noise texture sample
		
		vec3 nlp = lp + 0.12 * (l + 1.0) * (n - 0.5) * 0.5; //ray position distorted by noise
		float nl = length(nlp.xz);
		float r = nl * 1.85 - 1.2;
		float t = mod(atan(nlp.z, nlp.x), PI);
		float diff = abs(mod((r - t + 0.5 * PI), (PI)) - 0.5 * PI); //distance from spiral
		
		float factor = (1.0 + tanh(3.0 * r)) * 0.6 * max(0.0, 0.42 - pow(diff, 2.0)), l2 = l * l, lpy2 = lp.y * lp.y;
		float spiral_density = (0.5 * max(0.0, 1.15 - pow(diff, 0.15)) + factor) * max(0.0, 1.0 - sqrt(0.045 * l2 + 24.0 * lpy2)) * (1.5 * n + 0.55) * 0.4;
		float core_density = 40.0 * pow(max(0.0, 0.45 - sqrt(0.3 * lp.x * lp.x + lp.z * lp.z + 3.0 * lp.y * lp.y)), 2.0) + 5.0 * pow(max(0.0, 0.65 - sqrt(0.45 * lp.x * lp.x + lp.z * lp.z + 4.0 * lpy2)), 1.5) * (n + 0.5);
		float particle_density = (0.3 * max(0.0, 1.25 - pow(diff, 0.15)) + factor) * max(0.0, 1.0 - pow(0.045 * l2 + 16.0 * lpy2, 4.0)) * (1.0 - abs(4.0 * lp.y)) * 400.0;
		float dust_density = pow(max(0.0, n3 - 0.2), 1.5) * particle_density;
		float gas_density = pow(max(0.0, abs(n3o - 0.55) - 0.12), 2.0) * particle_density * 1.2 * max(0.0, 1.0 - 0.35 *  diff - pow(0.2 * l, 0.4)) * (0.5 - abs(2.5 * lp.y));
		vec3 star_col = mix(vec3(0.45, 0.6, 1.0), vec3(1.0, 0.5, 0.2), pow(max(0.0, 1.0 - 0.2 * l), 1.8));

		float prox = tanh(distance(campos, lp) * 0.4); // reduce intensity close to the camera
		T *= exp(-(spiral_density + core_density + dust_density + gas_density) * prox * step_size * 0.2);
		L += prox * T * (star_col * vec3(spiral_density * 12.0 + core_density * 6.0 + vec3(0.7, 0.4, 0.3) * dust_density * 0.02) + vec3(1.0, 0.3, 0.3) * gas_density * 8.0) * step_size * 2.0;

		in_bounds = l < radius;
		if (T <= 0.005 || ((lp.y < -height * 0.5 || lp.y > height * 0.5) && (campos.y * lp.y < 0.0 || abs(lp.y) > abs(campos.y)))  || (!in_bounds && prev_in_bounds))
			break;
		prev_in_bounds = in_bounds;
	}

	ALPHA = 1.0 - T;
	ALBEDO = L;
}